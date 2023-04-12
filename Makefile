include .make.env

ifeq ($(filter $(MAKE_ENV), local staging production),)
$(error Invalid MAKE_ENV value. Values accepteds: local, staging or production.)
endif

DOCKER_COMPOSE_FILE=.docker/$(MAKE_ENV)/docker-compose.yml
DOCKER_ENV_FILE=.docker/$(MAKE_ENV)/.env

ifeq ($(wildcard $(DOCKER_COMPOSE_FILE)),)
$(error $(DOCKER_COMPOSE_FILE) not found.)
endif

ifeq ($(wildcard $(DOCKER_ENV_FILE)),)
$(error $(DOCKER_ENV_FILE) not found.)
endif

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │ Colors definitions                                                          │
# └─────────────────────────────────────────────────────────────────────────────┘
CR=\033[0;31m
CG=\033[0;32m
CY=\033[0;33m
CB=\033[0;36m
RC=\033[0m

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │ API commands                                                                │
# └─────────────────────────────────────────────────────────────────────────────┘
.PHONY: api-build
api-build:
	@docker exec nest_app_api bash -c "npm run build"

.PHONY: api-dev
api-dev:
	@docker exec -it nest_app_api bash -c "npm run dev"

.PHONY: api-exec
api-exec:
	@docker exec -it nest_app_api bash

.PHONY: api-install
api-install:
	@docker exec -it nest_app_api bash -c "npm install"

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │ REDIS commands                                                                │
# └─────────────────────────────────────────────────────────────────────────────┘

.PHONY: redis-exec
redis-exec:
	@docker exec -it nest_app_redis bash 

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │ DATABASE commands                                                                │
# └─────────────────────────────────────────────────────────────────────────────┘

.PHONY: db-reset
db-reset:
	@docker exec -it nest_app_api bash -c "npm run db:reset"

.PHONY: db-seed-all
db-seed-all:
	@docker exec -it nest_app_api bash -c "npm run build && npm run db:seed:all"

.PHONY: db-migrate
db-migrate:
	@docker exec -it nest_app_api bash -c "npm run build && npm run db:migrate"

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │ Infra commands                                                              │
# └─────────────────────────────────────────────────────────────────────────────┘
.PHONY: build
build:
	@docker-compose -f $(DOCKER_COMPOSE_FILE) --env-file $(DOCKER_ENV_FILE) build

.PHONY: start
start:
	@docker-compose -f $(DOCKER_COMPOSE_FILE) --env-file $(DOCKER_ENV_FILE) up -d

.PHONY: stop
stop:
	@docker-compose -f $(DOCKER_COMPOSE_FILE) --env-file $(DOCKER_ENV_FILE) down

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │ Help                                                                        │
# └─────────────────────────────────────────────────────────────────────────────┘
help:
	@echo ""
	@echo -e "${CY}Usage${RC}"
	@echo -e "   make ${CG}<command>${RC}"
	@echo  ""
	@echo -e "${CY}Infra commands${RC}"
	@echo -e "${CG}   build               ${RC}Build all containers"
	@echo -e "${CG}   start               ${RC}Start all containers"
	@echo -e "${CG}   stop                ${RC}Stop all containers"
	@echo  ""
	@echo -e "${CY}API commands${RC}"
	@echo -e "${CG}   api-build           ${RC}Build api distribution files"
	@echo -e "${CG}   api-dev             ${RC}Start a development server"
	@echo -e "${CG}   api-exec            ${RC}Enter inside the api container"
	@echo -e "${CG}   api-install         ${RC}Install api dependencies"
	@echo -e "${CG}   redis-exec          ${RC}Enter inside the redis container"
	@echo  ""
	@echo -e "${CY}DB commands${RC}"
	@echo -e "${CG}   db-reset            ${RC}Reset database"
	@echo -e "${CG}   db-seed-all         ${RC}Run build and all pending seeds"
	@echo -e "${CG}   db-migrate          ${RC}Run build and all pending migrates"
	@echo ""
