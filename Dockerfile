
FROM python:3.9

WORKDIR /app/

COPY ./requirements.txt /tmp/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /tmp/requirements.txt

COPY . /app/
ENV PYTHONPATH=/app

RUN gunicorn --bind 0.0.0.0:8000 src.wsgi:app

EXPOSE 8000