+++
date = "2019-02-12T18:09:26-07:00"
title = "The Firmware and Hardware Rabbit Hole"
author = "Jessica Frazelle"
description = "An overview of some firmware and hardware things I read about while on vacation."
+++

I started dipping into some firmware and hardware things on my vacation and unemployment and I figured I would take you down my journey as well.

## Baseboard management controller

The first thing I dipped into was [openbmc](https://github.com/openbmc/openbmc). This is pretty cool. At face value it has support for a lot of different boards. It uses IMPI (Intelligent Platform Management Interface) to perform tasks for monitoring and operating the components of a computer. The IMPI interface has been around for a super long time. [RedFish](https://www.dmtf.org/standards/redfish) is kind of the successor. It’s an HTTP API and is more modern as a thoughtful approach to hardware deployment in a datacenter. The standard doesn’t include every sensor that IMPI has but it does allow for someone to add more sensors types to their implementation.

So I dug into the openbmc project a bit and tried to lick my wounds of dbus, seeing that was what it was using. I thought hmmm I wonder if there are more projects like this...

It turns out there are! [u-bmc](https://github.com/u-root/u-bmc) from the same folks that made [u-root](https://github.com/u-root/u-root) seemed like a more simple, opinionated solution. However, it only has the support of one board currently, although others seem planned. I thought it was an kinda neat and interesting detail that u-bmc used gRPC instead of IMPI, seems like a cool choice to modernize but I had some naive questions so I headed to the internet for answers.

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Anyone know what the memory overhead for using gRPC for this is... I would think it’s not insignificant, or you’d want to use one of the “tiny grpc” replacements, or maybe something that didn’t reinvent its own HTTP server perhaps...? <a href="https://t.co/gIpW97r7Xw">https://t.co/gIpW97r7Xw</a></p>&mdash; jessie frazelle 👩🏼‍🚀 (@jessfraz) <a href="https://twitter.com/jessfraz/status/1092588927318249472?ref_src=twsrc%5Etfw">February 5, 2019</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script> 

That thread is awesome. Thanks to some super awesome and smart friends from the internet I learned a lot more about these two projects. I will let you read the thread and form opinions of your own but there’s a lot of experience and knowledge in there.

Currently, I’m feeling a bit nerd sniped by the idea of a BMC implemented in Rust to solve some of the problems mentioned in the thread. A girl can dream right? :)

That was a bit of a rabbit hole so I decided to move on, mostly because of ADHD and my ever growing curiosity about all things computers.

## Intel Management Engine

I started looking into the Intel Management System... boy does that do a lot of stuff.

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">[enters weird rabbit hole]<br>“wow there’s a lot of tunnels in here” <a href="https://t.co/oHslyJ0TuF">pic.twitter.com/oHslyJ0TuF</a></p>&mdash; jessie frazelle 👩🏼‍🚀 (@jessfraz) <a href="https://twitter.com/jessfraz/status/1092627483537551360?ref_src=twsrc%5Etfw">February 5, 2019</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script> 

The craziest part that I found were all the security vulnerabilities and theories of [backdoors](https://news.softpedia.com/news/intel-x86-cpus-come-with-a-secret-backdoor-that-nobody-can-touch-or-disable-505347.shtml). I live for researching things like this so I was intrigued. Intel gave people a way to disable the ME, and vendors have, as well as [Dell even selling computers to government contracts with it disabled](https://www.heise.de/newsticker/meldung/Dell-schaltet-Intel-Management-Engine-in-Spezial-Notebooks-ab-3909860.html). I stumbled across this super dope laptop company, [Purism](https://puri.sm/), that sells laptops using [coreboot](https://www.coreboot.org/) with the ME memory erased. Their approach and blog is super neat and interesting. Also coreboot looks just lovely, I need to play around with it more.

## Intermission

So in between bouncing back and forth reading about various forms of firmware and how shitty and sketchy closed source firmware is, I read the book Bad Blood. The book details the absolute cluster-fuck that was the startup Theranos, so everything from here on out is with “paranoid as fuck” goggles on because I was shook. 

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Reading Bad Blood <a href="https://t.co/C1SN7CF91B">pic.twitter.com/C1SN7CF91B</a></p>&mdash; jessie frazelle 👩🏼‍🚀 (@jessfraz) <a href="https://twitter.com/jessfraz/status/1090912858597150720?ref_src=twsrc%5Etfw">January 31, 2019</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script> 


Keep that in mind as we head into the next section.

## SGX

Intel’s SGX (Software Guard Extension) is just utterly bananas. I went down this tunnel next. Oh it’s a doosey of a tunnel let me tell you.

In short, SGX provides what is known as a Secure Enclave. You can put keys in here for safe keeping because the memory is isolated and encrypted from everything else in the computer. (Or so they say, but we will get to that.) This creates a way to store data that you don’t want the host computer user to know about. Some cloud providers are using SGX as a way for customers to use the cloud without trusting the cloud provider, only trusting the hardware provider, in this case Intel.

### Existing Knowledge 

I had done a [Papers We Love talk](https://paperswelove.org/2017/video/jessie-frazelle-scone-secure-linux-containers-with-intel-sgx/) on the [SCONE paper](https://www.usenix.org/system/files/conference/osdi16/osdi16-arnautov.pdf) over a year ago. This paper was an experiment in running docker containers in an enclave. You can watch the talk, but the short version is I wasn’t really sold. While being a technological feat, it was slow and it required a bunch of code. Basically you need to reinvent all of computing inside the enclave (the HAVEN paper approach put bluntly). Or if you do what they did in the SCONE paper, run syscalls outside the enclave. If you toss syscalls outside the enclave, you need to deal with encrypting all of I/O and a bunch of other surface area since you are now running both inside and outside the enclave. In that case, your boundary is more like a blurred line. 

My opinion, which I’m sure the readers on Hacker News will call me all sorts of names for, I question what is the point if you need to trust so much base code just to run a damn thing in the enclave and when you run your process it’s slow. AND it won’t even protect you from side channel attacks or timing attacks.

Anyways, that was my background knowledge going into this rabbit hole once again. But there I was going back for round two thinking I wonder wtf is up in the SGX world.... TURNS OUT A LOT.

### Round Two

Thanks to the awesome internet I stumbled upon a 118 page run down of the technology.

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Here for this shade, thanks <a href="https://twitter.com/_msw_?ref_src=twsrc%5Etfw">@_msw_</a> for the link <a href="https://t.co/WJtgf9vZBc">https://t.co/WJtgf9vZBc</a> <a href="https://t.co/DaoZQunloJ">pic.twitter.com/DaoZQunloJ</a></p>&mdash; jessie frazelle 👩🏼‍🚀 (@jessfraz) <a href="https://twitter.com/jessfraz/status/1093735827719434240?ref_src=twsrc%5Etfw">February 8, 2019</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script> 

This is a great paper, if you really want to learn about the internals of not only SGX but computer architecture as well, I strongly suggest reading it. It’s wonderfully written and very detail oriented.

The paper is on the second generation of the technology and outlines the side-channel attacks making the hardware insecure. The interesting thing I took away from the paper, other than a fuck ton of nuance, was the licensing of SGX. 

### Launch Control

SGX has this feature called “launch control”. Launch control is the gatekeeper for launching enclaves it requires an Intel license and provides launch tokens for launching other enclaves. You use what’s called a “launch enclave” to create a “launch token”. Anyways, it wasn’t really documented at the v2 time, and the paper makes interesting insights about it. While SGX from the outside is a feature to secure computing, it also has this hidden feature of securing the market for Intel perhaps?

Well Intel responded and made “[Flexible Launch Control](https://github.com/intel/linux-sgx/blob/master/psw/ae/ref_le/ref_le.md).” This allows a different party, other than Intel, to handle the launch control process. That’s nice, seems like a shit ton of work though and sadly, making the UX better around this got me thinking. Cloud providers couldn’t do launch control for people since that then defeats the purpose of only trusting the hardware vendor and not the cloud. So this is up to the customer and in my opinion it seems like a lot to land on them.

Okay so I was basically over launch control at this point and ready to go deeper. Thanks twitter for all the paper links :)

### Attacks

[Foreshadow](https://www.usenix.org/system/files/conference/usenixsecurity18/sec18-van_bulck.pdf) is fucking nuts. It uses the same type of attack as Meltdown but the fixes for Meltdown didn’t prevent the attack since KPTI (kernel page table isolation) doesn’t cover the enclave address space. In the paper they steal secrets from inside an enclave, which honestly would be the end game of a lot of hackers. The authors take it further by getting the private keys for the enclave and creating fake enclaves that appear perfectly fine and attestations. Wow!

But that’s not all. [Foreshadow-NG](https://foreshadowattack.eu/foreshadow-NG.pdf) took it a step further, from the paper:

> At a high level, whereas previous generation Meltdown-type attacks are limited to reading privileged supervisor data within the attacker’s virtual address space, Foreshadow-NG attacks completely bypass the virtual memory abstraction by directly exposing cached physical memory contents to unprivileged applications and guest virtual machines.  

With Foreshadow-NG, the hacker can access all cached memory, not just their own virtual memory. Bananas... right. But there’s more...

Do you need a new feature set for your malware? Because you can [use SGX to conceal cache attacks](https://arxiv.org/abs/1702.08719) and [amplify them](https://arxiv.org/abs/1703.06986)!!!

Here’s a quote from the second paper linked above:

> Our attack tool named CacheZoom is able to virtually track all memory accesses of SGX enclaves with high spatial and temporal precision.   

If enclave malware interests you, there’s another paper that just went out [detailing that](https://arxiv.org/abs/1902.03256) yesterday.

I am forgetting a bunch of other details and papers but this should paint a pretty good picture of the state of the SGX world.

## Thank You

Thank you to everyone for linking me to awesome papers and engaging in my nerdery with these things. I’m not done at all with this rabbit hole but I thought I’d sum it up for now.

Shout out to [@_msw_](https://twitter.com/_msw_), [@anliguori](https://twitter.com/anliguori), [@iancoldwater](https://twitter.com/iancoldwater), [@hugelgupf](https://twitter.com/hugelgupf), [@bascule](https://twitter.com/bascule), [@kc8apf](https://twitter.com/kc8apf), [@nasamuffin](https://twitter.com/nasamuffin), and everyone else I apologize if I forgot. 

