.PHONY:

docker=docker compose

ENV_ARGS=--env-file=.env --env-file=.env.local

define docker_cmd
	[ -f ".env.local" ] && $(docker) $(ENV_ARGS) $(1) || $(docker) $(1)
endef

define env_cmd
	@eval $$(echo -e "$$(cat .env)\n$$(cat .env.local 2>/dev/null)" | grep -v '^#' | xargs) && $(1)
endef

-include Makefile.local

build:
	$(call docker_cmd,build)

build-plain:
	$(call docker_cmd,build --progress=plain)

build-no-cache:
	$(call docker_cmd,build --no-cache)

up:
	$(call docker_cmd,up -d)

down:
	$(call docker_cmd,down)

ps:
	$(call docker_cmd,ps)

psql:
	$(call env_cmd, docker exec -it "$$CONTAINER_NAME" psql -U "$$PSQL_USER" -d "$$PSQL_DB")

bash:
	$(call env_cmd, docker exec -it "$$CONTAINER_NAME" bash)