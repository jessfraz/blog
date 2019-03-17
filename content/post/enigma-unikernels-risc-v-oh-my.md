+++
date = "2019-03-17T11:25:24-04:00"
title = "An Enigma, unikernels booting on RISC-V, a rack encased in liquid. OH MY."
author = "Jessica Frazelle"
description = "An overview of things I have learned at QCon, a trip to the University of Cambridge, and Open Compute Summit."
+++

I have written a bit about how I am spending my time while being unemployed and
I thought I would continue.

There was one thing I had left out of my [previous post on my visit to the Pentagon](https://blog.jessfraz.com/post/government-medicine-capitalism/).
THEY HAVE A REAL ENIGMA MACHINE THERE. Okay, moving on...

## QCon and University of Cambridge

I gave a talk at QCon on SGX and ended up giving the same talk to some really
awesome folks at University of Cambridge. Each time I gave the talk provoked
some really interesting conversations. One of the topics that came up a couple of
times was if RISC-V was going to be supported by any major cloud provider anytime soon. 
My honest opinion, which some might disagree with, is this is years away BUT it would certainly help adoption and integration into projects if it was backed by a company with a lot of time to develop integrations. Also I got a bit nerd sniped by some ARM folks and researchers to look more into TrustZone (which is the ARM secure enclave). I haven’t dug in yet but it’s on my list. 

It was awesome spending a day in Cambridge (thanks [Anil](https://twitter.com/avsm) for the tour!) and learning about all the awesome things they are doing. The MirageOS team is booting unikernels on baremetal RISC-V! 


<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">🎉OCaml boots on bare-metal <a href="https://twitter.com/ShaktiProcessor?ref_src=twsrc%5Etfw">@ShaktiProcessor</a> <a href="https://twitter.com/risc_v?ref_src=twsrc%5Etfw">@risc_v</a>! 🎉 An important milestone towards building safer apps using <a href="https://twitter.com/OpenMirage?ref_src=twsrc%5Etfw">@OpenMirage</a> on open source hardware. <a href="https://t.co/XFosAxPROR">pic.twitter.com/XFosAxPROR</a></p>&mdash; KC Sivaramakrishnan (@kc_srk) <a href="https://twitter.com/kc_srk/status/1101479406084583424?ref_src=twsrc%5Etfw">March 1, 2019</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>


They use this on boards to power light bulbs (at the University!) super securely since it removes the need for all the shitty firmware most other things ship and has a super minimal environment. I’m sure you can think of a number of different other use cases as well. Honestly, unikernels replacing all the crap firmware in the world would be a huge win.

## Open Compute Summit

Just this past week I spent a day at the Open Compute Summit. What is happening there in the open firmware space is truly awesome. They had demos of hardware they are booting with LinuxBoot and Coreboot. Facebook runs this on their infrastructure as well as with OpenBMC to replace the traditional, proprietary BMC firmware. Trammel Hudson has some [great posts](https://trmm.net/LinuxBoot_34c3) on LinuxBoot, which include links to some really great talks by him and Ron Minnich.

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">😍 the open systems firmware community is awesome <a href="https://t.co/DAqudm6M4Z">pic.twitter.com/DAqudm6M4Z</a></p>&mdash; jessie frazelle 👩🏼‍🚀 (@jessfraz) <a href="https://twitter.com/jessfraz/status/1106301027408465920?ref_src=twsrc%5Etfw">March 14, 2019</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>


Facebook’s server racks are gorgeous. They have a power bus which runs down the center and everything gets power from that, with the main power coming out of the power unit towards the middle of the rack (in the first picture below).

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">The Facebook rack and node designs are seriously gorgeous, simple. The power bar *chef kiss* <a href="https://t.co/pGphy9uLLl">pic.twitter.com/pGphy9uLLl</a></p>&mdash; jessie frazelle 👩🏼‍🚀 (@jessfraz) <a href="https://twitter.com/jessfraz/status/1106336080956018689?ref_src=twsrc%5Etfw">March 14, 2019</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>


### Boot Guard

One thing I learned that I found fascinating was about Boot Guard for Intel processors and the equivalents on ARM and AMD. Boot Guard is supposed to verify the firmware signatures for the processor. The problem with this, in Intel’s case, is only Intel has the keys for signing firmware packages. This makes it impossible for you to then use Coreboot and LinuxBoot or equivalents as firmware on those processors. If you tried, the firmware would not be signed with Intel’s key and would brick the board. Matthew Garrett wrote [a great post](https://mjg59.dreamwidth.org/33981.html) about this as well. 

If a person owns the hardware, they have a right to own the firmware as well. Boot Guard prevents this. In [another great talk](https://trmm.net/OSFC_2018_Security_keynote#Boot_Guard) by Trammel, he found a vulnerability to [bypass BootGuard](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2018-12169). 

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">CVE-2018-12169 also potentially allows a developer to &quot;jailbreak&quot; their BootGuard protected laptop since the UEFI DXE volume can be replaced with a user provided LinuxBoot ROM image. <a href="https://t.co/yHwwMOTyx7">https://t.co/yHwwMOTyx7</a> <a href="https://t.co/MeWI0DGUBf">pic.twitter.com/MeWI0DGUBf</a></p>&mdash; Trammell Hudson ⚙ (@qrs) <a href="https://twitter.com/qrs/status/1044157473882591233?ref_src=twsrc%5Etfw">September 24, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>



### Server rack encased in liquid

Lastly, I saw something bat shit crazy at Open Compute Summit. It was
something I saw in the Expo Hall. One vendor has encased an entire server rack
in liquid for liquid cooling. I'm not sure I could sleep at night using this.
The funniest part about this though was the demo at their booth still had fans
in the rack! I mean... why would you need fans if you had liquid cooling...
they claimed was because it was just "left over" and you wouldn't need that.
But at a conference where everyone is showing off their custom hardware, you'd
think they would have left the fans at home ;).


That's the end of this update of my adventures. Hope you all enjoyed it. I know
I enjoyed living it!
