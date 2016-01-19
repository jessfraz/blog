.PHONY: all build default release serve

default: release

all: build

build:
	docker build --rm --force-rm -t jess/blog .

release: build
	docker run --rm -it -v $(CURDIR)/public:/usr/src/blog/public -e AWS_S3_BUCKET -e AWS_ACCESS_KEY -e AWS_SECRET_KEY jess/blog

serve: build
	docker run --rm -it --net host --entrypoint hugo jess/blog server
