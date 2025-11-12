FROM ghcr.io/astral-sh/uv:0.9.5-python3.14-trixie-slim
# FROM ghcr.io/astral-sh/uv:python3.14-bookworm-slim
# FROM python:3.12-bookworm

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

CMD bash -lc " uv run filemanager/manage.py makemigrations &&\
uv run filemanager/manage.py migrate &&\
uv run filemanager/manage.py runserver 0.0.0.0:8000"

