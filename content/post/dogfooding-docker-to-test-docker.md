+++
date = "2015-06-06T21:10:30-04:00"
title = "Tales of a Part-time Sysadmin: Dogfooding Docker to test Docker"
author = "Jessica Frazelle"
description = "How to we test docker by running all the docker core infrastucture with Docker."
+++

This is a tale about how we use Docker to test Docker. Yes, I am familiar with
the meme. Puhlease.

Many of you are familiar with the fact I work on the Docker core team. Which
consists of fixinng bugs, doing releases, reviewing PRs, hanging out on IRC,
mailing lists etc etc etc. But what you may not know is that in addition to all
these things I also manage our testing infrastructure. Now really this in
itself could be a fulltime job. However it is not _my_ fulltime job, nor would
I _ever_ want it to be. [insert gif about yak shaving here]

This blog post is going to be about how I manage ~50 servers but don't do
anything at all. Of course, I have my angry sysadmin moments when everything
breaks and I could punch a whole in a wall... but who doesn't?

### Our CI

First let me take a chance to familiarize you with how we test Docker. Docker's
tests run in a Docker container. We use Jenkins as our CI mostly because we
needed a lot of flexability and control. 

Obviously everything in our infrastructure runs in Docker, so that even goes
for Jenkins. We use the [official
image](https://registry.hub.docker.com/u/library/jenkins/) for our Jenkins container.

Docker itself has 6 different storage driver options. These are `aufs`,
`btrfs`, `devmapper`, `overlay`, `vfs`, and `zfs`. We have servers that use
each of these hooked up to our Jenkins instance for testing.

Along with all the storage driver options, Docker also runs on any linux
distro and a world of different linux kernel versions. In order to be able 
to try and test all this differentiation, each server runs a different kernel 
and all major linux distros are accounted for.

With every push to master on the docker/docker repo, we run tests on the entire
storage driver matrix. We also trigger builds to test the unsupported `lxc`
execdriver for Docker. _And_ we trigger builds to test the Docker Windows
client. Right there is three different jobs running on 8 different servers just
for 1 push to master.

Did I mention we have 9 Windows servers and 9 linux remote hosts paired with
those servers for testing Docker on Windows?

With every pull request to Docker we kick off 3 builds on 3 different servers.
We have 8 linux Docker nodes reserved exclusively for testing PRs. These run
the Docker tests and the new "Experimental Tests". The last of the 3 is the
Windows client test.

Considering the Docker project gets over 100 pull requests a week, with
multiple revision cycles you can only imagine the number of builds we process
in a day.

The manager for the PR builds is a small service called 
[leeroy](https://github.com/jfrazaelle/leeroy) which also makes
sure every PR has been signed with the Docker DCO before it even triggers
a build. This of course also runs in a container.

Now of course not every build is perfect, sometimes you have to rebuild. To
make this easy for all maintainers of the project we have an IRC bot, named
lovingly after Docker's turtle Gordon. The
[gordonbot](github.com/jfrazelle/gordon-bot) runs in a container _duh_, and can
kick off a rebuild on any of our bajillion servers.

Now I know what you are thinking, thats a lot of servers, how do you manage to
know when _heaven forbid_ one of them goes down.

### Consul

We have consul running **in a container** on all 50 servers in our
infrastructure. This is AMAZING. We use a sweet project, [consul
alerts](https://github.com/AcalephStorage/consul-alerts), also running in a 
container, to let us know when a node or service on a node goes down.

I would honestly be lost without consul. It keeps track via tags of the kernel
version, storage driver, linux distro, etc of the server. When a server goes
down I can decifer if it is a bug with any of those things.

A great example of this is we recently merged the awesome changes to the
container network stack via [libnetwork](https://github.com/docker/libnetwork).
However, I noticed after the merge the servers with kernels 3.19.x and 3.18.x
were acting funny. We were able to fix kernel bugs that were
specific to those versions related to networking before an RC was even cut.

### Github Hooks for the Github Hooks Throne

We trigger a lot of cool things with every push to master. We use nsq to
collect the hooks and then pass the messages to all the consumers. Oh and
obviously nsq runs in a container, as well as the [hooks
service](https://github.com/crosbymichael/hooks).

#### Master Binaries

With every push to master we push new binaries to
[master.dockerproject.org](https://master.dockerproject.org). This way people
can easily try out new features.

The [docker-bb service](https://github.com/jfrazelle/docker-bb) is run in
a container ;). Hopefully you are catching on to a theme here...

#### Master Docs

What good would being able to try new features be, if you didn't have docs for
how to use them?

With every push to master, we deploy new docs to 
[docs.master.dockerproject.org](http://docs.master.dockerproject.org).

This is done with a [nsqexec service](https://github.com/jfrazelle/nsqexec),
wait for it.... RUNNING IN A CONTAINER.

### Always Testing

The greatest thing about all these services, which I so subtly mentioned,
running in containers is that we can always be dogfooding and testing Docker.
Right now we are getting ready to release Docker v1.7.0 and with every RC that
is built I upgrade the servers so we can catch bugs.

On the off season, I will randomly upgrade all the servers to the Docker master
binaries mentioned previously. This way we can catch things long before they
even hit an RC.

All this is so seamless and runs so well that I have time to do my actual job
of being a Docker core maintainer, occasionally fix some servers, spin up new
servers if we add storage drivers, upgrade servers' kernels, and write this blog
post.

Hope you enjoyed, also help us test RC's and Docker master!
