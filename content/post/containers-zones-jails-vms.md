+++
date = "2017-03-28T12:17:58-07:00"
title = "Setting the Record Straight: containers vs. Zones vs. Jails vs. VMs"
author = "Jessica Frazelle"
description = "Design differences of containers, Zones, Jails and VMs."
+++

I'm tired of having the same conversation over and over again with people so
I figured I would put it into a blog post.

Many people ask me if I have tried or what I think of Solaris Zones / BSD Jails. The
answer is simply: I have tried them and I definitely like them. The conversation
then heads towards them telling me how Zones and Jails are far superior to
containers and that I should basically just give up with Linux containers and use VMs.

Which to be honest is a bit forward to someone who has spent a large portion of
her career working with containers and trying to make containers more secure.
Here is what I tell them:

### The Design of Solaris Zones, BSD Jails, VMs and containers are very different.

Solaris Zones, BSD Jails, and VMs are first class concepts. This is clear from
the [Solaris Zone Design Spec](https://us-east.manta.joyent.com/jmc/public/opensolaris/ARChive/PSARC/2002/174/zones-design.spec.opensolaris.pdf) and the [BSD Jails Handbook](https://www.freebsd.org/doc/handbook/jails.html).
I hope it can go without saying that VMs are very much a first class object
without me having to link you somewhere :P.

Containers on the other hand are not real things. I have said this in many
talks and I'm saying it again now.


<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">CONTAINERS ARE NOT A REAL THING!!! <a href="https://twitter.com/jessfraz">@jessfraz</a> talking containers <a href="https://twitter.com/hashtag/GoogleNext17?src=hash">#GoogleNext17</a> <a href="https://t.co/gzxjNnSk2n">pic.twitter.com/gzxjNnSk2n</a></p>&mdash; Jorge Silva (@thejsj) <a href="https://twitter.com/thejsj/status/840295431779172352">March 10, 2017</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>


A "container" is just a term people use to describe a combination of Linux
namespaces and cgroups. _Linux namespaces and cgroups_ ARE first class objects.
NOT containers.

I am trying to make this distinction very clear to make a point. The designs
are different. PERIOD.

Let's go over some of the things you can do with containers that you CANNOT do
with Jails or Zones or VMs.

**Sharing Namespaces**

Since containers are made with specific building blocks of namespaces this
allows for doing some super neat things like sharing namespaces.

There are many different namespaces but I will give a couple examples.

This specific example can be seen in a demo by Arnaud Porterie from [our talk at
Dockercon EU in 2015](https://www.youtube.com/watch?v=I7i4SY-iRkA). You can
have your application running in one container, then in a different
container sharing a net namespace you can run wireshark and inspect the packets
from the first container.

You could also do the same with sharing a pid namespace, except instead of
running wireshark you can run strace and debug your application from an
entirely different container.

**Sharing X socket**

I assume if you are on my blog you are familiar with my posts on [running
containers on your desktop](https://blog.jessfraz.com/post/docker-containers-on-the-desktop/).

This kind of flexibility allows for super awesome things but of course comes at
a price.

### Complexity == Bugs

Now is the point where the person I would be having the conversation with starts
yelling at me that containers are not secure. Hello, thank you, I am aware.
Also if anyone gives a shit about actually fixing this, it's me.

Again, containers were not a top level design, they are something we build
_from_ Linux primitives. Zones, Jails, and VMs are designed as top level
isolation.

The cool things I expressed above allow for a level of flexibility and control that Zones,
Jails, and VMs do not. By design.

This extra complexity leads to bugs that lead to container escapes. Don't get
me wrong you could also escape a VM, Jail or Zone, but the design is not as
complicated as that of the primitives that make up containers.
Less is more, and the less complexity you have the less likely you will have odd,
edge case bugs.

![roll-safe](/img/roll-safe.jpg)

The point I am trying to make is that Jails, Zones, VMs and containers were
designed and built in different ways. Containers are not a Linux isolation primitive, they
merely consume Linux primitives which allow for some interesting interactions.
They are not perfect; Nothing is.

We can make them better by reducing some of the complexity and building
hardening features around them which is a goal I have been trying and will
continue trying to do.

I personally love Zones, Jails, and VMs and I think they all have a particular
use case. The confusion with containers primarily lies in assuming they fulfill
the same use case as the others; which they do not. Containers allow for a flexibility
and control that is not capable with Jails, Zones, or VMs. And THAT IS A FEATURE.

`</rant>`


