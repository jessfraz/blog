+++
date = "2018-11-05T08:09:26-07:00"
title = "You might not need Kubernetes"
author = "Jessica Frazelle"
description = "Why use something bloated when you could use something minimal."
+++

I have realized recently that a lot of people think I am just a shill for
Kubernetes and I am not. What I have done is write a few blog posts on
some interesting problems to be solved in Kubernetes. _But_ I would like to
emphasize that those problems are pretty exclusive to the way Kubernetes was
designed and you could easily build your own orchestrator without them.

#### Containerd

If you need an example of a custom, minimal orchestrator with containerd you
should checkout [stellar](https://github.com/ehazlett/stellar/).

Or see my [design doc for a multi-tenant orchestrator](https://blog.jessfraz.com/post/secret-design-docs-multi-tenant-orchestrator/).

I'll let you dive into that in your own time though. Let's take a new look at
a blog post I wrote about [Building images securely on Kubernetes](https://blog.jessfraz.com/post/building-container-images-securely-on-kubernetes/).

I feel like I should have more clearly stated how this problem is pretty
exclusive to Kubernetes. It's also not really a hard problem. The hard problem
I was solving in that post was _not_ how to build images on Kubernetes but how to
build images as an unprivileged user in Linux. _That_ is a hard problem. And
a serious problem for companies who don't allow root on their machines.

The easier choice if all you need to do is build an image _and_ you are already
using containerd, is to run
[buildkit](https://github.com/moby/buildkit) on the same machine and then you
can use the buildkit API library to build your dockerfiles.

Or just run docker-in-docker, I have done this for years on my CI with
absolutely no problems.

Anyways, the point I am trying to make is you should use whatever is the easiest
thing for your use case and not just what is popular on the internet. With
complexity comes a steep learning curve and with a massive number of pluggable
layers comes yak shaves until the end of time.

Think for yourselves, don't be sheep.

![/img/sheep.gif](/img/sheep.gif)
