+++
date = "2015-06-20T19:40:01-04:00"
title = "How to Route Traffic through a Tor Docker container"
author = "Jessica Frazelle"
description = "How to route your traffic through a Tor Docker container."
+++

This blog post is going to explain how to route traffic on your host through
a Tor Docker container.

It's actually a lot simplier than you would think. But it involves dealing with
some unsavory things such as iptables.

![iptables](https://misc.j3ss.co/gifs/iptables.gif)

### Run the Image

I have a fork of the tor source code and a branch with a Dockerfile. I have
submitted upstream... we will see if they take it. The final result is the
image [jess/tor](https://hub.docker.com/r/jess/tor), but you can
easily build locally from my repo
[jessfraz/tor](https://github.com/jessfraz/tor/tree/add-dockerfile).

So let's run the image:

```bsh
$ docker run -d \
    --net host \
    --restart always \
    --name tor \
    jess/tor
```

Easy right? I can already hear the haters, "blah blah blah net host". Chill
out, the point is to route all our traffic duhhhh so we may as well, otherwise
would need to change / overwrite some of Docker's iptables rules, and really
who has time for that shit...

You do? Ok make a PR to [this blog post](https://github.com/jessfraz/blog).

### Routing Traffic

Contain yourselves, I am about to throw down some sick iptables rules.

```bsh
#!/bin/bash
# Most of this is credited to
# https://trac.torproject.org/projects/tor/wiki/doc/TransparentProxy
# With a few minor edits

# to run iptables commands you need to be root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    return 1
fi

### set variables
# destinations you don't want routed through Tor
_non_tor="192.168.1.0/24 192.168.0.0/24"

# get the UID that Tor runs as
_tor_uid=$(docker exec -u tor tor id -u)

# Tor's TransPort
_trans_port="9040"
_dns_port="5353"

### set iptables *nat
iptables -t nat -A OUTPUT -m owner --uid-owner $_tor_uid -j RETURN
iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports $_dns_port

# allow clearnet access for hosts in $_non_tor
for _clearnet in $_non_tor 127.0.0.0/9 127.128.0.0/10; do
   iptables -t nat -A OUTPUT -d $_clearnet -j RETURN
done

# redirect all other output to Tor's TransPort
iptables -t nat -A OUTPUT -p tcp --syn -j REDIRECT --to-ports $_trans_port

### set iptables *filter
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# allow clearnet access for hosts in $_non_tor
for _clearnet in $_non_tor 127.0.0.0/8; do
   iptables -A OUTPUT -d $_clearnet -j ACCEPT
done

# allow only Tor output
iptables -A OUTPUT -m owner --uid-owner $_tor_uid -j ACCEPT
iptables -A OUTPUT -j REJECT
```
Check that we are routing via [check.torproject.org](https://check.torproject.org).

![tor](/img/tor.png)

Woooohoooo! Success.
