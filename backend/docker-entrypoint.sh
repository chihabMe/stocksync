#!/bin/sh

until nc -z -v -w30 db 3306
do
  echo "Waiting for MySQL database connection..."
  # Wait 5 seconds before checking again
  sleep 5
done


#migrte the django app
python manage.py migrate
python manage.py collectstatic --no-input


# start the server
gunicorn core.wsgi --bind 0.0.0.0:8000