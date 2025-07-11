.PHONY:

docker=docker compose

ENV_ARGS=--env-file=.env --env-file=.env.local

define docker_cmd
	[ -f ".env.local" ] && $(docker) $(ENV_ARGS) $(1) || $(docker) $(1)
endef

-include Makefile.local

build:
	$(call docker_cmd,build)

build-no-cache:
	$(call docker_cmd,build --no-cache)

up:
	$(call docker_cmd,up -d)

down:
	$(call docker_cmd,down)

ps:
	$(call docker_cmd,ps)

