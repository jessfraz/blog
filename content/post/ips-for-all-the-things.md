+++
date = "2016-01-28T13:00:14-07:00"
title = "IPs for all the Things"
author = "Jessica Frazelle"
description = "How to run Docker containers with custom ips."
+++

This is so cool I can hardly stand it.

In Docker 1.10, the awesome libnetwork team added the ability to specify
a specific IP for a container. If you want to see the pull request it's here:
[docker/docker#19001](https://github.com/docker/docker/pull/19001).

I have a IP Block on OVH for my server with 16 extra public IPs. I totally use
these for good and not for [evil](https://github.com/jessfraz/tupperwarewithspears).

But to use these previously with Docker containers meant hackery with the
awesome [pipework](https://github.com/jpetazzo/pipework). Or even worse some
homegrown, Jess bash scripts.

But now MY LIFE JUST GOT SO MUCH EASIER. Let me show you how:

```bash
# create a new bridge network with your subnet and gateway for your ip block
$ docker network create --subnet 203.0.113.0/24 --gateway 203.0.113.254 iptastic

# run a nginx container with a specific ip in that block
$ docker run --rm -it --net iptastic --ip 203.0.113.2 nginx

# curl the ip from any other place (assuming this is a public ip block duh)
$ curl 203.0.113.2

# BOOM golden
```

It's so amazing I can rewrite
[tupperwarewithspears](https://github.com/jessfraz/tupperwarewithspears) to
use this :D
