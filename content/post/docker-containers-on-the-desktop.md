+++
date = "2015-02-21T13:16:52-04:00"
title = "Docker Containers on the Desktop"
author = "Jessica Frazelle"
description = "How to run docker containers on your desktop."
aliases = [
    "/posts/docker-containers-on-the-desktop.html"
]
+++


Hello!

If you are not familiar with [Docker](https://github.com/docker/docker), it is the popular open source container engine.

Most people use Docker for containing applications to deploy into production or for building their applications in a contained environment. This is all fine & dandy, and saves developers & ops engineers huge headaches, but I like to use Docker in a not-so-typical way.

I use Docker to run all the desktop apps on my computers.<!--more-->

But why would I even want to run all these apps in containers? Well let me explain. I used to be an OS X user, and the great thing about OS X is the OS X App Sandbox.

> App Sandbox is an access control technology provided in OS X, enforced at the kernel level. Its strategy is twofold:

> App Sandbox enables you to describe how your app interacts with the system. The system then grants your app the access it needs to get its job done, and no more.

> App Sandbox provides a last line of defense against the theft, corruption, or deletion of user data if an attacker successfully exploits security holes in your app or the frameworks it is linked against.

> <small>[Apple About App Sandbox](https://developer.apple.com/library/mac/documentation/Security/Conceptual/AppSandboxDesignGuide/AboutAppSandbox/AboutAppSandbox.html)</small>

I am using the Apple App Sandbox as an example so people can grasp the concept easily. I am **not** saying this is exactly like that and has all the features. This is not a sandbox. It is more like a cool hack.

I hate installing things on my host and the files getting everywhere. I wanted the ability to delete an app and know it is gone fully without some random file hanging around. This gave me that. Not only that, I can control how much CPU and Memory the app uses. Yes, the cpu/memory hungry chrome is now perfectly contained!

**"What?!?!"**, you say. Let me show you.

The following covers a few of my favorite applications I run in containers. Each of the commands written below is actually pulled directly from my bash aliases. So you can have the same user experience as running one command today.

## TUIs (Text User Interface, pronounced *too-eee*)

Let's start with some easy text-based applications:

### 1. Irssi

[Dockerfile](https://github.com/jessfraz/dockerfiles/blob/master/irssi/Dockerfile)

Best IRC client.

<pre class="prettyprint lang-sh">
$ docker run -it \
    -v /etc/localtime:/etc/localtime \
    -v $HOME/.irssi:/home/user/.irssi \ # mounts irssi config in container
    --read-only \ # cool new feature in 1.5
    --name irssi \
    jess/irssi
</pre>

![irssi](/img/irssi.png)

### 2. Mutt

[Dockerfile](https://github.com/jessfraz/dockerfiles/blob/master/mutt/Dockerfile)

The text based email client that rules!

<pre class="prettyprint lang-sh">
$ docker run -it \
    -v /etc/localtime:/etc/localtime \
    -e GMAIL -e GMAIL_NAME \ # pass env variables to config
    -e GMAIL_PASS -e GMAIL_FROM \
    -v $HOME/.gnupg:/home/user/.gnupg \ # so you can encrypt ;)
    --name mutt \
    jess/mutt
</pre>

![mutt](/img/mutt.png)

### 3. Rainbowstream

[Dockerfile](https://github.com/jessfraz/dockerfiles/blob/master/rainbowstream/Dockerfile)

Awesome text based twitter client.

<pre class="prettyprint lang-sh">
$ docker run -it \
    -v /etc/localtime:/etc/localtime \
    -v $HOME/.rainbow_oauth:/root/.rainbow_oauth \ # mount config files
    -v $HOME/.rainbow_config.json:/root/.rainbow_config.json \
    --name rainbowstream \
    jess/rainbowstream
</pre>

![rainbowstream](/img/rainbowstream.png)

### 4. Lynx

[Dockerfile](https://github.com/jessfraz/dockerfiles/blob/master/lynx/Dockerfile)

The browser everyone loves (to hate). *but secretly I love*

<pre class="prettyprint lang-sh">
$ docker run -it \
    --name lynx \
    jess/lynx
</pre>

![lynx](/img/lynx2.png)


*Yes I know my blog looks GREAT in lynx*

Okay, those text based apps are fun and all but how about we spice things up a bit.

## GUIs

None of the images below use `X11-Forwarding` with ssh. Because why should you ever have to install `ssh` into a container? EWWW UNNECESSARY BLOAT!

The images work by mounting the `X11` socket into the container! Yippeeeee!

The commands listed below are run on a linux machine. But Mac users, I have a special surprise for you. You can also do fun hacks with X11. Details are described [here](https://github.com/docker/docker/issues/8710).

Note my patch was added for `--device /dev/snd` in Docker 1.8, before that you needed `-v /dev/snd:/dev/snd --privileged`.

### 5. Chrome

[Dockerfile](https://github.com/jessfraz/dockerfiles/blob/master/chrome/stable/Dockerfile)

Pretty sure everyone knows what chrome is, but my image comes with flash and the google talk plugin so you can do hangouts.

<pre class="prettyprint lang-sh">
$ docker run -it \
    --net host \ # may as well YOLO
    --cpuset-cpus 0 \ # control the cpu
    --memory 512mb \ # max memory it can use
    -v /tmp/.X11-unix:/tmp/.X11-unix \ # mount the X11 socket
    -e DISPLAY=unix$DISPLAY \ # pass the display
    -v $HOME/Downloads:/root/Downloads \ # optional, but nice
    -v $HOME/.config/google-chrome/:/data \ # if you want to save state
    --device /dev/snd \ # so we have sound
    --name chrome \
    jess/chrome
</pre>

![chrome](/img/chrome.png)

### 6. Spotify

[Dockerfile](https://github.com/jessfraz/dockerfiles/blob/master/spotify/Dockerfile)

All the 90s hits you ever wanted and more.

<pre class="prettyprint lang-sh">
$ docker run -it \
    -v /tmp/.X11-unix:/tmp/.X11-unix \ # mount the X11 socket
    -e DISPLAY=unix$DISPLAY \ # pass the display
    --device /dev/snd \ # sound
    --name spotify \
    jess/spotify
</pre>

![spotify](/img/spotify.png)

### 7. Gparted

[Dockerfile](https://github.com/docker/docker/blob/master/contrib/desktop-integration/gparted/Dockerfile)

Partition your device in a container.

MIND BLOWN.

<pre class="prettyprint lang-sh">
$ docker run -it \
    -v /tmp/.X11-unix:/tmp/.X11-unix \ # mount the X11 socket
    -e DISPLAY=unix$DISPLAY \ # pass the display
    --device /dev/sda:/dev/sda \ # mount the device to partition
    --name gparted \
    jess/gparted
</pre>

![gparted](/img/gparted.png)

### 8. Skype

[Dockerfile](https://github.com/jessfraz/dockerfiles/blob/master/skype/Dockerfile)

The other video conferencer. This relies on running pulseaudio also in
a container.

<pre class="prettyprint lang-sh">
# start pulseaudio
$ docker run -d \
    -v /etc/localtime:/etc/localtime \
    -p 4713:4713 \ # expose the port
    --device /dev/snd \ # sound
    --name pulseaudio \
    jess/pulseaudio
</pre>


<pre class="prettyprint lang-sh">
# start skype
$ docker run -it \
    -v /etc/localtime:/etc/localtime \
    -v /tmp/.X11-unix:/tmp/.X11-unix \ # mount the X11 socket
    -e DISPLAY=unix$DISPLAY \ # pass the display
    --device /dev/snd \ # sound
    --link pulseaudio:pulseaudio \ # link pulseaudio
    -e PULSE_SERVER=pulseaudio \
    --device /dev/video0 \ # video
    --name skype \
    jess/skype
</pre>

![skype](/img/skype1.png)

![skype2](/img/skype2.png)

### 9. Tor Browser

[Dockerfile](https://github.com/jessfraz/dockerfiles/blob/master/tor-browser/Dockerfile)

Because Tor, duh!

<pre class="prettyprint lang-sh">
$ docker run -it \
    -v /tmp/.X11-unix:/tmp/.X11-unix \ # mount the X11 socket
    -e DISPLAY=unix$DISPLAY \ # pass the display
    --device /dev/snd \ # sound
    --name tor-browser \
    jess/tor-browser
</pre>

![tor-browser](/img/tor-browser.png)

### 10. Cathode

[Dockerfile](https://github.com/jessfraz/dockerfiles/blob/master/cathode/Dockerfile)

That super old school terminal.

<pre class="prettyprint lang-sh">
$ docker run -it \
    -v /tmp/.X11-unix:/tmp/.X11-unix \ # mount the X11 socket
    -e DISPLAY=unix$DISPLAY \ # pass the display
    --name cathode \
    jess/1995
</pre>

![cathode](/img/cathode.png)

So that's enough examples for now. But of course I have more. All my Dockerfiles live here: [github.com/jessfraz/dockerfiles](https://github.com/jessfraz/dockerfiles) and all my docker images are on the hub: [hub.docker.com/u/jess](https://hub.docker.com/u/jess/).

I gave a talk on this at [Dockercon 2015](https://www.youtube.com/watch?v=cYsVvV1aVss),
check out the [video](https://www.youtube.com/watch?v=cYsVvV1aVss).

Happy Dockerizing!!!
