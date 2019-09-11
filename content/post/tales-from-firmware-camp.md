+++
date = "2016-09-10T08:09:26-07:00"
title = "Tales from Firmware Camp"
author = "Jessica Frazelle"
description = "Tales and adventures from firmware camp."
+++

Last week I attended the [Open Source Firmware Conference](https://osfc.io/). 
It was amazing! 
The talks, people, and overall feel of the conference really left me feeling
inspired and lucky to attend.

Having been pushed to attend vendor conferences and trade shows through my
career for various jobs, it was so refreshing to have the chance to hang out
with folks from such a genuine community that really just want to help one
another. 

When the talks hit YouTube you should be sure to check them
out ([I also](https://twitter.com/jessfraz/status/1169361763680210944) 
[tweeted](https://twitter.com/jessfraz/status/1168925785211772929) 
[about](https://twitter.com/jessfraz/status/1168934537415593987) 
[a few](https://twitter.com/jessfraz/status/1168958435288915970) 
[of them](https://twitter.com/jessfraz/status/1169030969535488002)). What 
I will focus on in this post was the last two days of the conference that were
devoted to the hackathon.

I had bought a [X10SLM-F Supermicro board](https://www.supermicro.com/en/products/motherboard/X10SLM-F)
off of eBay a few months ago that I wanted to run CoreBoot on. If you are
interested in finding a board that will work with CoreBoot, you should check
it's [status on the status page](https://coreboot.org/status/board-status.html). 
I had
been talking to [Zaolin](https://twitter.com/_zaolin_) about wanting a board 
to hack on and he recommended this one.

At the hackathon, we decided to start with the BMC instead of the CPU BIOS. 
This made for some
fun problems and definitely a lot of lessons learned. I had a 
[Dediprog SF100](https://www.dediprog.com/product/SF100) flash programmer I brought to the
hackathon as well. Some people use RaspberryPis as their flash programmer but
the Dediprog was recommended to me and definitely came in handy. However, if
you want a cheaper alternative there are a bunch of ways you can skin that cat.

To get started, we read the original binary off the SPI flash... this worked fairly
simply. We used the opensource [`dpcmd`](https://github.com/DediProgSW/SF100Linux) tool
from dediprog to do it. But you could also use [`flashrom`](https://github.com/flashrom/flashrom).

While inspecting the original binary, we found the string `linux` a few
times... as well as a MAC adress, boot commands, IP address, and some other
interesting strings.

Before flashing on new firmware we also made sure the board actually booted the 
BMC. We didn't have access to any console so we made due with an IPMI LAN port
and dnsmasq to work with DHCP. It worked and we got into the BMC user interface
over the web. If you've ever used a Supermicro server I probably don't need to
tell you that it's a piece of shit running a 2.6 linux kernel on the BMC.
Getting to the UI proved the board actually booted with the original BMC firmware
so we began to break it by trying to run [OpenBMC](https://github.com/openbmc/openbmc).

Our board has a ASPEED 2400 BMC. We chose a OpenBMC configuration that would
give us a kernel supporting that chip. Thanks [Joel Stanley](https://github.com/shenki) for all your work on the kernel patches for all the BMCs. We flashed the SPI flash with our new BMC firmware image and attempted to power on the board.

I am going to interupt the story here for a second to explain the pain
involved with this developement cycle of writing to firmware to SPI flash.
The SPI flash is 16MB _but_ requires erasing the 
previous contents (4KB per sector) before you can even write. 
A delete cycle of a sector is
120ms per sector at the worst. So that's definitely not ideal and anything you can do to
make this faster is very much so ideal. Most flash programmers will not rewrite
a sector if it's contents have not changed which helps, but still super
painful coming from the workflow of a software developer.

Back to our board... our OpenBMC image we flashed didn't work. Again, a lot of this would have been easier to debug with
a serial console but we didn't have one and we didn't have the spec to get a UART. 
Our assumption from this failure was that the IPMI LAN port we
were using was not the same port configured for that specific
configuration.

So we went to build a custom kernel...

With the help of Joel we built a custom kernel completely separate from OpenBMC, 
however we flashed the kernel directly to the SPI
flash without even u-boot, LOL... obviously this didn't work.

Then we decided to try something easier and had a hunch a different
configuration in the OpenBMC project would have the right port enabled. We built
the image for that and flashed it onto the SPI flash. This was arguably faster
than making our own OpenBMC configuration with our new kernel.

It also didn't work, but here we got into a bit more trouble. After this point we
could no longer write to the SPI flash. The problem was the BMC was interfacing
with the SPI flash and we couldn't take over the ability to write to it. The
SPI flash only allows one device to interact with it at a time. We also could
not flash the SPI flash without the board powered on because the entire board 
was pulling power which was too much for our flash programmer to handle. _This_
is a huge pain in the ass. It turns out it is _such a pain in the ass_ that people
have made solutions for it.

Fortunately for us, [Felix Held](https://github.com/felixheld) had just
given a talk on this pain the day before and he was also in the room. He had one
more prototype of his tool, [qspimux](https://github.com/felixheld/qspimux), 
and we got to use it on our board.

Qspimux allows for the access to a real SPI flash chip to be multiplexed 
between the target and a programmer that also controls the multiplexer. This
way we could flash the SPI flash with the board's power off. 

To get his tool installed we had to de-solder the SPI flash and
solder it back on after getting the qspimux parts attached. Props to [Edwin
Peer](https://github.com/edwin-peer) for his awesome soldering skills here.
Here is a live action shot...

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">It&#39;s been a journey, desoldered the flash for the BMC now using Felix Held&#39;s qspimux... so the BMC doesn&#39;t interfere with the flash, so we can actually flash it! <a href="https://t.co/M2mezEMeLa">https://t.co/M2mezEMeLa</a> <a href="https://t.co/iL1xBQzAwh">pic.twitter.com/iL1xBQzAwh</a></p>&mdash; jessie frazelle 👩🏼‍🚀 (@jessfraz) <a href="https://twitter.com/jessfraz/status/1170074325895925760?ref_src=twsrc%5Etfw">September 6, 2019</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

After finishing this, we could write to the SPI flash again. At this point we
were trying to re-flash the original Supermicro flash onto the board, just to
make sure we didn't mess anything up along the way. This
proved to be more difficult than we thought. We got the firmware to write to
the flash but the board still wasn't working. We verified with the oscilliscope
that data was indeed leaving the MOSI (master-out-slave-in) pin and the clock 
was working on the flash.

Then I tried to read the firmware back from the SPI flash chip to make sure it was
indeed our original flash. We suspected that maybe we were writing to the
device too quickly. This was indeed the case. The two firmware images did not
match. I then wrote the firmware to the SPI flash on the slowest setting just
to be sure. Then I could actually verify the image we wrote and the image we
read back matched our original firmware image. At this point everything was
kosher and we knew the image on the SPI flash chip was indeed the same as the
original we pulled off the board the day before.

At this point the board was still not booting the original firmware image. This
is when we had to go home and firmware camp was over. Overall, this was a great
learning experience. I would have been sad had everything gone smoothly because
we would not have learned as much about how to debug all the components of the
SPI flash and board. I definitely have not given up on this board and will
continue down this rabbit hole until it has open source firmware on the BMC and
open source BIOS for the CPU.

I would like to thank everyone at the Open Source Firmware Conference for
making this a truly amazing week and specifically those who helped with the
crazy hackathon project: [Rick Altherr](https://github.com/kc8apf), 
[Edwin Peer](https://github.com/edwin-peer), 
[Joel Stanley](https://github.com/shenki),
[Felix Held](https://github.com/felixheld/), 
[Bryan Cantrill](https://github.com/bcantrill),
Jacob Yundt (who I can't seem to find online), 
[Joshua M. Clulow](https://github.com/jclulow), and everyone else I am 
forgetting who gave us wires, clips, cords, and whatever else we 
needed to get this thing going! 

I cannot wait for the next OSFC, but until then I will work on playing with
a logic analyzer to see if what the BMC is reading from the SPI flash is even
the right data ;)
