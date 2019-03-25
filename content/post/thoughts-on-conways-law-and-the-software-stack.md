+++
date = "2019-03-25T08:09:26-07:00"
title = "Thoughts on Conway's Law and the software stack"
author = "Jessica Frazelle"
description = "Some thoughts on Conway's Law and its effect on the software stack and open source ecosystem."
+++

I’ve been talking to a lot of people in different layers of the stack during my
funemployment. I wanted to share one of the problems I’ve been thinking about
and maybe you can think of some clever solutions to solve it.

Conway's Law states "organizations which design systems ... are constrained
to produce designs which are copies of the communication structures of these
organizations."

If you were to apply Conway's Law to all the layers of the software stack and
open source software you’d see a problem: **There is not sufficient
communication between the various layers of software.**

Let’s dive in a bit to make the problem super clear.

I’ve met a bunch of hardware engineers and I’ve made a point about asking each
of them how they feel about using a single chip for multiple users. This
is, of course, the use case of the cloud. All of the hardware engineers either
laugh or are horrified and the resounding reaction is “you’d be crazy to think
hardware was ever intended to be used for isolating multiple users safely.”
Spectre and Meltdown proved this was true as well. Speculative execution was
a feature intended to make processors faster but was never thought about in
terms of the vector of hacking something running multi-tenant compute,
like a cloud provider. Seems like the software and hardware layers should
better communicate...

That’s just one example, let’s reverse the interaction. I’ve talked to a bunch
of firmware and kernel engineers and they’d all love if the firmware from chip
vendors did less complexity. For instance, it seems like a unanimous vote among
firmware and kernel engineers that CPU vendors should not  include runtime
services or SMM with their firmware. Open source firmware and kernel developers
would rather handle those problems at their layer of the stack. All the complexity
in the firmware leads to overlooked bugs and odd behavior that can’t be
controlled or debugged from the kernel developers layer and/or user space. Not to mention,
a lot of CPU vendors firmware is proprietary so it’s really hard to know if
a bug is truly a firmware bug.

Another example would be the [hack of SoftLayer](https://arstechnica.com/information-technology/2019/02/supermicro-hardware-weaknesses-let-researchers-backdoor-an-ibm-cloud-server/). Hackers modified the
firmware on the BMC from a bare metal host the cloud provider was offering.
This shows another mistake in having blinders on and not being conscious
of the other layers of the stack and the entire system.

Let’s move up the stack a bit to something I personally have experienced.
I worked a lot on container runtimes. I also have worked on kubernetes.
I was horrified to find people are running multi-tenant kubernetes clusters
with multiple customers processes. The architecture of kubernetes is
just [not designed for this](https://blog.jessfraz.com/post/secret-design-docs-multi-tenant-orchestrator/#why-not-kubernetes).

A common miscommunication is the "window dressing." For example, there is a
feature in kubernetes that prevents exec-ing into
containers. This is implemented by merely preventing the
API call in kubernetes. If a person has access to a cluster there are about 4 dozen different
ways I can think of to exec into a container and bypass this "feature" and
kubernetes entirely. Using
said "security feature" in kubernetes alone is not sufficient for security in any respect.
This is a common pattern.

All these problems are not small by any means. They are miscommunications
at various layers of the stack. They are people thinking an interface or
feature is secure when it is merely a window dressing that can be bypassed with
just a bit more knowledge about the stack. I really like the advice
[Lea Kissner](https://twitter.com/LeaKissner/status/1109259338265165824) gave:
"take the long view, not just the broad view." We should do this more often
when building systems.

The thought I’ve been noodling on is: how do we solve this? Is this something
a code hosting provider like GitHub should fix? But, that excludes all the
projects that are not on that platform. How do we promote better communication
between layers of the stack? How can we automate some of this away? Or is
the answer simply, own all the layers of the stack yourself?

