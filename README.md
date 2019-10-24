# github_traverse

Web service to traverse github issues in multiple repositories(For Pyramid trial).

## Deployment on local

### Requirements

The dependencies on other softwares/libraries for this project.
This software may work even if these requirements aren't met,
but the behavior on that case can't be supported officially.

- [Docker](https://docs.docker.com/) (>= 18.06.0)
- [GNU Make](https://www.gnu.org/software/make/) (>= 3.81)
- [Python](https://www.python.org/) (>= 3.7.x) (For development)

### Build the image

```bash
$ make app/build
```

### Start the service

Run the application with DB on a Docker container.

```bash
$ make db/start
$ make app/start
```

Acess an index page.

```bash
$ open http://<reachable IP>:6543
```

### Stop the service

Stop the application.

```bash
$ make app/stop
$ make db/stop
```

## Development tips

Create a ctags file.

```bash
$ make tags
```

Run lint/format.

```bash
$ make lint
$ make format
```
