FROM python:3.11-alpine

RUN pip3 install flask

RUN pip3 install gunicorn

WORKDIR /flask

ENTRYPOINT ["./gunicorn.sh"]
