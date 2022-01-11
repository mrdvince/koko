
FROM python:3.9

WORKDIR /app/

COPY ./requirements.txt /tmp/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /tmp/requirements.txt

COPY . /app/
ENV PYTHONPATH=/app