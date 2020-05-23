# pull official base image
FROM python:3.8-slim-buster

# set work directory
WORKDIR /usr/src/app

# install dependencies
RUN pip install --upgrade pip
COPY ./requirements.pip /usr/src/app/requirements.pip
RUN pip install -r requirements.pip

# copy project
COPY ./app.py /usr/src/app/app.py

ENTRYPOINT gunicorn -w 4 --bind 0.0.0.0:80 app:app