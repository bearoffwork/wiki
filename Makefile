COMPOSE_RUN=docker compose run --rm --build
ATTACH=hedgedoc bookstack

run-dev: .env hedgedoc/node_modules bookstack/vendor bookstack/.env check-bookstack-migration
	docker compose up --build nginx $(ATTACH)

.env:
	cp .env.example .env

check-bookstack-migration:
	@if $(COMPOSE_RUN) bookstack-builder php artisan migrate:status --pending | grep -i pending > /dev/null; then \
  		$(COMPOSE_RUN) bookstack-builder php artisan migrate:status; \
  	    echo "  \033[43m\033[30m WARN \033[0m Ensure you have a backup before proceeding. "; \
	    read -p "BookStack has pending migrations. Do you want to run them now? [y/N] " -n 1 -r yn; \
	    case $$yn in \
			[Yy]* ) make migrate-bookstack; \
				;; \
			* ) echo "Please run 'make migrate-bookstack' to make sure database status is up to date."; \
				exit 1;; \
		esac \
	fi

migrate-bookstack:
	@$(COMPOSE_RUN) bookstack-builder php artisan migrate

# install composer packages
bookstack/vendor:
	@$(COMPOSE_RUN) bookstack-builder composer install

# copy .env file and generate app key for bookstack
bookstack/.env:
	cp bookstack/.env.example bookstack/.env
	@$(COMPOSE_RUN) bookstack-builder php artisan key:generate

# install node packages and copy default config
hedgedoc/node_modules:
	@$(COMPOSE_RUN) hedgedoc-builder /hedgedoc/bin/setup


.PHONY: build check-bookstack-migration migrate-bookstack