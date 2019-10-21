from django.urls import reverse
from copy import deepcopy
from trekbook_base.result_object import ApiResult
from django.http import HttpResponse
from django.core.serializers.json import DjangoJSONEncoder
import json
from trekbook_base.exceptions import TrekbookException

API_VERSION = 1


def check_admin_site(request) -> bool:
    return request.path.startswith(reverse('admin:index'))


class ApiResponse(HttpResponse):
    def __init__(self, data, **kwargs):

        data = json.dumps(data, cls=DjangoJSONEncoder)
        kwargs.setdefault('content_type', 'application/json')
        super().__init__(content=data, **kwargs)


class TrekbookMiddleware(object):
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):

        if check_admin_site(request):
            return self.get_response(request)

        request.query_params = {k: request.GET[k] for k in request.GET}

        request.headers = dict()
        for key, val in request.META.items():
            request.headers[key] = val

        if hasattr(request, 'body') and request.body:
            if request.method == 'POST':
                # request.data = deepcopy(dict(request.body))
                body_unicode = request.body.decode('utf-8')
                body = json.loads(body_unicode)
                request.data = body

        return self.get_response(request)

    def get_success_response(self, result: ApiResult):
        response = {}

        data = dict()
        if result is not None:
            if isinstance(result, dict):
                data = result
            elif isinstance(result, list):
                data = [i.serialize(version=API_VERSION) for i in result]
            else:
                data = result.serialize(version=API_VERSION)

        response['data'] = data
        response['code'] = 200

        return ApiResponse(response, status=200)

    def get_error_response(self, exception: Exception, request):
        if isinstance(exception, TrekbookException):
            message = str(exception)
            status_code = exception.http_code
        else:
            message = 'There was a problem with your request.'
            status_code = 500

        response = {}
        data = {'message': message, 'error_type': exception.__class__.__name__}

        response['data'] = data
        response['code'] = status_code

        return ApiResponse(response, status=status_code)

    def process_view(self, request, view_func, view_args, view_kwargs):

        if check_admin_site(request):
            return view_func(request, *view_args, **view_kwargs)

        try:
            # check if user session is valid

            result = view_func(request, *view_args, **view_kwargs)
            response = self.get_success_response(result)
        except Exception as e:
            response = self.get_error_response(e, request)

        return response