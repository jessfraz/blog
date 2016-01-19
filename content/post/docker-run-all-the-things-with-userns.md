+++
date = "2016-01-08T17:33:46Z"
title = "Docker run all the things with user namespaces"
author = "Jessica Frazelle"
description = "How to run all your weird containers and docker-in-docker with user namespaces in Docker."
draft = true
+++

If you weren't aware user namepace support was added to Docker awhile back in
the "Experimental" builds. But with the upcoming release of Docker Engine
1.10.0, [Phil Estes](https://twitter.com/estesp) is working on
[moving it into stable](https://github.com/docker/docker/pull/19187). Now this
is all super exciting and blah blah blah, but what I am going to talk about
today is how I started running all the containers from my
[Docker Containers on the Desktop](/post/docker-containers-on-the-desktop) with
the new user namespace support. The containers/images in that post were already
doing some linux-y magic, but with a little more, they are perfect. I'm not
going to go through them all but I will go through some interesting ones,
including even how to run Docker-in-Docker.

### Chrome

This one was shockingly easy. The only things I needed to add to my original
command were `--group-add video` and `--group-add audio`. Makes sense right..
we obviously want to be a member of those groups to watch Taylor Swift music
videos.

The full command is below. I even made a custom seccomp whitelist for chrome,
you can view it in my dotfiles repo: [github.com/jfrazelle/dotfiles](https://github.com/jfrazelle/dotfiles/blob/master/etc/docker/seccomp/chrome.json). Seccomp will be shipped in 1.10 as well, along with a default whitelist! (But I degress that is not the point of this blog post.)

[Dockerfile](https://github.com/jfrazelle/dockerfiles/blob/master/chrome/stable/Dockerfile)

```console
$ docker run -d \
    --memory 3gb \
    -v /etc/localtime:/etc/localtime:ro \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=unix$DISPLAY \
    -v $HOME/Downloads:/root/Downloads \
    -v $HOME/.chrome:/data \
    -v /dev/shm:/dev/shm \
    --security-opt seccomp:/etc/docker/seccomp/chrome.json \
    --device /dev/snd \
    --device /dev/dri \
    --device /dev/video0 \
    --group-add audio \
    --group-add video \
    --name chrome \
    jess/chrome --user-data-dir=/data
```

### Notify-osd and Irssi

Now I have always run my notifications daemon in a container, because that
stuff is nasty to install, so many dependencies, ewwww. This one was a bit more
tricky beacuase it involves dbus but it is a way cleaner solution than the way
I was originally running it.

[Dockerfile](https://github.com/jfrazelle/dockerfiles/blob/master/notify-osd/Dockerfile)

```console
$ docker run -d \
    -v /etc/localtime:/etc/localtime:ro \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /etc \
    -v /home/user/.dbus \
    -v /home/user/.cache/dconf \
    -e DISPLAY=unix$DISPLAY \
    --name notify_osd \
    jess/notify-osd

# you can test with
$ docker exec -it notify_osd notify-send hello
```

Not to bad right? I am creating those volumes on run so that we can then share
them with our irssi container. This way when someone pings me I get
a notification, duh!

[Dockerfile](https://github.com/jfrazelle/dockerfiles/blob/master/irssi/Dockerfile)

```console
$ docker run --rm -it \
    -v /etc/localtime:/etc/localtime:ro \
    -v $HOME/.irssi:/home/user/.irssi \
    --volumes-from notify_osd \
    -e DBUS_SESSION_DBUS_ADDRESS="unix:abstract=/home/user/.dbus/session-bus/$(docker exec notify_osd ls /home/user/.dbus/session-bus/)" \
    --name irssi \
    jess/irssi
```

So this is pretty simple as well even considering the real gross part is trying
to get the `DBUS_SESSION_DBUS_ADDRESS` from our `notify_osd` container.

Let's get into the fun part.

### Docker-in-Docker

When running the docker daemon with user namespace support, you cannot use
`docker run` flags like `--privileged`, `--net host`, `--pid host`, etc. These
are for pretty obvious reasons so I'm not going to get into it, if you want to
know more RTFM.

Okay so we can't use `--privileged`, but but but that's how I run
docker-in-docker... ok let's think about it. What is `--privileged` actually
doing? Well for starters it's allowing all capabilites, but... do we really
need them all? The answer is no.. all we really need is `CAP_SYS_ADMIN` and
`CAP_NET_ADMIN`. So that gets us pretty far but we also need to disable the
default seccomp profile (because it drops `clone` args, `mount`, and a bunch of
others). Lastly we need to run with a different apparmor profile so we can have
more capabilities as well.

This leaves us with:

```

```
