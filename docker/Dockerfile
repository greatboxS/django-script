# syntax=docker/dockerfile:1
FROM python:3
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
WORKDIR /code
COPY requirements.txt /code/
ARG CRYPTOGRAPHY_DONT_BUILD_RUST=1
RUN pip install -r requirements.txt
COPY . /code/