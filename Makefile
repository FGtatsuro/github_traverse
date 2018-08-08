TAG = github_traverse:latest
CONTAINER_NAME = github_traverse_container
TIME_ZONE = Asia/Tokyo
SRC = app.py

.PHONY: all build start stop clean

all: start

build: .build

.build: Dockerfile requirements.txt $(SRC)
	docker build -t $(TAG) .
	touch .build

start: build
	docker run -d --name $(CONTAINER_NAME) -p 6543:6543 -e TZ=$(TIME_ZONE) $(TAG) python app.py

stop:
	-docker rm -f $(CONTAINER_NAME)

clean: stop
	rm -f .build

# This target always return 0 as exit code.
# If you want to fail this target(ex. CI), you must create a wrapper script like:
# 	make lint 2>&1 | grep Error; if [ $? -eq 0 ]; then exit 1; fi
lint:
	-flake8 $(SRC)
	-pydocstyle $(SRC)
	-mypy $(SRC)

format:
	autopep8 --in-place --aggressive --recursive $(SRC)

tags: Dockerfile requirements.txt $(SRC)
	ctags -R --exclude=.git
