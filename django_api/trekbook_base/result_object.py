from abc import ABC, abstractmethod


class ApiResult(ABC):

    @abstractmethod
    def serialize(self, version: int = 1) -> dict:
        """

        :param version:
        :return:
        """
        return None


class BaseApiResult(ApiResult):
    def serialize(self, version: int = 1) -> dict:
        serialized = {
            k: v for k, v in self.__dict__.items()
            # if not k.startswith('_')
        }
        return serialized
