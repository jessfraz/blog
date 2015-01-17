FROM python:2.7

RUN pip install cactus

COPY . /src

WORKDIR /src

ENTRYPOINT [ "cactus" ]
