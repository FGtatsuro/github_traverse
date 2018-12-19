TAG = github_traverse:latest
CONTAINER_NAME = github_traverse_container
TIME_ZONE = Asia/Tokyo
SRC = setup.py $(wildcard github_traverse/*.py)

.PHONY: all build start stop restart clean lint format tags

all: start

build: .build

.build: Dockerfile requirements.txt development.ini $(SRC)
	docker build -t $(TAG) .
	touch .build

start: build
	docker run -d --name $(CONTAINER_NAME) -p 6543:6543 -e TZ=$(TIME_ZONE) $(TAG) \
		gunicorn --paste development.ini --bind 0.0.0.0:6543

stop:
	-docker rm -f $(CONTAINER_NAME)

restart: stop start

clean: stop
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
