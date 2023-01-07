# Show this help
help:
	@cat $(MAKEFILE_LIST) | docker run --rm -i xanders/make-help

# Test the library
test:
	docker-compose run --rm crystal spec

# Change source files according to code style
format:
	docker-compose run --rm crystal tool format

# Check the code style is correct
lint:
	docker-compose run --rm crystal tool format --check

# Generate the documentation
docs:
	docker-compose run --rm crystal docs

.PHONY: docs
