+++
date = "2019-07-10T11:25:24-04:00"
title = "Linux Observability with BPF"
author = "Jessica Frazelle"
description = "Why BPF and XDP are something you should learn."
+++

Below is the foreward for the new book on 
[Linux Observability with BPF](http://shop.oreilly.com/product/0636920242581.do)
by two of my favorite programmers, 
[David Calavera](https://twitter.com/calavera) and [Lorenzo Fontana](https://twitter.com/fntlnz)! 
I was pretty stoked about getting to write the foreward, I asked 
O'Reilly if I could publish it on my blog as well and they said yes. I hope you all check out this
book and share what you've built after!

As a programmer (and a self confessed dweeb) I like to stay up to date on the latest additions 
to various kernels and research in computing. When I first played around with Berkeley Packet 
Filters (BPF) and Express Data Path (XDP) in Linux I was in love. This is such a NICE THING 
and I am glad this book is putting BPF and XDP on the center stage so more people can start 
using it in their projects.

Let me go into detail about my background and why I fell in love with these kernel interfaces... 
I worked as a Docker core maintainer, along with David (one of the brilliant authors of this book). 
Docker, if you are not familiar, shells out to iptables for a lot of the filtering and routing logic for containers. 
The first patch I ever made to Docker was fixing a problem where a version of iptables on CentOS didn’t have the same 
command-line flags so writing to iptables was failing. There were a lot of weird issues like this and anyone 
who has ever shelled out to a tool in their software can likely commiserate. Not only that, having 
thousands of rules on a host is not what iptables was built for and has performance side effects because of it.

Then I heard about BPF and XDP. This was like music to my ears. 
No longer would my scars from iptables bleed with another bug! The kernel community 
is even working on 
[replacing iptables with BPF](https://cilium.io/blog/2018/04/17/why-is-the-kernel-community-replacing-iptables/)! 
Halleluyah! [Cilium](https://cilium.io/), container networking, 
is using BPF and XDP for the internals of their project as well.

But that’s not all! BPF can do so much more than just fulfilling the iptables use case. 
With BPF, you can trace any syscall or kernel function as well as any user-space program. 
[bpftrace](https://github.com/iovisor/bpftrace) gives users dtrace-like abilities in Linux from their command line. 
You can trace all the files that are being opened and the process calling the open, 
count the syscalls by the program calling them, trace the OOM killer, and more… the world is your oyster! 
XDP and BPF are also used in [Cloudflare](https://blog.cloudflare.com/l4drop-xdp-ebpf-based-ddos-mitigations/) and 
[Facebook’s](https://cilium.io/blog/2018/11/20/fb-bpf-firewall/) load balancer to prevent DDoS attacks. I won’t spoil why 
XDP is so great at dropping packets because you will learn about that in the XDP and networking chapters of this book
(*cough* you don't even allocate a kernel struct *cough*)!

Lorenzo, another of the authors, I have had the privilege of knowing each other through the 
Kubernetes community. His tool, [kubectl-trace](https://github.com/iovisor/kubectl-trace), allows users to run their custom tracing programs 
easily inside their kubernetes clusters. 

Personally, my favorite use case for BPF has been writing custom tracers to prove to other 
folks that the performance of their software was not up to par or making really expensive 
amounts of calls to syscalls. Never underestimate the power of proving someone wrong with hard data. 
Don’t fret, this book will walk you through writing your first tracing program so you can do the same ;). 
The beauty of BPF lies in the fact that before now other tools used lossy queues to send sample sets to user
space for aggregation whereas, BPF is great for production since it allows for constructing histograms and filtering
right at the source of events.

I have spent half of my career working on tools for developers. The best tools allow autonomy in their interfaces
for developers like you to use them for things even the authors never imagined. To quote Richard Feynman, 
“I learned very early the difference between knowing the name of something and knowing something.” 
Until now you might have only known the name BPF and that it might be useful to you. What I love about this book is 
that it gives you the knowledge you need to be able to create all new tools using BPF. 

The best books don’t confine readers into a box and that is why I love this one in particular. 
After reading and following the exercises, you will be empowered to use BPF like a super power. 
You can use this in your toolkit to use on demand when it’s most needed and most useful. 
You won’t just learn BPF you will understand it. This book is a path to open your mind 
to the possibilities of what you can build with BPF.

This developing ecosystem is very exciting! I hope it will grow even larger 
as more people start wielding BPF's power. I am excited to learn about what the readers of 
this book end up building, whether it's a script to track down a crazy software bug or a 
custom firewall or even [infrared decoding](https://lwn.net/Articles/759188/)! Be sure to let us all know what you built!
