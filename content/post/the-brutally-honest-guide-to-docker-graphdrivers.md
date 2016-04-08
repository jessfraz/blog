+++
date = "2016-04-02T11:47:47-07:00"
title = "The Brutally Honest Guide to Docker Graphdrivers"
author = "Jessica Frazelle"
description = "The jessfraz blunt opinion on all things docker graphdriver and storage."
+++

Sup, let me give you fair warning here. Everything contained in this post is
_my_ opinion so don't go getting your panties all in a knot on Hacker News
because you don't agree with me. I could honestly care less, because that's the
thing about _my opinion_, it's mine.

I am going to give you my honest and dare I say it "blunt" opinion about each
of the Docker graphdrivers so you can decide for yourself which one is the best
one for you. None are perfect each has it's flaws and I will be laying those
out. Let's begin.

### Overlay

Overlayfs was added in the 3.17 kernel. This is important to note because if
you are running overlay on an older kernel than 3.17 you are either:

1. Not running the same overlay.
2. Running a kernel with overlayfs backported onto it, which is what we call
   a "frankenkernel". Frankenkernels are not to be trusted. This is not to say
   it _won't_ work, hey it _might_ work great, but it's not to be trusted.

Overlay is great but you need a recent kernel. There are also some super
obscure kernel bugs with regard to sockets or certain python packages
[docker/docker#12080](https://github.com/docker/docker/issues/12080). But
I will say personally I use overlay, I have not hit these bugs recently and
I have all my [100+ dockerfiles](https://github.com/jfrazelle/dockerfiles)
running as continuous builds on my server with overlay and they all work.

### Aufs

Aufs is another great one. But it is not in the kernel by default which blows.
On Ubuntu/Debian distros this is as easy as installing the kernel extras
package but other distros it might not be as simple.

### Btrfs

Btrfs is great too but you need to partition the disk you will use for
`/var/lib/docker` as btrfs first. This is kinda a hurdle to jump that I don't
think a lot of people are willing to do.

### Zfs

Zfs is another good one, of course, like btrfs it takes some setup and installing
the `zfs.ko` on your system. But this driver might become a whole lot more
popular if Ubuntu 16.10 ships with zfs support.

### Devicemapper

Honestly it makes me super disappointed to say this, but buyer beware. Hey
on the plus side.... it's in the kernel. You must must must have all the
[devicemapper options](https://github.com/docker/docker/blob/master/daemon/graphdriver/devmapper/README.md)
set up perfectly or you will find yourself only being able to launch ~2
containers.

Let me tell you a story.

My mom once asked her friend for her famous chicken enchilada recipe so she
could make it herself. The friend gave the recipe but left out one key
ingredient so that my mom's never tasted just right. There was always something
off about it.

This is how I think of devicemapper.

It works great on RedHat.

### Vfs

I sure hope to hell you are just testing something or clinically insane.


That's about all. Thanks for reading my opinion if you even made it this far.
