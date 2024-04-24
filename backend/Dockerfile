FROM python:3.11-alpine

WORKDIR  /app

RUN apk add --no-cache \
    build-base \
    pkgconfig \
    mariadb-connector-c-dev

COPY requirements.txt  requirements.txt
RUN pip3 install -r requirements.txt

COPY . .

CMD [ "python3" , "manage.py" , "runserver","0000:8000" ]