import os
from celery import Celery

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "app.settings")

celery_app = Celery("worker")
celery_app.config_from_object("django.conf:settings", namespace="CELERY")

# Make sure Celery also finds tasks inside your worker directory
celery_app.autodiscover_tasks(["worker"])
