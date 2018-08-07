TAG = github_traverse:latest
CONTAINER_NAME = github_traverse_container
TIME_ZONE = Asia/Tokyo
SRC = app.py

.PHONY: all build run stop clean

all: run

build: .build

.build: Dockerfile requirements.txt $(SRC)
	docker build -t $(TAG) .
	touch .build

run: build
	docker run -d --name $(CONTAINER_NAME) -p 6543:6543 -e TZ=$(TIME_ZONE) $(TAG) python app.py

stop:
	-docker rm -f $(CONTAINER_NAME)

clean: stop
	rm -f .build

tags: Dockerfile requirements.txt $(SRC)
	ctags -R --exclude=.git
