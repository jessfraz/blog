+++
date = "2020-05-25T08:09:26-07:00" 
title = "Size Matters" 
author = "Jessica Frazelle" 
description = "What the future of consumer computers should look like." 
+++

My mom has a tendency to buy these really terribly spec'd Windows machines.
She's been doing it for as long as I've been alive. I was surprised when on one
of our latest Zoom calls she said "You know what, I'm beginning to think that
size matters." I've only been telling her this for years! Here's the problem.

There are a bunch of shitty Windows machines you can buy that cost around $400
dollars and have something like 4GB RAM. For consumers, this is really
compelling; the price seems right. The problem is when they start trying to use
the machine to do _anything_, it runs at a snails pace and leaves them with the
world's worst user experience. My mom continually complained about how slow her
computer was and I continually said it's because it's a shit machine and you
have to spend more to actually get good specs.

Apple wouldn't be caught dead selling a machine with 4GB of RAM. They know
better than that and care about the experience the end user has. My sister has
been lucky enough to never have to buy a computer since she continually inherits
my old ones. After my mom had finished saying that "size matters," my sister
noted that my MacBookPro I gave her in 2012 still runs great and is fast. This
is no surprise to me because at the time I bought that computer it was the top
of its line and had 16GB of RAM. Today, that model goes up to 64GB of RAM but
16GB is definitely enough for my sister to run a browser and do what she needs
for work (although Chrome is really pushing the limits these days).

It infuriates me to no end that consumers have an option of even buying a $400
computer that will give them such a terrible experience. The price is great but
the experience is terrible. Even if consumers have a daughter continually
telling them that "size matters," they might still make the very innocent
mistake of buying the machine and realizing later that it is a lemon. It is not
their fault. Manufacturers of computers should be embarrassed for even selling
such a shit machine. I know I would be.

A few articles and papers have surfaced lately on migrating threads and processes
to different kernels. One of these is called popcorn[^1]. Another has been
dubbed teleforking[^2]. I'm not going to get into the details, but in essence, 
what people are trying to do is move
a process from one computer to another. This is great! This could be a huge
problem solver for folks with computers that have terrible specs. It could
also mean a lot for the future of consumer computers.

Imagine a computer where if you were running especially hot and your user
experience had been compromised... the computer realizes this and forks your 
process into a remote data center, 
while maintaining a great user experience locally. It would need to be seamless and
invisible to the end user. If the process is a GUI it would need to still have
the user interface rendering locally while most of the compute is remote. If the
process is a job streaming output into a terminal it is a bit easier. Both
should be possible.

Future computers should not have limited computing power, just limited _local_
computing power. This wouldn't need to just be for your laptops or desktops,
your VR headset or gaming console could fork processes to other available
computers when they needed more computing power. The remote compute would not
always need to be in a data center. An overburdened laptop could fork a process
to your gaming console while you were at work and vice-versa while you were
playing a game.

Compute should be easily shared and readily available. While consumers should
not even have an option of buying a machine with terrible specs that lead to
a terrible user experience, the ability to offload processes to another computer
would allow them to have a great experience even on a lemon. As I see it, this
should be the future of consumer computing. People should be able to create
anything they imagine on a computer that gives them unlimited power to do so. To
quote one of my favorite lines from Halt and Catch Fire: "Computers aren't the
thing. They're the thing that gets us to the thing."

![computers-arent-the-thing](/img/computers-arent-the-thing.gif)

[^1]: https://www.ssrg.ece.vt.edu/theses/MS_Katz.pdf
[^2]: https://thume.ca/2020/04/18/telefork-forking-a-process-onto-a-different-computer/
