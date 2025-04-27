# Stage 1: Base Image for build
FROM python:3.12-slim AS base

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install OS dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Set work directory
WORKDIR /app

# Copy dependencies
COPY requirements.txt .

# Install dependencies in virtualenv
RUN python -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install -r requirements.txt

# Stage 2: Runtime Image
FROM python:3.12-slim AS runtime

ENV PATH="/opt/venv/bin:$PATH"

# Copy virtualenv and app
COPY --from=base /opt/venv /opt/venv
COPY app /app

WORKDIR /app

# Use gunicorn in production
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "main:app"]
