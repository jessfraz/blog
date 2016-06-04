.PHONY: all build release run serve purge-cache clean

AWS_S3_BUCKET := blog.jessfraz.com
AWS_ACCESS_KEY := ${AMAZON_ACCESS_KEY_ID}
AWS_SECRET_KEY := ${AMAZON_SECRET_ACCESS_KEY}
export AWS_S3_BUCKET AWS_ACCESS_KEY AWS_SECRET_KEY

REGISTRY := r.j3ss.co
DOCKER_IMAGE := $(REGISTRY)/blog

PORT := 1337

all: release

build:
	docker build --rm --force-rm -t $(DOCKER_IMAGE) .

release: build
	docker run --rm -it \
		-e AWS_S3_BUCKET \
		-e AWS_ACCESS_KEY \
		-e AWS_SECRET_KEY \
		$(DOCKER_IMAGE)

run: clean build
	docker run -d \
		-v $(CURDIR):/usr/src/blog \
		-p $(PORT):$(PORT)\
		--name blog \
		$(DOCKER_IMAGE) hugo server --port=$(PORT) --bind=0.0.0.0

serve: run
	$(eval BLOG_IP := $(shell docker inspect --format "{{.NetworkSettings.Networks.bridge.IPAddress}}" blog))
	@echo "Go to http://$(BLOG_IP):$(PORT) in your browser."
	@docker logs -f blog

purge-cache:
	docker run --rm -it  -e AWS_ACCESS_KEY -e AWS_SECRET_KEY -e AWS_CF_DISTRIBUTION_ID -e AWS_S3_BUCKET=blog.jessfraz.com $(REGISTRY)/cf-reset-cache

clean:
	sudo $(RM) -r public
	-@docker rm -vf blog > /dev/null 2>&1
