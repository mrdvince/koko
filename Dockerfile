FROM python:3.9-alpine

WORKDIR /app/

COPY ./requirements.txt /tmp/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /tmp/requirements.txt

COPY . /app/
ENV PYTHONPATH=/app

ENTRYPOINT gunicorn --bind 0.0.0.0:8080 src.wsgi:app