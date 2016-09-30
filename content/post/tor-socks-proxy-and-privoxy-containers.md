+++
date = "2015-09-12T11:47:47-07:00"
title = "Tor Socks Proxy and Privoxy Containers"
author = "Jessica Frazelle"
description = "How to run a Tor socks5 proxy and privoxy http proxy in Docker containers."
+++

Okay so this is part 2.5 in my series of posts combining my two
favorite things, Docker & Tor. If you are just starting here, to catch you up,
the first post was
["How to Route all Traffic through a Tor Docker container"](/post/routing-traffic-through-tor-docker-container/).
The second was on ["Running a Tor relay with Docker"](/post/running-a-tor-relay-with-docker/).
I thought it only made sense to show how to set up a Tor socks5 proxy in
a container, for routing _some_ traffic through Tor; in contrast to the first
post, where I explained how to route _all_ your traffic.


### Tor Socks5 Proxy

I have made a Docker image for this which lives at
[jess/tor-proxy](https://hub.docker.com/r/jess/tor-proxy/)
on the Docker hub. But I will go over the details so you can build one
yourself.

The Dockerfile looks like the following:

```bsh
FROM alpine:latest

# Note: Tor is only in testing repo -> http://pkgs.alpinelinux.org/packages?package=emacs&repo=all&arch=x86_64
RUN apk update && apk add \
    tor \
    --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ \
    && rm -rf /var/cache/apk/*

# expose socks port
EXPOSE 9050

# copy in our torrc file
COPY torrc.default /etc/tor/torrc.default

# make sure files are owned by tor user
RUN chown -R tor /etc/tor

USER tor

ENTRYPOINT [ "tor" ]
CMD [ "-f", "/etc/tor/torrc.default" ]
```

Which looks a lot like the Dockerfile for a relay, if you recall. But the key
difference is the `torrc`. Now the only thing I have changed from the default
`torrc` is the following line:

```
SocksPort 0.0.0.0:9050
```

This is so that it can bind correctly to the network namespace the container
is using.

This image weighs in at only 11.51 MB!

To run the image:

```bsh
$ docker run -d \
    --restart always \
    -v /etc/localtime:/etc/localtime:ro \ # i like this for all my containers, but it's optional
    -p 9050:9050 \ # publish the port
    --name torproxy \
    jess/tor-proxy
```

Okay, awesome, now you have the socks5 proxy running on port `9050`. Let's test
it:

```bsh
# get your current ip
$ curl -L http://ifconfig.me

# get your ip through the tor socks proxy
$ curl --socks http://localhost:9050  -L http://ifconfig.me
# obviously they should be different ;)

# you can even curl the check.torproject.org api
$ curl --socks http://localhost:9050  -L https://check.torproject.org/api/ip
```

If you are like me and use
[@ioerror's gpg.conf](https://github.com/ioerror/duraconf/blob/master/configs/gnupg/gpg.conf)
you can uncomment the line:

```
keyserver-options http-proxy=socks5-hostname://127.0.0.1:9050
```

Now you can import and search for keys on a key server with
improved anonymity. Obviously there are a bunch of other things you can use the
socks proxy for, but I wanted to give this as an example.

_[You could even run chrome in a container through the proxy...](https://github.com/jessfraz/dotfiles/blob/master/.dockerfunc#L140)_

Can we take this even further? Yes.

### Privoxy HTTP Proxy

The socks proxy is awesome, but if you want to additionally have an http proxy
it is super easy!

What we can do is link a Privoxy container to our Tor proxy container.

**NOTE:** I have seen people have a Tor socks proxy _and_ Privoxy in the same container.
But I prefer my approach of 2 different containers, because it is cleaner,
maybe sometimes you do not need both, _and_ you completely eliminate the need for
having an init system starting 2 processes in one container. Not that there is
anything wrong with that, but it is not my personal preference.

So on to the Dockerfile, which also lives at [jess/privoxy](https://hub.docker.com/r/jess/privoxy/):

```bsh
FROM alpine:latest

RUN apk update && apk add \
    privoxy \
    && rm -rf /var/cache/apk/*

# expose http port
EXPOSE 8118

# copy in our privoxy config file
COPY privoxy.conf /etc/privoxy/config

# make sure files are owned by privoxy user
RUN chown -R privoxy /etc/privoxy

USER privoxy

ENTRYPOINT [ "privoxy", "--no-daemon" ]
CMD [ "/etc/privoxy/config" ]
```

This image is a whopping 6.473 MB :D

The only change I made to the default privoxy config was the following:

```
forward-socks5 / torproxy:9050 .
```

This is so that when we link our torproxy container to the privoxy container,
privoxy can communicate with the sock.

Let's run it:

```bsh
$ docker run -d \
    --restart always \
    -v /etc/localtime:/etc/localtime:ro \ # again a personal preference
    --link torproxy:torproxy \ # link to our torproxy container
    -p 8118:8118 \ # publish the port
    --name privoxy \
    jess/privoxy
```

Awesome, now to test the proxy:

```bsh
# get your current ip
$ curl -L http://ifconfig.me

# get your ip through the http proxy
$ curl -x http://localhost:8118 -L http://ifconfig.me
# obviously again, they should be different ;)

# curl the check.torproject.org api
$ curl -x http://localhost:8118  -L https://check.torproject.org/api/ip
```

That's all for now! Stay anonymous on the interwebs :p

