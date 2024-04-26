FROM python:3.11-alpine

ENV PYTHONUNBUFFERED=1

WORKDIR /backend

RUN apk add --no-cache \
    build-base \
    pkgconfig \
    mariadb-connector-c-dev

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY . .
RUN chmod +x docker-entrypoint.sh

CMD ["./docker-entrypoint.sh"]
