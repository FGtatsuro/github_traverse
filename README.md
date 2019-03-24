# github_traverse

Web service to traverse github issues in multiple repositories(For Pyramid trial).

## Requirements

The dependencies on other softwares/libraries for this project.
This software may work even if these requirements aren't met,
but the behavior on that case can't be supported officially.

- [Docker](https://docs.docker.com/) (>= 18.06.0)
- [GNU Make](https://www.gnu.org/software/make/) (>= 3.81)
- [Python](https://www.python.org/) (>= 3.7.x) (For development)

## Start the service

1. Run the application on a Docker container.

```bash
$ make app/start
```

2. Acess an index page.

```bash
$ open http://127.0.0.1:6543
```

## Stop the service

1. Stop the application.

```bash
$ make app/stop
```

## Development

1. Create a tag file.

```bash
$ make tags
```

2. Implement the application.

```bash
$ vi app.py
...
```

3. Run lint/format.

```bash
$ make lint
$ make format
```
