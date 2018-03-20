+++
date = "2018-03-20T11:25:24-04:00"
title = "Building Container Images Securely on Kubernetes"
author = "Jessica Frazelle"
description = "A post covering how to build container images securely on Kubernetes and why this was even a hard problem in the first place."
draft = true
+++

A lot of people seem to want to be able to build container images in Kubernetes
without mounting in the docker socket or doing anything to compromise the
security of their cluster.

This all was brought to my attention when my awesome coworker at [Gabe
Monroy](https://twitter.com/gabrtv)
and I were chatting with [Michelle Noorali](michellenoorali) over pizza at
Kubecon in Austin last December.

Here is pretty much how it went down:

```
Gabe: I’d would love to switch our clusters to a lightweight runtime like 
containerd, but we need those docker build apis right now. I wish someone 
would come up with an unprivileged container image builder..

Me: Oh that’s easy

Gabe: Bullshit, if it was easy someone would have done it already. I’ve wanted 
this for years. Please pass the ranch dressing.

Me: I’m telling you you’re wrong. I’ll prove it to you. It’s easy.

Judgy Four Seasons Staff: Excuse me, can I help you?

Me: Nah we’re good. Actually if you could grab me a slice of that Papa John's 
jalapano & pineapple that would be great.

.. next morning ..

100 lines of bash shaming in Gabe's inbox proving it could be done.
```

## Prior Art

A few years ago when I worked at Docker, [Stephen Day](https://github.com/stevvooe)
and [Michael Crosby](https://twitter.com/crosbymichael) did a POC demo of
a standalone image builder.

It still actually exists today in 
[a fork of docker/distribution on Stephen's github](https://github.com/stevvooe/distribution/tree/dist-demo).
It consisted of a `dist` command line tool for interacting with the registry
and runc. Combined together with the awesome powers of bash like so (`nsinit`
was `runc` before `runc` was A Thing):

```bash
#!/bin/bash

function FROM () {
    mkdir rootfs
    dist pull "$1" rootfs
}

function USERNS() {
    export nsinituserns="$1"
}

function CWD() {
    export nsinitcwd="$1"
}

function MEM() {
    export nsinitmem="$1"
}

function EXEC() {
    nsinit exec \
        --tty \
        --rootfs "$(pwd)/rootfs" \
        --create \
        --cwd="$nsinitcwd" \
        --memory-limit="$nsinitmem" \
        --memory-swap -1 \
        --userns-root-uid="$nsinituserns" \
        -- $@
}

function RUN() {
    t="\"$@\""
    EXEC sh -c "$t"
}
```

So in their demo, you would source the above bash script and then execute your
Dockerfile like it was also a bash script. Pretty cool right.

So that is what I sent to Gabe's inbox to prove it was possible but also like,
"Look I will make you something nice."

## Designing Something Nice

So I went out on my mission to make them something nice, which lead me through
a sea of existing tools. I collected all my findings [in a design doc](https://docs.google.com/document/d/1rT2GUSqDGcI2e6fD5nef7amkW0VFggwhlljrKQPTn0s/edit?usp=sharing) if you are curious as to what I think about the other existing tools.

I didn't want to reinvent the world I just wanted to make it unprivileged and
a single binary with a simple user interface that could easily be switched out
with docker.

Not all of my ideas are good. I first started on a FUSE snapshotter. Turns out
FUSE kinda sucks...

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">so fuse calls `getxattr` 2x the amount it calls `lookup` even if the damn inodes have no xattrs.... and it has to go back and forth from kernel to userspace to do it... I need a drink.</p>&mdash; jessie frazelle (@jessfraz) <a href="https://twitter.com/jessfraz/status/961712246178099200?ref_src=twsrc%5Etfw">February 8, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

I started playing with [buildkit](https://github.com/moby/buildkit). It's an
awesome project. [Tõnis Tiigi](https://github.com/tonistiigi) did a really
stellar job on it and I thought to myself, "I definitely want to use this as
the backend."

Buildkit is more cache-efficient than Docker because it can execute multiple
build stages concurrently with its internal DAG.

Then I stumbled upon 
[Akihiro Suda's patches for an unprivileged Buildkit](https://github.com/AkihiroSuda/buildkit_poc/commit/511c7e71156fb349dca52475d8c0dc0946159b7b).
This was _perfect_ for my use case.

I owe all these fine folks so much for the great work I got to build on top of.
:)

And thus came [img](https://github.com/genuinetools/img).

So that was all fine and dandy and it works great as unprivileged... on my
host. Now I'm a huge fan of desktop tools and this actually filled a large void
in my tooling that now I can build as unprivileged on my host without Docker.

But I still have to make this work in Kubernetes so I can make Gabe happy and
fulfill my dreams of eating more pineapple and jalapeno pizzas at Kubecons.

## Why is this problem so hard?

Let me go over in detail some of the patches needed to even make this work as
unprivileged on my host.

For one, we need `subuid` and `subgid` maps. See [@AkihiroSuda's patch](https://github.com/opencontainers/runc/pull/1692).
We also need to `setgroups`. See [@AkihiroSuda's patch for that as well](https://github.com/opencontainers/runc/pull/1693).
Those allow us to use `apt` in unprivileged user namespaces.

Then if we want to use the contianerd snapshotter backends and actually mount
the filesystems as we diff them, then we need `unprivileged mounting`. Which
can only be done from _inside_ a user and mount namespace. So we need to do
this at the start of our binary before we even do anything else.

Granted mounting is not a requirement of building docker images. You can always
go the route of [orca-build](https://github.com/cyphar/orca-build) and
[umoci](https://github.com/openSUSE/umoci) and not mount at all. [umoci](https://umo.ci/)
is also an unprivileged image builder and was made long before I even made mine
by the talended [Aleksa Sarai](https://github.com/cyphar) who is also
responsible for a lot of the rootless containers work upstream in runc.

## Getting this to work _in_ containers...

`img` works on my host which is all fine and dandy but I gotta help my k8s pals do
their builds...

Enter the next problem.

The next issue involved [not being able to mount proc inside a Docker container](https://github.com/opencontainers/runc/issues/1658).

My first thought was "well it must be something Docker is doing". So I isolated
the problem, put in a container and ten minutes after I dove into the rabbit
hole I realized it was the fact that Docker sets paths inside `/proc` to be
masked and readonly by default, preventing me from mounting.

You can find all the fun details on [opencontainers/runc#1658](https://github.com/opencontainers/runc/issues/1658#issuecomment-373122073).

Well this blows, I could obviously just run the container as `--privileged` but
thats really stupid and defeats the whole point of this exercise. I did not
want to add any extra capabilities or any host devices which is exactly what
`privileged` does... gross.

So I opened an [issue on Docker](https://github.com/moby/moby/issues/36597) and 
[made a patch](https://github.com/moby/moby/issues/36644).

Okay so problem solved. Wait... no... now I gotta pull that option through to
kubernetes...

So I opened a proposal there: [kubernetes/community#1934](https://github.com/kubernetes/community/pull/1934).

And I made a patch just for playing with it on my fork:
[jessfraz/kubernetes#rawproc](https://github.com/jessfraz/kubernetes/tree/rawproc).

Okay now I want to try it in a cluster...
enter `acs-engine`. I made a branch there as well for easily combining together
all my patches for testing: [jessfraz/acs-engine#rawproc](https://github.com/jessfraz/acs-engine/tree/rawproc).

Here is a yaml file you can use to deploy and try it:

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: img
  name: img
  annotations:
    container.apparmor.security.beta.kubernetes.io/img: unconfined
spec:
  securityContext:
    runAsUser: 1000
  containers:
  - image: r.j3ss.co/img
    imagePullPolicy: IfNotPresent
    name: img
    resources: {}
    command:
    - git
    - clone
    - https://github.com/jessfraz/dockerfiles
    - &&
    - cd
    - dockerfiles
    - &&
    - img 
    - build
    - -t
    - irssi
    - irssi/
  restartPolicy: Never
  securityContext:
    rawProc: true
```

## So is this secure?

Well I am running that pod as user 1000. Granted it does have access to a raw
proc without masks the nested containers do not. They have `/proc` set as
read-only and masked paths. The nested containers also use a default seccomp
profile denying privileged operations that should not be allowed.

Your main concern here is _my code_ and the code in buildkit and runc.
Personally I think that's fine because I obviously trust myself, but you are
more than welcome to audit it and open bugs and/or patches.

If you randomly generate different users for all your pod builds to run under
then you are relying on the user isolation of linux itself.

I will let you come to your own conclusions but hopefully I have laid out enough
background for you to do so.

You could also use my patches to acs-engine to run all your pods in Intel's
Clear Containers which are VMs and you would then have hardware isolation for
your little builders :)

You just need to use [this config](https://github.com/Azure/acs-engine/blob/master/examples/kubernetes-clear-containers.json).

And thus ends the most epic yak shave ever, minus the patches all being merged
upstream. Thanks for playing. Feel free to try it out on Azure with my branch
to acs-engine.
