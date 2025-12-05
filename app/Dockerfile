
FROM python:latest

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
  && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --upgrade pip && \
    pip install -r requirements.txt

COPY . .


WORKDIR /app/filemanager
#ENV DJANGO_SETTINGS_MODULE=filemanager.settings \
#    PORT=8000
ENV DJANGO_SETTINGS_MODULE=filemanager.settings
# RUN python manage.py collectstatic --noinput

RUN python manage.py collectstatic --noinput

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8000

#CMD ["gunicorn", "filemanager.wsgi:application", "--bind", "0.0.0.0:8000"]

CMD ["gunicorn", "filemanager.wsgi:application", \
    "--bind=0.0.0.0:8000", \
    "--workers=4", \
    "--timeout=60", \
    "--log-level=info"]