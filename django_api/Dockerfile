FROM python:3.6.8

RUN mkdir /src
WORKDIR /src

RUN apt update
RUN apt install libpq-dev postgresql -y

ADD requirements.txt /src/
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

ADD . /src/

EXPOSE 8000