+++
date = "2017-01-16T08:09:26-07:00"
title = "Ultimate Linux on the Desktop"
author = "Jessica Frazelle"
description = "Creating the ultimate Linux on the desktop experience for everything in containers."
+++

Over the past couple of years I have set out to create the ultimate Linux on
the desktop experience for myself. Obviously everyone who runs Linux has their
own [opinions on things](https://misc.j3ss.co/gifs/ihaveopinionsaboutthings.gif).
What this post will outline is _my_ ultimate Linux on the desktop experience.
So just remember that before you get your panties in a knot on HackerNews
because you live and die by Xmonad (I live and die by i3, fight me).

First, you should already know that I run everything on my laptop in containers.
I outlined this in my posts about
[Docker Containers on the Desktop](https://blog.jessfraz.com/post/docker-containers-on-the-desktop/)
and
[Runc Containers on the Desktop](https://blog.jessfraz.com/post/runc-containers-on-the-desktop/).

## Base OS

I used to use Debian as my base OS but I recently decided to try and run
CoreOS' Container Linux on the desktop. Container Linux is made for servers,
so obviously it doesn't have graphics drivers. I added them and made a few other
horrible tweaks that I'm sure would make some people at CoreOS cringe. I am not
proud of these things but overall it worked!

![coreos](/img/coreos.png)

Mostly the changes for graphics drivers were the same
exact changes you would make installing Gentoo on your host: setting
`VIDEO_CARDS="intel i915"` in `/etc/portage/make.conf`, `emerge`-ing
`sys-kernel/linux-firmware` etc, etc.

Then I cut out the things I don't need that only pertain to if you are using
Container Linux on your server, cluster management tools, support request
tools (lolz) etc. These were all pretty simple changes that I made to a new
`ebuild` that I cloned from the `coreos-base/coreos ebuild`.

I need to clean up the mess I've made of my forks of
the coreos build [scripts](https://github.com/jessfraz/scripts),
[init](https://github.com/jessfraz/init),
[ebuilds](https://github.com/jessfraz/coreos-overlay),
[manifest](https://github.com/jessfraz/manifest),
and [base layout](https://github.com/jessfraz/baselayout). But you can checkout
the `desktop` branch at each of those.

Let me go over some of the benefits I get from using CoreOS' Container Linux as
my base OS.

1. I can build my own images, it's Gentoo and I know `emerge` so I can
   customize the base anyway I want.

2. CoreOS' Container Linux uses the same auto update system as ChromeOS, which
   is all based on [Google's Omaha](https://github.com/google/omaha). So all
   I need to do to have auto updates for my OS is continuously release the
   modded version of Container Linux to an Omaha server, which I will host.
   (Yes I know I am insane to go through this much effort for my own laptop but
   whatever.)

3. The filesystem is setup perfectly for running containers, there is
   a read-only `/usr` and a stateful read/write `/`. The data stored on `/`
   will never be manipulated by the update process. Plus since `/usr` is
   read-only it really forces you to run everything in containers.

4. My hardware has TPM capabilities so I get [Trusted Computing through
   Container Linux](https://coreos.com/blog/coreos-trusted-computing.html).

## X11 & Wayland

Currently this setup is using X11 but that is not the goal in the future.
I plan to move it over to Wayland after the
[port of i3, sway,](https://github.com/SirCmpwn/sway) is feature compatible
with i3. It's really close to done so I can try it out currently.

This would eliminate all the problems with X being the worst, something
something keylogging blah blah blah. I'm not going to go into more detail now
because this is not meant to be a rant.

## Everything in Containers

I already mentioned my two other blog posts on running desktop apps with
Docker and Runc, but on this laptop I wanted something better.

You see the problem with both Docker and Runc as they are today is that they
must be run as root. And I'm not talking about the process _in_ the container.
I'm talking about the container spawner itself.

I outlined the future of
[Sandbox Containers](https://blog.jessfraz.com/post/getting-towards-real-sandbox-containers/)
and there are patches to Runc to enable
[rootless containers](https://github.com/opencontainers/runc/pull/774). If you want to know more
you should also watch [Aleksa Sarai's talk](https://www.youtube.com/watch?v=r6EcUyamu94&feature=youtu.be).
On this laptop I am _only_ using rootless containers.

So overall everything runs in containers, I can automatically update my
operating system, and the containers are NOT running as root on my host. This
is the dream and reality.

If you want to know all the stuff about what laptop I use you should checkout
my [uses this interview](https://usesthis.com/interviews/jessie.frazelle/).
