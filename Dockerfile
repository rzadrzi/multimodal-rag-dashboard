FROM ghcr.io/astral-sh/uv:0.9.5-python3.14-trixie-slim

# Install the project into `/app`
WORKDIR /app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_LINK_MODE=copy \
    UV_PYTHON_DOWNLOADS=never \
    UV_PROJECT_ENVIRONMENT=/app/.venv\
    UV_COMPILE_BYTECODE=1\
    UV_TOOL_BIN_DIR=/usr/local/bin

# install uv
COPY --from=ghcr.io/astral-sh/uv:0.8.14 /uv /uvx /bin/

# Since there's no point in shipping lock files, we move them
# into a directory that is NOT copied into the runtime image.
# The trailing slash makes COPY create `/_lock/` automagically.
COPY pyproject.toml uv.lock /_lock/

# Synchronize dependencies.
# This layer is cached until uv.lock or pyproject.toml change.
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --locked --no-install-project --no-dev


# copy project
COPY . .

RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --locked --no-dev

# Set working directory to Django project
WORKDIR /app/filemanager

# Django settings module
ENV DJANGO_SETTINGS_MODULE=filemanager.settings

# Expose port
EXPOSE 8000

RUN uv run manage.py collectstatic --noinput

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["uv", "run", "gunicorn", "filemanager.wsgi:application", \
    "--bind=0.0.0.0:8000", \
    "--workers=4", \
    "--timeout=60", \
    "--log-level=info"]

# uv run gunicorn filemanager.wsgi:application --bind=0.0.0.0:8000 --workers=4 --timeout=60 --log-level=info
# docker exec -it <container_id> bash
# cd ..
# uv run filemanager/manage.py makemigrations
# uv run filemanager/manage.py migrate

