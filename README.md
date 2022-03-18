# Pager

The way this works. It allows you to create an environment file using

```
make -e actor=test -e group=test
```

It assumes you're running in an isolated environment for the actor and project. Data are shared between actors and groups by using docker volumes


Once you've made an actor with a group, you can run the GUIs through docker-compose

```
docker-compose --env-file example.env run {pass,abook,gnupg,envsubst}
```

Of course, these could be daemonized at attached to for later inspection. And the logs can always be viewed by using docker compose logs
