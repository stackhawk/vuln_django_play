# Dockerfile

# FROM directive instructing base image to build on
FROM python:3.7-buster

ARG SERVER_PORT

ENV DJANGO_SUPERUSER_USERNAME=admin
ENV DJANGO_SUPERUSER_PASSWORD=adminpassword
ENV DJANGO_SUPERUSER_EMAIL=admin@example.com
ENV SERVER_PORT=${SERVER_PORT}

EXPOSE ${SERVER_PORT}:${SERVER_PORT}

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		nginx \
		vim \
		less

COPY ./app /opt/app

RUN mkdir /opt/app/pip_cache \
	&& mkdir -p /app/.profile.d

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && mv /opt/app/nginx/nginx.default /etc/nginx/sites-available/default

WORKDIR /opt/app

RUN pip install -r requirements.txt \
	&& chown -R www-data:www-data /opt/app \
	&& python vuln_django/manage.py migrate

RUN python vuln_django/manage.py createsuperuser --no-input \
	&& chown -R www-data:www-data /opt/app \
	&& python vuln_django/manage.py seed polls --number=5

STOPSIGNAL SIGTERM
