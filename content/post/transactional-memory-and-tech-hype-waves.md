+++
date = "2019-08-14T8:09:26-07:00"
title = "Transactional Memory and Tech Hype Waves"
author = "Jessica Frazelle"
description = "The culture of tech hype waves through the example of transactional memory."
+++

At lunch today I learned about Transactional Synchronization Extensions (TSX) 
which is an implementation of transactional memory. The conversation started as a rant
about why transactional memory is bad but then it evolved into how this concept
even came to be and how it even got implemented if it's such a terrible idea.

## What is transactional memory?

First let's start by going over what transactional memory is.

You might be familiar with a deadlock. A deadlock occurs when a process or thread is waiting
for a specific resource, which is also waiting on a different resource that is
being held by another waiting process. You can think of this as P1 needs R1
and has R2, while in turn P2 needs R2 and has R1. That is a deadlock. 

Transactional memory removes the possibility of getting a deadlock and replaces
it with what is known as a livelock. A livelock happens when processes are constantly
changing with regard to one another but neither of them move forward or
progress in anyway. Imagine you are walking down the street while another
person is heading towards you. You move to the right to avoid running into them
as they also move in that direction to avoid running into you. You both then
move to the other side so as to not run into each other. This repeats over and
over again with no progress forward since both people are moving in the
same direction. That is a livelock. With transactional memory you no longer
have deadlocks but livelocks.

Why is this? Well, transactional memory works very similarly to database
transactions. A transaction is a group of operations that can execute and
commit changes as long as there are no conflicts. If there is a conflict, it
will start from state zero and try to run again until there are no conflicts.
Therefore, until there is a successful commit of a run, the outcome of any
operation is speculative.

Intel's implementation of TSX behaves in such a way that when a transaction
aborts due to a hardware exception, it
does not fire typical exceptions. Instead, it invokes a user-specified abort handler
without informing the underlying OS.  This seems like it might lead to some
really bad behavior... we should probably know wtf is going on
in our system at any given point in time.

## Side-Channel Attacks

So we know the outcome of any operation in a trasaction is speculative.
Hmmm speculative you say... I am reminded of spectre and meltdown.
The solution in the kernel for defending against spectre and meltdown
was Kernel Page Table Isolation (KPTI). Instead let's focus on what you can break with Spectre and meltdown which is Kernel Address Space Layout Randomization (KASLR). KASLR randomizes
the address layout per each boot. This raises the bar for an exploit  forcing
an attacker to guess where the code and data are located in the address space.
The probability of an attack then becomes the probability of an information
leak multiplied by the probibility of a memory curruption vulnerability.

However, this can be exploited without an information leak but instead using 
a translation lookaside buffer (TLB)  and a timing attack. A TLB 
is a memory cache that reduces the time taken to access a user memory location.
It keeps recent translations of virtual memory to physical memory.

In the [DrK paper](https://gts3.org/assets/papers/2016/jang:drk-ccs.pdf), the
authors describe an attack that uses the behavior of TSX as a _feature_ of the
exploit. As described above, TSX has the behavior of aborting a commit without leaving any trace as
to why it was aborted. So in DrK, the
authors use TSX to create a bunch of access violations of the privileged
address space inside transactions and turn that into knowledge of mapping and executable status
of the address space
_without_ even generating a page fault.

The point I am making with this example is that transactional memory and it's
implementation TSX are a bad idea.

But who could have possibly seen this as a bad idea?

## Rewind to 2008

Concurrency is the biggest hype in town. This comes from a lot of different
things but can be found in an article, [Technical perspective: Transactions are
tomorrow's loads and stores](https://dl.acm.org/citation.cfm?id=1378724),
in Communications of the ACM (CACM). It seems at the time, this craze was
started out of academia. Some practitioners, Bryan Cantrill and Jeff
Bonwick, wrote rebuttles in the name of "please dear god do not make
transactional memory A Thing".
That can be seen in Bryan's blog post,
[Concurrency’s Shysters](http://dtrace.org/blogs/bmc/2008/11/03/concurrencys-shysters/),
and the follow-up ACM Queue article, [Real-world Concurrency](https://queue.acm.org/detail.cfm?id=1454462).

Clearly,  in 2008 there was a division between academia and
practitioners.



## Fastforward to 2012

Intel shipped TSX in [February 2012](https://software.intel.com/en-us/blogs/2012/02/07/transactional-synchronization-in-haswell).

**EDIT:** It was pointed out that [Azul shipped transactional memory in 2006](https://hydraconf.com/2019/talks/2jix5mst7iduyp9linqhfj/). Thanks [@davidcrawshaw](https://twitter.com/davidcrawshaw/status/1161827880608735232)!

## Why is this interesting?

Hype cycles come and go and if you spend anytime in our industry you tend to
become pretty numb to them. Seeing through the hype has always been a joy of
mine and I find it interesting the vectors through which hype travels have
changed drastically over time.

With transactional memory, the hype began in academia through academic
conferences and articles in journals. Before the 2000s even, hype might have
spread through magazines like Byte. Today, we have multiple channels for hype
through social networks: Twitter, Reddit, blogging, YouTube, GitHub,
Hacker News (slashdot before
that), and others.

Hype seems to travel through the unconscious need of people to connect to
others. Being a part of movements, like open source projects and a shared sense
of need, allows people to be a part of something bigger than just themselves.

Twitter is fascinating due to the way it hosts so many subcultures. One of my
favorite examples of this is Canadian twitter where everyone is polite and nice
to each other. There are also vehemet subcultures around the latest technology
trends. The way technology can spread has turned from a place where very few
people have a voice (through getting papers accepted at conferences and in
journals) to social networks where everyone has a voice. My hope is that the
loudest of the voices are the ones used to build technology for the best
causes.

I'll leave you with that, hope you enjoyed and learned something fom
my rather weird example of a technology hype wave.
