#!/bin/sh
set -e

echo "➡️ Running migrations..."
uv run manage.py makemigrations --noinput || true
uv run manage.py migrate --noinput

echo "➡️ Starting Gunicorn..."
exec "$@"

