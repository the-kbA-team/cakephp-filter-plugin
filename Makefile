SHELL := /bin/sh
.DEFAULT_GOAL := help

COMPOSER_IMAGE     := composer:2
COMPOSER_CACHE_DIR := $(HOME)/.cache/composer
DOCKER_USER        := --user "$$(id -u)":"$$(id -g)"
DOCKER_MOUNT       := --volume "$$(pwd)":/app --workdir /app
PHP_SOURCE_DIRS    := Controller Model Test View

ifdef DEPENDENCIES_LOWEST
COMPOSER_UPDATE_FLAGS := --prefer-lowest
else
COMPOSER_UPDATE_FLAGS :=
endif

# Optional: set CA_CERT_FILE to a PEM file (e.g. a corporate proxy root CA)
# to make it trusted for HTTPS network access inside the Composer containers.
ifdef CA_CERT_FILE
CA_MOUNT     := --volume "$(CA_CERT_FILE)":/tmp/extra-ca.crt:ro
CA_TRUST_CMD := cat /etc/ssl/certs/ca-certificates.crt /tmp/extra-ca.crt > /tmp/ca-bundle.pem && export CURL_CA_BUNDLE=/tmp/ca-bundle.pem SSL_CERT_FILE=/tmp/ca-bundle.pem &&
else
CA_MOUNT     :=
CA_TRUST_CMD :=
endif

.PHONY: help clean check-php-version install lint audit validate

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*## ' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

clean: ## Remove vendor/, composer.lock and the PHPUnit cache
	rm -rf vendor composer.lock .phpunit.result.cache

check-php-version:
	@if [ -z "$(PHP_VERSION)" ]; then \
		echo "Error: PHP_VERSION must be set, e.g. 'make $(MAKECMDGOALS) PHP_VERSION=8.1'." >&2; \
		exit 1; \
	fi

install: check-php-version ## Resolve and install dependencies for PHP_VERSION (DEPENDENCIES_LOWEST=1 for --prefer-lowest)
	@mkdir -p "$(COMPOSER_CACHE_DIR)"
	@docker run --rm -t --init $(DOCKER_USER) \
		--env HTTP_PROXY --env HTTPS_PROXY --env NO_PROXY \
		--env COMPOSER_CACHE_DIR=/tmp/composer-cache \
		--volume "$(COMPOSER_CACHE_DIR)":/tmp/composer-cache \
		$(CA_MOUNT) \
		$(DOCKER_MOUNT) \
		$(COMPOSER_IMAGE) sh -c '\
			$(CA_TRUST_CMD) \
			composer config platform.php "$(PHP_VERSION)" && \
			composer update $(COMPOSER_UPDATE_FLAGS) --prefer-dist --no-interaction --no-progress; \
			status=$$?; \
			composer config --unset platform.php; \
			composer config --unset platform; \
			exit $$status \
		'; status=$$?; rm -f composer.lock; exit $$status

lint: check-php-version ## Syntax-check all PHP files for PHP_VERSION
	docker run --rm --init $(DOCKER_USER) $(DOCKER_MOUNT) \
		"php:$(PHP_VERSION)-cli" sh -c "find $(PHP_SOURCE_DIRS) -type f -name '*.php' -print0 | xargs -0 -n1 php -l"

audit: ## Run composer audit
	docker run --rm -t --init $(DOCKER_USER) \
		--env HTTP_PROXY --env HTTPS_PROXY --env NO_PROXY \
		$(CA_MOUNT) $(DOCKER_MOUNT) \
		$(COMPOSER_IMAGE) sh -c '$(CA_TRUST_CMD) composer audit'

validate: ## Run composer validate --strict
	docker run --rm -t $(DOCKER_USER) $(DOCKER_MOUNT) \
		$(COMPOSER_IMAGE) composer validate --strict
