+++
date = "2018-06-14T12:17:58-07:00"
title = "Installing and Using Wireguard, obviously with containers"
author = "Jessica Frazelle"
description = "How to install and use the Wireguard VPN, obviously with containers."
+++

[Wireguard](https://www.wireguard.com/) is the hip, new way to VPN :P

No, but seriously I wanted to try it out because it is super interesting and
I think the direction it is going is awesome. Read about it 
[on their website](https://www.wireguard.com/#about-the-project) if
you have not already.

If you are new to my blog, I HATEEEE installing things on my host. I run
everything in containers. Wireguard is a kernel module. BUT guess what,
literally anything can be run in a container. This post is going
to go over how to install the Wireguard module by using a container and how to
run the tools from a container as well.

## Installing

I wrote a [Dockerfile](https://github.com/jessfraz/dockerfiles/blob/master/wireguard/install/Dockerfile)
for installing the kernel module.

You can run it with:

```console
$ docker run --rm -it \
 	--name wireguard \
 	-v /lib/modules:/lib/modules \
 	-v /usr/src:/usr/src:ro \
 	r.j3ss.co/wireguard:install
```

This only works if you have your kernel headers installed in `/usr/src` and 
your kernel allows kernel modules (`CONFIG_MODULES=y`).

If you are like me and set `CONFIG_MODULES=n` then you can use my 
[kernel-builder Dockerfile](https://github.com/jessfraz/dockerfiles/blob/master/kernel-builder/Dockerfile)
to build a custom kernel.

```console
$ docker run --rm -it \
    -v /usr/src:/usr/src \
    -v /lib/modules:/lib/modules \
    -v /boot:/boot \
    --name kernel-builder \
    r.j3ss.co/kernel-builder
```

That will pop you into a bash shell where you can run the following 
[build script](https://github.com/jessfraz/dockerfiles/blob/master/kernel-builder/build_kernel)
to build a specific kernel version.

```console
# build_kernel 4.17.1
```

That saves the `vmlinuz` to `/boot` where you can then update your initramfs
for the new image and add it to your bootloader if needed.

## Using `wg`

`wg` is the command for interacting with Wireguard. You can learn more about it
in their [docs](https://www.wireguard.com/quickstart/#command-line-interface).

I put the tools in a container and added a bash alias for them:

```console
$ type wg
wg is a function
wg () 
{ 
    docker run -it --rm --log-driver none -v /tmp:/tmp --cap-add NET_ADMIN --net host --name wg r.j3ss.co/wg "$@"
}
```

Then you can run the following commands to try sending some packets through
Wireguard.

```console
$ export WG_PRIVATE_KEY="$(wg genkey)"

# open file descriptior 3 with some initial details
$ exec 3<>/dev/tcp/demo.wireguard.com/42912

$ wg pubkey <<<"$WG_PRIVATE_KEY" >&3

$ IFS=: read -r status server_pubkey server_port internal_ip <&3

# make sure the status is "OK"
$ echo $status
OK

# delete the link if you already had one
$ sudo ip link del dev wg0 || true

# create the wireguard link
$ sudo ip link add dev wg0 type wireguard

# save the private key to a temporary file
# obviously in a real world scenario we wouldn't be throwing these around
# all willy nilly
$ echo "$WG_PRIVATE_KEY" > /tmp/wg-privatekey

# configure the interface
$ wg set wg0 private-key /tmp/wg-privatekey peer "$server_pubkey" allowed-ips 0.0.0.0/0 endpoint "demo.wireguard.com:$server_port" persistent-keepalive 25

# assign an ip address/peer
$ sudo -E ip address add "$internal_ip"/24 dev wg0

# bring the interface up
$ sudo ip link set up dev wg0

# make it the default route
$ export WG_HOST="$(wg show wg0 endpoints | sed -n 's/.*\t\(.*\):.*/\1/p')"

# add the routes
$ sudo -E ip route add $(ip route get $WG_HOST | sed '/ via [0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/{s/^\(.* via [0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\).*/\1/}' | head -n 1)
$ sudo ip route add 0/1 dev wg0
$ sudo ip route add 128/1 dev wg0
```

Test it is routing!

```console
$ curl https://httpbin.j3ss.co/ip
{"origin":"163.172.161.0"}
```

And that's all. Just thought it was kinda fun using this and now it is very
easy to install :)
