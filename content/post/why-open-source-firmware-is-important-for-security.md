+++
date = "2019-05-08T8:09:26-07:00"
title = "Why open source firmware is important for security"
author = "Jessica Frazelle"
description = "Why open source firmware is important for security."
+++

I gave a talk recently at GoTo Chicago on [Why open source firmware is important](https://docs.google.com/presentation/d/1Qees556dT9LNoooEdf6En8V82L3V-_N8LbPuyGihZeI/edit?usp=sharing) and I thought it would be nice to also write a blog post with my findings. This post will focus on why open source firmware is important for security.

## Privilege Levels

In your typical “stack” today you have the various levels of privileges.


- **Ring 3 - Userspace:** has the least amount of privileges, short of there being a sandbox in userspace that is restricted further.
- **Rings 1 & 2 - Device Drivers:** drivers for devices, the name pretty much describes itself. 
- **Ring 0 - Kernel:** The operating system kernel, for open source operating systems you get visibility into the code behind this.
- **Ring -1 - Hypervisor:** The virtual machine monitor (VMM) that creates and runs virtual machines. For open source hypervisors like Xen, KVM, bhyve, etc you have visibility into the code behind this.
- **Ring -2 -** **System Management Mode (SMM), UEFI kernel:** Proprietary code, more on this [below](#Ring--2-SMM-UEFI-kernel).
- **Ring -3 - Management Engine:** Proprietary code, more on this [below](#Ring--3-Management-Engine).

From the above, it’s pretty clear that for Rings -1 to 3, we have the option to use open source software and have a large amount of visibility and control over the software we run. For the privilege levels under Ring -1, we have less control but it is getting better with the open source firmware community and projects. 

**It’s counter-intuitive that the code that we have the least visibility into has the most privileges. This is what open source firmware is aiming to fix.**

### Ring -2: SMM, UEFI kernel

This ring controls all CPU resources. 

**System management mode (SMM)** is invisible to the rest of the stack on top of it. It has half a kernel. It was originally used for power management and system hardware control. It holds a lot of the proprietary designed code and is a place for vendors to add new proprietary features. It handles system events like memory or chipset errors as well as a bunch of other logic.

 The **UEFI Kernel** is extremely complex. It has millions of lines of code. UEFI applications are active after boot. It was built with security from obscurity. The [specification](https://uefi.org/specifications) is absolutely insane if you want to dig in.

### Ring -3: Management Engine

This is the most privileged ring. In the case of Intel (x86) this is the Intel Management Engine. It can turn on nodes and re-image disks invisibly. It has a kernel as well that runs [Minix 3](https://itsfoss.com/fact-intel-minix-case/) as well as a web server and entire networking stack. It turns out Minix is the most widely used operating system because of this. There is a lot of functionality in the Management Engine, it would probably take me all day to list it off but there are [many](https://www.intel.com/content/www/us/en/support/articles/000008927/software/chipset-software.html) [resources](https://files.bitkeks.eu/docs/intelme-report.pdf) for digging into more detail, should you want to.

Between Ring -2 and Ring -3 we have at least 2 and a half other kernels in our stack as well as a bunch of proprietary and unnecessary complexity. Each of these kernels have their own networking stacks and web servers. The code can also modify itself and persist across power cycles and re-installs. **We have very little visibility into what the code in these rings is actually doing, which is horrifying considering these rings have the most privileges.**

### They all have exploits

It should be of no surprise to anyone that Rings -2 and -3 have their fair share of vulnerabilities. They are horrifying when they happen though. Just to use one as an example although I will let you find others on your own, [there was a bug in the web server of the Intel Management Engine that was there for seven years](https://www.wired.com/2017/05/hack-brief-intel-fixes-critical-bug-lingered-7-dang-years/) without them realizing.


## How can we make it better?

### NERF: Non-Extensible Reduced Firmware

NERF is what the open source firmware community is working towards. The goals are to make firmware less capable of doing harm and make its actions more visible. They aim to remove all runtime components but currently with the Intel Management Engine, they cannot remove all but they can take away the web server and IP stack. They also remove UEFI IP stack and other drivers, as well as the Intel Management/UEFI self-reflash capability.

### me_cleaner

This is the project used to clean the Intel Management Engine to the smallest necessary capabilities. You can check it out on GitHub: [github.com/corna/me_cleaner](https://github.com/corna/me_cleaner).

### u-boot and coreboot

[u-boot](https://www.chromium.org/developers/u-boot) and [coreboot](https://www.coreboot.org/) are open source firmware. They handle silicon and DRAM initialization. Chromebooks use both, coreboot on x86, and u-boot for the rest. This is one part of how they [verify boot](https://static.googleusercontent.com/media/research.google.com/en//pubs/archive/42038.pdf). 

Coreboot’s design philosophy is to [“do the bare minimum necessary to ensure that hardware is usable and then pass control to a different program called the](https://doc.coreboot.org/) [*payload*](https://doc.coreboot.org/)[.”](https://doc.coreboot.org/) The payload in this case is linuxboot.

### linuxboot

[Linuxboot](https://www.linuxboot.org/) handles device drivers, network stack, and gives the user a multi-user, multi-tasking environment. It is built with Linux so that a single kernel can work for several boards. Linux is already quite vetted and has a lot of eyes on it since it is used quite extensively. Better to use a open kernel with a lot of eyes on it, than the 2½ other kernels that were all different and closed off. This means that we are lessening the attack surface by using less variations of code and we are making an effort to rely on code that is open source. Linux improves boot reliability by replacing lightly-tested firmware drivers with hardened Linux drivers.

By using a kernel we already have tooling around firmware devs can build in tools they already know. When they need to write logic for signature verification, disk decryption, etc it’s in a language that is modern, easily auditable, maintainable, and readable. 

### u-root

[u-root](https://github.com/u-root/u-root) is a set of golang userspace tools and bootloader. It is then used as the initramfs for the Linux kernel from linuxboot.

Through using the NERF stack they saw boot times were 20x faster. But this blog post is on security so let’s get back to that….

The NERF stack helps improve the visibility into a lot of the components that were previously very proprietary. There is still a lot of other firmware on devices. 


## What about all the other firmware?

We need open source firmware for the network interface controller (NIC), solid state drives (SSD), and base management controller (BMC).

For the NIC, there is some work being done in the open compute project on [NIC 3.0](https://www.opencompute.org/documents/ocp-nic-3-0-draft-0v85b-20181213b-tn-temp-no-cb-pdf). It should be interesting to see where that goes.

For the BMC, there is both [OpenBMC](https://github.com/openbmc/openbmc) and [u-bmc](https://github.com/u-root/u-bmc). I had written a little about them in [a previous blog post](https://blog.jessfraz.com/post/the-firmware-rabbit-hole/).

We need to have all open source firmware to have all the visibility into the stack but also to actually verify the state of software on a machine.


## Roots of Trust

The goal of the root of trust should be to verify that the software installed in every component of the hardware is the software that was intended. This way you can know without a doubt and verify if hardware has been hacked. Since we have very little to no visibility into the code running in a lot of places in our hardware it is hard to do this. How do we really know that the firmware in a component is not vulnerable or that is doesn’t have any backdoors? Well we can’t. Not unless it was all open source.

Every cloud and vendor seems to have their own way of doing a root of trust. Microsoft has [Cerberus](https://github.com/opencomputeproject/Project_Olympus/tree/master/Project_Cerberus), Google has [Titan](https://cloud.google.com/blog/products/gcp/titan-in-depth-security-in-plaintext), and Amazon has [Nitro](https://perspectives.mvdirona.com/2019/02/aws-nitro-system/). These seem to assume an explicit amount of trust in the proprietary code (the code we cannot see). This leaves me with not a great feeling. **Wouldn’t it be better to be able to use all open source code? Then we could verify without a doubt that the code you can read and build yourself is the same code running on hardware for all the various places we have firmware. We could then verify that a machine was in a correct state without a doubt of it being vulnerable or with a backdoor.**

It makes me wonder what the smaller cloud providers like DigitalOcean or Packet have for a root of trust. Often times we only hear of these projects from the big three or five. I asked this on twitter and didn't get any good answers...

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">I’m surprised how many people are responding that they love DigitalOcean but seem entirely unconcerned there’s no answer here. You should be concerned.</p>&mdash; jessie frazelle 👩🏼‍🚀 (@jessfraz) <a href="https://twitter.com/jessfraz/status/1126131424095100929?ref_src=twsrc%5Etfw">May 8, 2019</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

There is a great talk by [Paul McMillan](https://twitter.com/PaulM) and Matt
King on [Securing Hardware at Scale](https://www.youtube.com/watch?v=PEVVRkd-wPM). It covers in great detail
how to secure bare metal while also giving customers access to the bare
metal. When they get back the hardware from customers they need to ensure with
consistency and reliability that there is nothing from the customer hiding in
any component of the hardware.

All clouds need to ensure that the
hardware they are running has not been compromised after a customer has run
compute on it.


## Platform Firmware Resiliency

As far as chip vendors go, they seem to have a different offering. Intel has [Platform Firmware Resilience](https://www.intel.com/content/dam/www/public/us/en/documents/solution-briefs/firmware-resilience-blocks-solution-brief.pdf) and Lattice has [Platform Firmware Resiliency](http://www.latticesemi.com/en/Solutions/Solutions/SolutionsDetails02/PFR). These seem to be more focused on the NIST guidelines for [Platform Firmware Resiliency](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-193.pdf).

I tried to ask the internet who was using this and heard very little back, so if you are using Platform Firmware Resiliency can you let me know!

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">It seems that Intel has some effort called Platform Firmware Resiliency (anyone using this one?!) <a href="https://t.co/fQq2gdLNOm">https://t.co/fQq2gdLNOm</a></p>&mdash; jessie frazelle 👩🏼‍🚀 (@jessfraz) <a href="https://twitter.com/jessfraz/status/1126121264819712000?ref_src=twsrc%5Etfw">May 8, 2019</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>


## How to help



I hope this gave you some insight into what’s being built with open source firmware and how making firmware open source is important! If you would like to help with this effort, please help spread the word. Please try and use platforms that value open source firmware components. Chromebooks are a great example of this, as well as [Purism](https://puri.sm/) computers. You can ask your providers what they are doing for open source firmware or ensuring hardware security with roots of trust. Happy nerding! :)



Huge thanks to the open source firmware community for helping me along this
journey! Shout out to Ron Minnich, [Trammel Hudson](https://twitter.com/qrs), [Chris Koch](https://twitter.com/hugelgupf),
[Rick Altherr](https://twitter.com/kc8apf), and 
[Zaolin](https://twitter.com/_zaolin_). And shout out to [Bridget Kromhout](https://twitter.com/bridgetkromhout) for always 
finding time to review my posts!

