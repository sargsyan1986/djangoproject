# pull official base image
FROM python:3.8-alpine

# set work directory
WORKDIR /usr/src/app

# set environment varibles
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install psycopg2
RUN apk update \
 && apk add --virtual build-deps gcc python3-dev musl-dev \
 && apk add postgresql-dev \
 && apk add gettext-dev \
 && apk add rsync \
 && pip install psycopg2 \
 && apk del build-deps

# install node and npm
RUN apk add --update npm

# install pillow dependencies
RUN apk add build-base python3-dev py-pip jpeg-dev zlib-dev
ENV LIBRARY_PATH=/lib:/usr/lib

# install psql client
RUN apk --update add postgresql-client

# install git
RUN apk add git

# copy project
COPY . .

# install dependencies
RUN pip install --upgrade pip \
 && pip install -r ./requirements/dev.txt \
 && pip install -r ./requirements/tests.txt \
 && pip install tox \
 && npm install bower
 
# copy docker-entrypoint.sh
COPY ./docker-entrypoint.sh ./docker-entrypoint.sh


# run docker-entrypoint.sh
ENTRYPOINT ["./docker-entrypoint.sh"]
