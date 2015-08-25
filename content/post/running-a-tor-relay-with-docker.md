+++
date = "2015-08-23T12:02:01-04:00"
title = "Running a Tor relay with Docker"
author = "Jessica Frazelle"
description = "How to run a Tor relay with Docker."
+++

This post is part two of what will be a three part series. If you missed it
part one was [How to Route Traffic through a Tor Docker container](/post/routing-traffic-through-tor-docker-container/). 
I figured it was important, if you are going to be a tor user, to document how
you can help the Tor community by hosting a Tor relay. And guess what? You can
use Docker to do this!

There are three types of relays you can host, a bridge relay, a middle relay,
and an exit relay. Exit relays tend to be the ones recieving take down notices 
because the IP is the one the public sees traffic from Tor as. A great reference
for hosting an exit node can be found here
[blog.torproject.org/blog/tips-running-exit-node-minimal-harassment](https://blog.torproject.org/blog/tips-running-exit-node-minimal-harassment). 
But I will go over how to host each from a Docker container.
My example will have a reduced exit policy and limit which ports you are willing
to route traffic through.

If you don't want to host an exit node, host a middle relay instead! And if you
want your relay not publically listed in the network then host a bridge.

### Creating the base image

I have created a Docker image
[jess/tor-relay](https://hub.docker.com/r/jess/tor-relay/) from this
[Dockerfile](https://github.com/jfrazelle/dockerfiles/blob/master/tor-relay/Dockerfile). 
Feel free to create your own image with the following Dockerfile:

```bsh
FROM alpine:latest

# Note: Tor is only in testing repo
RUN apk update && apk add \
    tor \
    --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ \
    && rm -rf /var/cache/apk/*

# default port to used for incoming Tor connections
# can be changed by changing 'ORPort' in torrc
EXPOSE 9001

# copy in our torrc files
COPY torrc.bridge /etc/tor/torrc.bridge
COPY torrc.middle /etc/tor/torrc.middle
COPY torrc.exit /etc/tor/torrc.exit

# make sure files are owned by tor user
RUN chown -R tor /etc/tor

USER tor

ENTRYPOINT [ "tor" ]
```

As you can see we are copying 3 different `torrc`'s into the container. One for
each a bridge, middle, and exit relay.

I used alpine linux because it is super minimal. The size of the image is
11.52MB! Crazyyyyyyy!

### Running a bridge relay

A bridge relay is not publically listed as part of the Tor network. This is
helpful in places that block all the IPs of publically listed Tor relays.

The `torrc.bridge` file for the bridge relay looks like the following:

```
ORPort 9001
## A handle for your relay, so people don't have to refer to it by key.
Nickname hacktheplanet
ContactInfo ${CONTACT_GPG_FINGERPRINT} ${CONTACT_NAME} ${CONTACT_EMAIL}
BridgeRelay 1
```

To run the image for a bridge relay:

```bsh
$ docker run -d \
    -v /etc/localtime:/etc/localtime \ # so time is synced
    --restart always \ # why not?
    -p 9001:9001 \ # expose/publish the port
    --name tor-relay \
    jess/tor-relay -f /etc/tor/torrc.bridge
```

And now you are helping the tor network by running a bridge relay! Yayyy \o/

### Running a middle relay

A middle relay is one of the first few relays traffic flows through. Traffic
will always pass through at least 3 relays. The last relay being an exit node
and all relays before that a middle relay.

The `torrc.middle` file for the middle relay looks like the following:

```
ORPort 9001
## A handle for your relay, so people don't have to refer to it by key.
Nickname hacktheplanet
ContactInfo ${CONTACT_GPG_FINGERPRINT} ${CONTACT_NAME} ${CONTACT_EMAIL}
ExitPolicy reject *:*
```

To run the image for a middle relay:

```bsh
$ docker run -d \
    -v /etc/localtime:/etc/localtime \ # so time is synced
    --restart always \ # why not?
    -p 9001:9001 \ # expose/publish the port
    --name tor-relay \
    jess/tor-relay -f /etc/tor/torrc.middle
```

And now you are helping the tor network by running a middle relay!

### Running an exit relay

The exit relay is the last relay traffic is filtered through.

The `torrc.exit`  file for the exit node looks like the following:

```
ORPort 9001
## A handle for your relay, so people don't have to refer to it by key.
Nickname hacktheplanet
ContactInfo ${CONTACT_GPG_FINGERPRINT} ${CONTACT_NAME} ${CONTACT_EMAIL}

# Reduced exit policy from
# https://trac.torproject.org/projects/tor/wiki/doc/ReducedExitPolicy
ExitPolicy accept *:20-23     # FTP, SSH, telnet
ExitPolicy accept *:43        # WHOIS
ExitPolicy accept *:53        # DNS
ExitPolicy accept *:79-81     # finger, HTTP
ExitPolicy accept *:88        # kerberos
ExitPolicy accept *:110       # POP3
ExitPolicy accept *:143       # IMAP
ExitPolicy accept *:194       # IRC
ExitPolicy accept *:220       # IMAP3
ExitPolicy accept *:389       # LDAP
ExitPolicy accept *:443       # HTTPS
ExitPolicy accept *:464       # kpasswd
ExitPolicy accept *:465       # URD for SSM (more often: an alternative SUBMISSION port, see 587)
ExitPolicy accept *:531       # IRC/AIM
ExitPolicy accept *:543-544   # Kerberos
ExitPolicy accept *:554       # RTSP
ExitPolicy accept *:563       # NNTP over SSL
ExitPolicy accept *:587       # SUBMISSION (authenticated clients [MUA's like Thunderbird] send mail over STARTTLS SMTP here)
ExitPolicy accept *:636       # LDAP over SSL
ExitPolicy accept *:706       # SILC
ExitPolicy accept *:749       # kerberos 
ExitPolicy accept *:873       # rsync
ExitPolicy accept *:902-904   # VMware
ExitPolicy accept *:981       # Remote HTTPS management for firewall
ExitPolicy accept *:989-995   # FTP over SSL, Netnews Administration System, telnets, IMAP over SSL, ircs, POP3 over SSL
ExitPolicy accept *:1194      # OpenVPN
ExitPolicy accept *:1220      # QT Server Admin
ExitPolicy accept *:1293      # PKT-KRB-IPSec
ExitPolicy accept *:1500      # VLSI License Manager
ExitPolicy accept *:1533      # Sametime
ExitPolicy accept *:1677      # GroupWise
ExitPolicy accept *:1723      # PPTP
ExitPolicy accept *:1755      # RTSP
ExitPolicy accept *:1863      # MSNP
ExitPolicy accept *:2082      # Infowave Mobility Server
ExitPolicy accept *:2083      # Secure Radius Service (radsec)
ExitPolicy accept *:2086-2087 # GNUnet, ELI
ExitPolicy accept *:2095-2096 # NBX
ExitPolicy accept *:2102-2104 # Zephyr
ExitPolicy accept *:3128      # SQUID
ExitPolicy accept *:3389      # MS WBT
ExitPolicy accept *:3690      # SVN
ExitPolicy accept *:4321      # RWHOIS
ExitPolicy accept *:4643      # Virtuozzo
ExitPolicy accept *:5050      # MMCC
ExitPolicy accept *:5190      # ICQ
ExitPolicy accept *:5222-5223 # XMPP, XMPP over SSL
ExitPolicy accept *:5228      # Android Market
ExitPolicy accept *:5900      # VNC
ExitPolicy accept *:6660-6669 # IRC
ExitPolicy accept *:6679      # IRC SSL  
ExitPolicy accept *:6697      # IRC SSL  
ExitPolicy accept *:8000      # iRDMI
ExitPolicy accept *:8008      # HTTP alternate
ExitPolicy accept *:8074      # Gadu-Gadu
ExitPolicy accept *:8080      # HTTP Proxies
ExitPolicy accept *:8082      # HTTPS Electrum Bitcoin port
ExitPolicy accept *:8087-8088 # Simplify Media SPP Protocol, Radan HTTP
ExitPolicy accept *:8332-8333 # Bitcoin
ExitPolicy accept *:8443      # PCsync HTTPS
ExitPolicy accept *:8888      # HTTP Proxies, NewsEDGE
ExitPolicy accept *:9418      # git
ExitPolicy accept *:9999      # distinct
ExitPolicy accept *:10000     # Network Data Management Protocol
ExitPolicy accept *:11371     # OpenPGP hkp (http keyserver protocol)
ExitPolicy accept *:19294     # Google Voice TCP
ExitPolicy accept *:19638     # Ensim control panel
ExitPolicy accept *:50002     # Electrum Bitcoin SSL
ExitPolicy accept *:64738     # Mumble
ExitPolicy reject *:*
```


To run the image for an exit node:

```bsh
$ docker run -d \
    -v /etc/localtime:/etc/localtime \ # so time is synced
    --restart always \ # why not?
    -p 9001:9001 \ # expose/publish the port
    --name tor-relay \
    jess/tor-relay -f /etc/tor/torrc.exit
```

And now you are helping the tor network by running an exit relay!

After running for a couple hours, giving time to
propogate, you can check [atlas.torproject.org](https://atlas.torproject.org)
to check if your node has successfully registered in the network.

Stay tuned for part three of the series where I go over how to run Docker
containers with a Tor networking plugin I am working with Docker's new
networking plugins. But of course if you are going to use
the plugin or route all your traffic through a Tor Docker container (from my first
post), you should really consider hosting a relay. The more people who run 
relays, the faster the Tor network will be.
