# Open source MongoDB docker image

This MongoDB docker image is based on custom [Centos 7 image] (https://gitlab.com/container-inside/centos7/container_registry)

Current version of MongoDB in this image: 3.4.10

---

## Run MongoDB docker image

```
docker run -d -p 21017:21017 gfunk/mongodb-docker:latest
```

## Features

- MongoDB process is managed by supervisord process manager
- MongoDB database already contains two users: app-test and app-admin

## Requirements

- Then you'll need Docker on your local machine if you haven't it yet [Docker installation] (https://docs.docker.com/engine/installation/)
