+++
date = "2016-05-01T12:17:58-07:00"
title = "Getting Towards Real Sandbox Containers"
author = "Jessica Frazelle"
description = "What steps need to be done until we have containers that can be considered sandboxes"
+++

Containers are all the rage right now.

At the very core of containers are the same Linux primitives that are also used to create application sandboxes.
The most common sandbox you may be familiar with is the Chrome sandbox. You can read in detail about the Chrome sandbox
here: [chromium.googlesource.com/chromium/src/+/master/docs/linux_sandboxing.md](https://chromium.googlesource.com/chromium/src/+/master/docs/linux_sandboxing.md).
The relevant aspect for this article is the fact it uses user namespaces and seccomp. Other depreciated features include AppArmor
and SELinux. Sound familiar? That's because containers, as you've come to know them today, share the same features.

#### Why are containers not currently being considered a "sandbox"?

One of the key differences between how you run Chrome
and how you run a container are the privileges used. Chrome runs as your own unprivileged user. Most containers (be it docker, runc, or rkt) run as
root.

Yes, we all know that containers run unprivileged processes; but creating and running the containers themselves requires root privileges at some point.

#### How can we run containers as an unprivileged user?

Easy! With user namespaces, you might say. But it's not exactly that simple. One of the main differences between the Chrome
sandbox and containers is cgroups. Cgroups control what a process can use. Whereas namespaces
control what a process can see. Containers have cgroup resource management built in. Creating cgroups from an unprivileged
user is a bit difficult, especially device control groups.

If we ignore, for the time being, this huge fire tire that is creating cgroups as an unprivileged user, then
unprivileged containers are easy. User namespaces allow us to create all the namespaces without any further privileges.
The one key caveat being that the `{uid,gid}_map` must have the current host user mapped to the container uid that the process
will be run as. The size of the `{uid,gid}_map` can also only be 1. For example if you are running as uid 1000 to spawn the container, your
`{uid,gid}_map` for the process would be `0 1000 1` for uid 0 in the container. The 1 there refers to the size.

#### How is this different than the user namespace support currently in Docker?

This is quite different, but for very good reason. In Docker, by default, when the remapped user is created,
the `/etc/subuid` and `/etc/subgid` files are populated with a contiguous 65536 length range of subordinate user and group
IDs, starting at an offset based on prior entries in those files. Docker's implementation has a larger range of users that can
exist in the container as well as having a more "anonymous" mapped host user.
If you want to read more about the user namespace implementation
in Docker I would checkout [@estesp's blog](https://integratedcode.us/2015/10/13/user-namespaces-have-arrived-in-docker/) or the
the [docker docs](https://docs.docker.com/engine/reference/commandline/daemon/#daemon-user-namespace-options).

#### POC or GTFO

As a proof of concept of unprivileged containers without cgroups I made [binctr](https://github.com/jfrazelle/binctr). Which
spawned a
[mailing list thread for implementing this in runc/libcontainer](https://groups.google.com/a/opencontainers.org/forum/#!topic/dev/yutVaSLcqWI).
[Aleksa Sarai](https://github.com/cyphar) has started on a few patches and this might actually be a reality pretty soon!

#### Where does this put us in the "sandbox" landscape?

With this implementation we get:
- namespaces
- apparmor
- selinux
- seccomp
- capabilities limiting

**all created by an unprivileged user!**

Sandboxes should be very application specific, using custom
AppArmor profiles, Seccomp profiles and the likes. A generic container will
never be equivalent to a sandbox because it's too universal to really lock down
the application.

Containers are not going to be the answer to preventing your application from
being compromised, but they _can_ limit the damage from a compromise. The world
an attacker might see from inside a very strict container with custom
AppArmor/Seccomp profiles greatly differs than that without the use of
containers. With namespaces we limit the application from seeing various things
such as network, mounts, processes, etc. And with cgroups we can further limit
what the attacker can use be it a large about of memory, cpu, or even a fork
bomb.

#### But what about cgroups?

We _can_ set up cgroups for memory, blkio, cpu, and
pids with an unpriviledged user as long as the cgroup subsystem has been chowned to the
correct user. Devices are a different story though. Considering the fact you
cannot mknod in a user namespace it is not the worst thing in the world.

Let's not completely rule out the devices cgroup. In the future this might be entirely possible. In kernels 4.6+, there is a new
cgroup namespace. For now all this does is mask the cgroups path inside the container so it is not entirely useful
for unprivileged containers at all. But in the future maybe it _could_ be (if we ask nice enough?).

#### What is the awesome sauce we all gain from this?

Well judging by the original github issue about unpriviledged runc containers, the largest group of commenters is from
the scientific community who are restricted to not run certain programs as root.


But there is so much more that this can be used for. One of my most anticipated use cases is the work being done by
[Alex Larsson](https://blogs.gnome.org/alexl/) on [xdg-app](https://wiki.gnome.org/Projects/SandboxedApps) to run applications in sandboxes.
Definitely checkout [bubblewrap](https://github.com/projectatomic/bubblewrap) if you are interested in this.

Also [subgraph](https://subgraph.com/), the container based OS which specializes in security and privacy, have this same idea in mind.

I am a huge fan of running desktop applications in containers as well as solving multi-tenancy for running containers.
I definitely hope to help evolve containers into real sandboxes in the future.

