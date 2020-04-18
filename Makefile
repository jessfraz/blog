NAME := blog

# Set the graph driver as the current graphdriver if not set.
DOCKER_GRAPHDRIVER := $(if $(DOCKER_GRAPHDRIVER),$(DOCKER_GRAPHDRIVER),$(shell docker info 2>&1 | grep "Storage Driver" | sed 's/.*: //'))
export DOCKER_GRAPHDRIVER

# If this session isn't interactive, then we don't want to allocate a
# TTY, which would fail, but if it is interactive, we do want to attach
# so that the user can send e.g. ^C through.
INTERACTIVE := $(shell [ -t 0 ] && echo 1 || echo 0)
ifeq ($(INTERACTIVE), 1)
	DOCKER_FLAGS += -t
endif

DOCKER_FLAGS+=--rm -i \
	--disable-content-trust=true
DOCKER_FLAGS+=-v $(CURDIR):/src/$(NAME)
DOCKER_FLAGS+=--workdir /src/$(NAME)

all: dev

REGISTRY := r.j3ss.co
.PHONY: image-dev
image-dev:
	@docker build --rm --force-rm -f Dockerfile.dev -t $(REGISTRY)/$(NAME):dev .

.PHONY: static/js/site.min.js
static/js/site.min.js: image-dev
	docker run $(DOCKER_FLAGS) \
		$(REGISTRY)/$(NAME):dev \
		uglifyjs --output $@ --compress --mangle -- \
			static/js/lib/mathjax.js static/js/prettify/prettify.js

.PHONY: static/css/site.min.css
static/css/site.min.css: image-dev
	docker run $(DOCKER_FLAGS) \
		$(REGISTRY)/$(NAME):dev \
		sh -c 'cat static/css/fontawesome.css static/css/normalize.css static/css/code.css static/css/main.css | cleancss -o $@'

.PHONY: dev
dev: static/js/site.min.js static/css/site.min.css ## Build the frontend components.

IP_ADDRESS := $(shell ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | tail -1)
.PHONY: serve
serve: ## Serve the website locally.
	hugo serve --bind $(IP_ADDRESS) --baseURL http://$(IP_ADDRESS)

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

check_defined = \
    $(strip $(foreach 1,$1, \
	$(call __check_defined,$1,$(strip $(value 2)))))

__check_defined = \
    $(if $(value $1),, \
    $(error Undefined $1$(if $2, ($2))$(if $(value @), \
    required by target `$@')))
