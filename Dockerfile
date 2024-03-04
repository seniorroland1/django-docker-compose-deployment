# Use Python 3.9 on Alpine Linux 3.13 as the base image
FROM python:3.9-alpine3.13

# Set the maintainer label
LABEL maintainer="dollarbill"

# Set environment variables
ENV PYTHONUNBUFFERED 1

# Copy requirements.txt and the app directory into the container
COPY ./requirements.txt /requirements.txt
COPY ./app /app

# Set the working directory inside the container
WORKDIR /app

# Expose port 5000
EXPOSE 5000

# Create a virtual environment, install dependencies, and add a non-root user
RUN python -m venv /py \
    && /py/bin/pip install --upgrade pip \
    && apk add --update --no-cache postgresql-client \
    && apk add --update --no-cache --virtual .tmp-deps \
        build-base postgresql-dev musl-dev \
    && /py/bin/pip install -r /requirements.txt \
    && apk del .tmp-deps \
    && adduser --disabled-password --no-create-home app \
    && mkdir -p /vol/web/static \
    && mkdir -p /vol/web/media \
    && chown -R app:app /vol \
    && chmod -R 755 /vol 

# Add the virtual environment's binary directory to the PATH
ENV PATH="/py/bin:$PATH"

# Set the user to 'app'
USER app
