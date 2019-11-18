TIME_ZONE = Asia/Tokyo
LOG_LEVEL = INFO
SRC = setup.py $(wildcard github_traverse/*.py)


NETWORK_NAME = github_traverse_nw
.PHONY: network/create network/rm
network/create:
	if [ -z "`docker network ls | grep $(NETWORK_NAME)`" ]; then \
		docker network create --driver bridge $(NETWORK_NAME); \
	fi

network/rm:
	if [ -n "`docker network ls | grep $(NETWORK_NAME)`" ]; then \
		docker network rm $(NETWORK_NAME); \
	fi


VOLUME_NAME = github_traverse_data
.PHONY: volume/create volume/rm
volume/create:
	if [ -z "`docker volume ls | grep $(VOLUME_NAME)`" ]; then \
		docker volume create --driver local $(VOLUME_NAME); \
	fi

volume/rm:
	if [ -n "`docker volume ls | grep $(VOLUME_NAME)`" ]; then \
		docker volume rm $(VOLUME_NAME); \
	fi


DB_CONTAINER_NAME = github_traverse_db
DB_PASSWORD = sample_password
POSTGRES_VERSION = 11.2
.PHONY: db/start
# FYI: https://docs.docker.com/storage/
# in Docker 17.06 and higher, we recommend using the --mount flag for both containers and services,
# for bind mounts, volumes, or tmpfs mounts, as the syntax is more clear.
db/start: network/create volume/create
	if [ -z "`docker ps | grep $(DB_CONTAINER_NAME)`" ]; then \
		docker run -d --name $(DB_CONTAINER_NAME) \
		-e POSTGRES_PASSWORD=$(DB_PASSWORD) \
		-e TZ=$(TIME_ZONE) \
		--network $(NETWORK_NAME) \
		--mount src=$(VOLUME_NAME),dst=/var/lib/postgresql/data \
		postgres:$(POSTGRES_VERSION); \
	fi

db/stop:
	if [ -n "`docker ps | grep $(DB_CONTAINER_NAME)`" ]; then \
		docker rm -f $(DB_CONTAINER_NAME); \
	fi


APP_REPOSITORY_NAME = github_traverse
APP_TAG = latest
APP_CONTAINER_NAME = github_traverse_app
.PHONY: app/build app/start app/stop app/logs app/restart
.build: Dockerfile requirements.txt development.ini $(SRC)
	docker build -t $(APP_REPOSITORY_NAME):$(APP_TAG) .
	touch .build

app/build: .build

app/start: app/build network/create
	if [ -z "`docker ps | grep $(APP_CONTAINER_NAME)`" ]; then \
		docker run -d --name $(APP_CONTAINER_NAME) \
		-p 6543:6543 \
		-e TZ=$(TIME_ZONE) \
		-e LOG_LEVEL=$(LOG_LEVEL) \
		--network $(NETWORK_NAME) \
		$(APP_REPOSITORY_NAME):$(APP_TAG) \
		gunicorn --paste development.ini --bind 0.0.0.0:6543; \
	fi

app/stop:
	if [ -n "`docker ps | grep $(APP_CONTAINER_NAME)`" ]; then \
		docker rm -f $(APP_CONTAINER_NAME); \
	fi

app/logs:
	docker logs -f $(APP_CONTAINER_NAME)

app/restart: app/stop app/start


.PHONY: gcp gcp/pre
gcp:
	@(make -C gcp `cat gcp/Makefile | grep -E '^[-_/0-9a-zA-Z]+:' | peco | sed 's/:.*$$//g'`)

gcp/pre:
	@(make -C gcp/pre `cat gcp/pre/Makefile | grep -E '^[-_/0-9a-zA-Z]+:' | peco | sed 's/:.*$$//g'`)


.PHONY: clean lint format tags
clean: app/stop
	rm -f .build

# This target always return 0 as exit code.
# If you want to fail this target(ex. CI), you must create a wrapper script like:
# 	make lint 2>&1 | grep Error; if [ $? -eq 0 ]; then exit 1; fi
lint:
	-flake8 $(SRC)
	-pydocstyle $(SRC)
	-mypy $(SRC)
	-isort --diff $(SRC)

format:
	autopep8 --in-place --aggressive $(SRC)
	isort $(SRC)

tags: Dockerfile requirements.txt $(SRC)
	ctags -R --exclude=.git
