PROJECT := nishitetsubusrails
PREFIX := docker compose --file .dockerdev/compose.yml --project-name $(PROJECT)-application
RAILS := $(PREFIX) run --rm rails rails

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
