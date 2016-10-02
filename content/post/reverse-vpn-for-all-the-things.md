+++
date = "2015-10-02T11:47:47-07:00"
title = "Reverse VPN All The Things"
author = "Jessica Frazelle"
description = "Setting up a reverse VPN for all your things."
draft = true
+++

Usually when you think of a VPN, you think of accessing an office network from
somewhere _outside the office_. A reverse VPN is for exposing things from your
home network into the public. Why? Well for one, you shouldn't want to expose
your home network to the world. There are a lot of risks in doing that.
A reverse VPN allows you to securely control what you are exposing.

Personally I use this for hooks that Amazon Lamda hits to interact with my
Alexa. I use [this awesome project](https://github.com/jishi/node-sonos-http-api)
to get Alexa to talk to my Sonos speakers. This runs in a docker container on
my Synology NAS in my apartment. I also use a reverse VPN for my plex, blah
blah, blah it's super handy okay.

Let's set one up.

## On the Remote Machine

I like to use [kylemanna's openvpn docker image](https://github.com/kylemanna/docker-openvpn).
I have this on my private docker registry at `r.j3ss.co/openvpn-server`.
This image is publicly accessible and signed, etc.

First, we are going to run commands on our remote machine. I just spun up
a micro instance on Google Cloud. You can host it where ever you like though
just make sure you have docker installed there.

1) Generate the config, we are saving all the state into `/volumes/openvpn` but
you can store it wherever.

    ```bash
    # substitude your own domain for rvpn.j3ss.co below
    $ docker run --rm -it \
        -v /volumes/openvpn:/etc/openvpn \
        r.j3ss.co/openvpn-server \
        ovpn_genconfig -u udp://rvpn.j3ss.co:1194
    ```

2) Generate certificates:

    ```bash
    # This will prompt you for a passphrase and the information for your
    # certificate request.
    $ docker run --rm -it \
        -v /volumes/openvpn:/etc/openvpn \
        r.j3ss.co/openvpn-server \
        ovpn_initpki
    ```

    **NOTE**: If you need help with entropy you can download something over and
    over again: `while true; do sleep 1; curl
    'https://misc.j3ss.co/gifs/iptables.gif' > /dev/null; done`

3) Start the openvpn server:

    ```bash
    $ docker run --restart always -d \
        --name openvpn \
        -v /volumes/openvpn:/etc/openvpn \
        --net host \
        --cap-add=NET_ADMIN \
        r.j3ss.co/openvpn-server
	```

4) Create a client certificate, my client is `acidburn` you can name yours
whatever you would like.

    ```bash
    # This will prompt you to enter the certificate's password you set in step 2
    $ docker run --rm -it \
        -v /volumes/openvpn:/etc/openvpn \
        r.j3ss.co/openvpn-server \
        easyrsa build-client-full acidburn nopass
    ```

5) Get the client certificate (replace acidburn with your name from above):

    ```bash
    $ docker run --rm -it \
		-v /volumes/openvpn:/etc/openvpn \
		r.j3ss.co/openvpn-server \
		ovpn_getclient acidburn > ~/acidburn.ovpn
    ```

## On the Device

Take the `acidburn.ovpn` (yours may be named differently) and copy it to your
device. Of course on my NAS, I have docker installed, but you can install
openvpn on your host too (but I will judge you).

While ssh-ed into the machine I will start my openvpn client daemon:

```bash
$ docker run --restart always -d \
    --name openvpn \
    -v /path/to/config/acidburn.ovpn:/etc/openvpn/acidburn.ovpn:ro \
    --cap-add NET_ADMIN \
    --device /dev/net/tun \
    r.j3ss.co/openvpn /etc/openvpn/acidburn.ovpn
```

Now all you have to do it run all your other containers in `--net
container:openvpn`!

For example let's run an nginx container:

```bash
$ docker run --restart always -d \
	--name nginx \
	--net=container:openvpn \
	nginx
```

Now go to port 80 of your reverse vpn server. You should see the default nginx
page.

It's so easy! Alternatively if you would rather run everything on your server
over the vpn you can run the `openvpn` container with `--net host`.
I personally like the control though.

Happy reverse vpn-ing!
