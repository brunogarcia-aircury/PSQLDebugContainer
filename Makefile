.PHONY:

docker=docker compose

ENV_ARGS=--env-file=.env --env-file=.env.local

-include Makefile.local

build:
	[ -f ".env.local" ] && $(docker) $(ENV_ARGS) build || $(docker) build

build-no-cache:
	[ -f ".env.local" ] && $(docker) $(ENV_ARGS) build --no-cache || $(docker) build --no-cache

up:
	[ -f ".env.local" ] && $(docker) $(ENV_ARGS) up -d || $(docker) up -d

down:
	[ -f ".env.local" ] && $(docker) $(ENV_ARGS) down || $(docker) down

ps:
	[ -f ".env.local" ] && $(docker) $(ENV_ARGS) ps || $(docker) ps

