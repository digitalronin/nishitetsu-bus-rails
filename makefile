PROJECT := nishitetsubusrails
PRODUCTION_IMAGE_TAG := $(PROJECT)-rails  # Also hard-coded in .dockerdev/compose-production.yml

# use development docker image during development
PREFIX := docker compose --file .dockerdev/compose.yml --project-name $(PROJECT)-application

# use this to test a production docker image in a local docker-compose deployment
# PREFIX := docker compose --file .dockerdev/compose-production.yml --project-name $(PROJECT)-application

RAILS := $(PREFIX) run --rm rails rails

build-production-image:
	. .env; \
	docker build --build-arg RAILS_MASTER_KEY=$$RAILS_MASTER_KEY -t $(PRODUCTION_IMAGE_TAG) -f Dockerfile.heroku .

up:
	$(PREFIX) up

down:
	$(PREFIX) down

remove-volumes:
	$(PREFIX) down --volumes

provision:
	$(PREFIX) down --volumes
	$(PREFIX) up -d postgres
	$(PREFIX) run --no-deps --rm rails /bin/bash -c bin/setup
	$(PREFIX) run --no-deps --rm rails yarn

shell:
	$(PREFIX) run --rm rails bash

rails-c:
	$(RAILS) console

exec-onto-rails-container:
	docker exec -it nishitetsubusrails-application-web-1 bash

