+++
date = "2016-01-19T02:17:14Z"
title = "Runc Containers on the Desktop"
author = "Jessica Frazelle"
description = "How to run all my previous docker containers with runc, also how to convert docker containers to a runc config."
+++

Almost exactly a year ago, I wrote a post about running
[Docker Containers on the Desktop](/post/docker-containers-on-the-desktop/).
Well it is a new year, and I have ended up converting all my docker containers to
[runc](https://github.com/opencontainers/runc) configs, so it's the perfect time
for a new blog post.

For those of you unfamiliar with the Open Container Initiative you should check
out [opencontainers.org](https://www.opencontainers.org/).

*Why the switch?* you ask... well let me explain.

Our fellow Docker maintainer and pal [Phil Estes](https://twitter.com/estesp)
made an awesome patch to add user namespaces to Docker.

Now me, being the completely insane containerizer that I am, desperately wanted to
run all my crazy sound/video device mounting containers in user namespaces.

Well the way this could work is by having a custom `gid_map` for the `audio` and
`video` groups to map to the host groups so we can have permission to access
these devices in the container. In layman's terms, I basically wanted to poke a
teeny tiny map in the user namespace to be able to have permission to use my sound
and video devices.

Obviously this was not the design of the feature, but since `runc` exposes the
`uidMappings` and `gidMappings`, I knew I could have the power to do as I please.
This is the awesome thing about `runc`. You, the user, have all the control.

So for chrome, this is what you get for mappings:
[github.com/jfrazelle/containers:chrome/runtime.json#L144](https://github.com/jfrazelle/containers/blob/master/chrome/runtime.json#L144).
If you look closely, or know what you are looking at, you can see group `29` and `44`
are mapped to the same group ids as the host.

Then you can do cool things like listen to Taylor Swift in a container with a
user namespace.

![chrome-userns](/img/chrome-userns.png)

Pretty cool right. So I went all OCD on this, like most things I encounter, and I
converted _all_ my containers. Obviously I found a way to generate them.

### Riddler

Introducing [github.com/jfrazelle/riddler](https://github.com/jfrazelle/riddler)!
`riddler` will take a running/stopped docker container and convert the inspect information
into the [oci spec](https://github.com/opencontainers/specs)
(which can be run by `runc`, or any other oci compatible tool).

It has some opinionated features in that it will always try to set up a `gid_map`
that works with your devices. You can also pass custom hooks to automatically add
to the runc config as `prestart`, `poststart`, or `poststop` hooks. Which leads
me to the next tool I built.

### Netns

Say hello to [github.com/jfrazelle/netns](https://github.com/jfrazelle/netns)!
So you want your runc containers to have networking, eh? How about something super
simple like a bridge? `netns` does just that. It sets up a bridge network
for all your runc containers when added via the `prestart` hook.

It's actually super simple code as well thanks to the awesome
[`netlink` pkg](https://github.com/vishvananda/netlink) from
[vishvananda](https://github.com/vishvananda).

`netns` even saves the ip for the container in a `.ip` file in the directory with
your config. Then other hooks can use this to do other things. For instance I use
the [`hostess` cli](https://github.com/cbednarski/hostess) to then add an entry to
my host's `/etc/hosts` file, so I don't have to remember the ip for the container
when I want to reach it.

You can find all my hook scripts in
[github.com/jfrazelle/containers:hack/scripts](https://github.com/jfrazelle/containers/tree/master/hack/scripts).

### Magneto

The last tool I made was a copy of `docker stats` for `runc`. But what I really wanted
was the new `pids` cgroup stats, that [Aleksa Sarai](https://github.com/cyphar) added
to the kernel and runc (and soon docker ;).

`runc` has a command `runc events` which outputs json stats in an interval. All you have
to do is pipe that to magneto to get the awesome ux.

The following is for my chrome container:

```bash
$ sudo runc events | magneto
```

![magneto](/img/magneto.png)

### All the configs

If you are interested in all the configs for my containers, checkout
[github.com/jfrazelle/containers](https://github.com/jfrazelle/containers).

I even included a [`systemd` service file](https://github.com/jfrazelle/containers/blob/master/runc%40.service)
that can easily run any container (without a tty) in this directory via:

```bash
$ sudo systemctl start runc@foldername

# for example:
$ sudo systemctl start runc@chrome
```

**NOTE:** Keep in mind since these are generated a lot of the filepaths are hardcoded for things on
_my_ host. So if you try to run these and aren't me I don't want to hear any whining.

Happy namespacing!
