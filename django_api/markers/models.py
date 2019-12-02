from django.db import models


class Marker(models.Model):
    user_id = models.IntegerField(blank=False, null=False)
    title = models.CharField(max_length=200, blank=False, null=False)
    description = models.CharField(max_length=200, blank=False, null=False)
    latitude = models.FloatField(blank=False, null=False)
    longitude = models.FloatField(blank=False,null=False)
