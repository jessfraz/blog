+++
date = "2017-04-26T12:17:58-07:00"
title = "Two Objects not Namespaced by the Linux Kernel"
author = "Jessica Frazelle"
description = "Covers two Linux primitives that are not namespaced by the current set of Linux kernel namespaces."
+++

If you are new to my blog then you might be new to the concept of Linux kernel
namespaces. I suggest first reading
[Getting Towards Real Sandbox Containers](https://blog.jessfraz.com/post/getting-towards-real-sandbox-containers/)
and
[Setting the Record Straight: containers vs. Zones vs. Jails vs. VMs](https://blog.jessfraz.com/post/containers-zones-jails-vms/).

Linux namespaces are one of the primitives that make up what is known as a
"container." They control what a process can see. Cgroups, the other main
ingredient of "containers", control what a process can use. But let's focus for
this post on namespaces. The current set of namespaces in the kernel are:
mount, pid, uts, ipc, net, and cgroup. These all cover basically exactly what
they are named after. But what is not covered? Well, let's go over two
of the things not namespaced by the Linux kernel.

### Time

First, and my favorite to nerd out about, is **time.** Now, it should go without
saying that _if_ you want to set the time in Linux you need `CAP_SYS_TIME`. By
default you do not get this capability in Docker containers. The `settimeofday`,
etc syscalls are also blocked by the default seccomp profile in Docker as well.

What happens if you do change the time in a container?

Well, it's not namespaced so obviously the time on the host would change as well.
"But whaaaaa? I thought containers were just like a VM", you ask. Again, you
should read my post
[Setting the Record Straight: containers vs. Zones vs. Jails vs. VMs](https://blog.jessfraz.com/post/containers-zones-jails-vms/).

One of my favorite questions I have been asked at a conference is "If you could
add any new namespace to Linux what would it be?" Obviously this is an awesome
question, totally up my alley, and not even a statement from someone trying to
prove to me "they know things." But I digress, I always answer with "Time."
Obviously there is no production use case for this, other than making more NTP
hell for yourself. I do believe there is a development use case. Say you want to
change the time for a test running in one container but not mess with the other
tests running in other containers. What a fun way to make a chaos monkey for NTP!
:P

### Kernel Keyring

The kernel keyring is another item not namespaced. There have been recent efforts
to [fix this for _user namespaces_](https://patchwork.kernel.org/patch/9394983/),
but the problem still stands if you are creating containers without user namespaces.
Again, the default Docker seccomp profile blocks these syscalls so you don't
shoot yourself in the foot.

What happens if you use the kernel keyring from within in a container
_without_ a user namespace?

Well if root in one container stores keys in the keyring, any other containers
on that same host can see it in their keyring, which is really just the same
exact keyring.

All in all, I hope this proves once again that you need more than just
namespaces and cgroups to get any sort of "real" isolation with containers.
Please, please don't disable seccomp or add extra capabilities you don't need.
Happy containering! I must leave you with this gif... :D

![turn-back-time](/img/turn-back-time.gif)
