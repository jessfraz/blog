+++
date = "2019-03-24T08:09:26-07:00"
title = "Digging into RISC-V and how I learn new things"
author = "Jessica Frazelle"
description = "A post about how I learn new things using RISC-V as an example."
+++

I recently have started researching and playing around with RISC-V for fun. I thought it might be nice to combine some of what I’ve learned into a blog post. However, I don’t just want to highlight *what* I learned. I want to use this as an example of how to go about learning something new.

Recently, [Erik St. Martin](https://twitter.com/erikstmartin), [Shubheksha Jalan](https://twitter.com/ScribblingOn), and I were discussing how we learn new things and we all thought it might be beneficial to have a way to document this process for others. What better way to document this then by example with my recent research into RISC-V?

I’ve [said it before](https://blog.jessfraz.com/post/defining-a-distinguished-engineer/) and I will say it again, I think anyone is capable of doing or learning anything, they just need the right motivation and to believe in themselves. I also made a point of including the book [Super Brain](https://www.amazon.com/Super-Brain-Unleashing-Explosive-Well-Being/dp/0307956830) on [my list of recommended books](https://blog.jessfraz.com/post/books/), because it confirms with science that if you set your sights high you can accomplish great things, but if you set your expectations low it becomes a self-fulfilling prophecy. To put it more bluntly, believe in yourself!

I became fascinated by what is happening in the RISC-V space just by seeing it pop up every now and then in my Twitter feed. Since I am currently unemployed I have a lot of time and autonomy to dig into whatever I wish.

RISC-V is a new instruction set architecture. To understand RISC-V, we must first dig into what an instruction set architecture is. This is my learning technique. I bounce from one thing to another, recursively digging deeper as I learn more.


## What is an instruction set architecture (ISA)?

An instruction set architecture is the interface between the hardware and the software. 

Models of processors can implement the same instruction set but have different *internal* designs for implementing the interface. This leads to various processors having the same instruction set but differing in performance, physical size, and monetary cost. For example, Intel and AMD have processors that both implement the same x86 instruction set but have very different internal designs.

In order to dig deeper, we should look into what some of the various types of instruction set architectures are.


## What are the types of instruction set architectures?

Most commonly these are described and classified by their complexity.

### Reduced Instruction Set Computer (RISC)

This only implements frequently used instructions, less common operations are implemented as subroutines. By using subroutines, there is a trade-off of performance, however it’s only applied to the least common operations.

RISC uses a load/store architecture; meaning it divides instructions into ones that access memory and  ones that perform arithmetic logic unit (ALU) operations.

RISC, the name, came out of Berkeley in the 1980s (from a project led by David Patterson) around the same time MIPS (a project led by John L. Hennessy) was going on at Stanford. RISC became commercialized as SPARC by Sun Microsystems and MIPS became commercialized by MIPS Computer Systems. Both are RISC architectures. You might also be familiar with more modern implementations like ARM or PowerPC which are commercialized as well. There are many RISC implementations other than just these, I implore you all to dig further if you so choose.

RISC architectures can also be traced back to before the name existed as well. Examples include Alan Turing's Automatic Computing Engine (ACE) from 1946 and the CDC 6600 designed by Seymour Cray in 1964.

### Complex Instruction Set Computer (CISC)

This has many very specific, specialized instructions, some may never be used in most programs. In CISC, one instruction can denote an execution of several low-level operations or one instruction is capable of multi-step operations and/or addressing modes.

The term was coined after RISC, so everything that is not RISC tends to get lumped here. It’s become somewhat of a contentious point since some modern CISC designs are in fact less complex than some RISC designs. The main difference is that CISC architectures have arithmetic/computation instructions also perform memory accesses.

Most architectures were classified after the fact since the term wasn’t around at the time of their birth. Some examples include IBM’s System/360 and System Z, the PDP-11, the VAX architecture, and Data General’s Nova. 

### Very Long Instruction Word (VLIW) and Explicitly Parallel Instruction Computing (EPIC)

These were designed to exploit instruction level parallelism, executing multiple instructions in parallel. This requires less hardware than CISC or RISC and leaves the complexity for the compiler.

Traditionally, processors use a few different ways to improve performance, let’s dig into these.


- **Pipelining** divides instructions into substeps so the instructions can be executed partly at the same time.
- **Superscalar architectures** dispatch individual instructions to be executed independently in different parts of the processor.
- **Out-of-order execution** executes instructions in an order different from the program.

The methods above all complicate hardware by requiring the hardware to perform all this logic. In contrast, VLIW leaves this complexity to the program. As a trade-off the compiler becomes a lot more complex while the hardware is simplified and still performs well computationally.

VLIW is most commonly found in embedded media processors and graphics processing units (GPU). However, Nvidia and AMD have moved to RISC architectures to improve performance for non-graphics workloads. You can also find VLIW in system-on-a-chip (SoC) designs where customizing a processor for an application is popular.

EPIC architecture was based on VLIW but made a few changes. One of which allows for groups of instructions, called bundles, to be executed in parallel if they do not depend on any subsequent group of instructions. You can often distinguish EPIC from VLIW because of EPICs focus on full instruction predication. This is used to decrease the occurrence of branches and to increase the speculative execution of instructions. Speculative execution loads data before we know whether or not it will be used.

You might be familiar with speculative execution from the Spectre and Meltdown attacks. The Spectre and Meltdown attacks are a whole different rabbit hole I won’t go down in this post, but I hope you can understand how your own learning is almost like a choose your own adventure game. You can choose to go further down any path at any time.

### Minimal Instruction Set Computer (MISC)

This is more minimal than RISC. It includes a very small number of basic operations and corresponding opcodes. Commonly these are categorized as MISC if they are stack based rather than register based, but can also be defined by the number of instructions (fewer than 32 but greater than one).

Quite a few of the first computers can be classified as MISC. These include (but are not limited to) the ORDVAC (1951) and the ILLIAC (1952) from the University of Illinois and the EDSAC (1949) from the University of Cambridge.

### One Instruction Set Computer (OISC)

This describes an abstract machine that uses only one instruction.  It removes the necessity for a machine language opcode. For example, [“mov” is turing complete](https://www.cl.cam.ac.uk/~sd601/papers/mov.pdf) which means it’s capable of being an OISC, as well as other instructions using subtract.

This has not been commercialized, as far as I know, but it is very popular for teaching computer science.

This leads down a few paths, some can get into all the nitty gritty details of each instruction set and their differences. For the sake of learning more about RISC-V, let's dig more into that specific design.


## RISC-V Design

There is a great paper on the [RISC-V design from Berkeley](https://people.eecs.berkeley.edu/~krste/papers/EECS-2016-1.pdf). Chapter 2, “Why Develop a New Instruction Set?”, is my favorite. It goes over the pros and cons of a lot of prior instruction sets, why the authors decided to create a new instruction set, and what lessons they learned and brought over from their knowledge of the past. I will summarize what I thought was interesting but I urge you to dig in for yourself and read the entire paper.

For one, the authors state the importance of the fact that RISC-V is a completely free and open instruction set architecture. In contrast, all the most widely adopted instruction set architectures are proprietary. They are all also immensely complex. For example, you cannot get a hard copy of the x86 manual anymore and even in PDF form it’s ~5,000 pages and that doesn’t include the extensions. Who has time to read all of that? Although there is no exact number, [it’s estimated there are around 2,500 instructions in x86](https://stefanheule.com/blog/how-many-x86-64-instructions-are-there-anyway/), which is just unwieldy.

Props to Sun Microsystems for the fact that SPARC V8 is an open standard, but the design decisions are highly reflective of the other instruction sets from that time, leaving it unsuitable as a modern instruction set. “It was designed to be implemented in a single-issue, in-order, five-stage pipeline, and the ISA reflects this assumption.”

Alpha came out of Digital Equipment Corporation (DEC) in the 1990s so it got to be built with some learning from the earlier eras. However it seems like they over-engineered it. Most interestingly, they also did not think to create any room for extra opcode space for extensions. The authors also point out that ISAs can die and Alpha is a great example of an ISA being pretty obsolete outside of owning an old DEC computer, other than the last implementation by HP in 2004 when the IP changed hands again.

ARMv7 is widely used and the authors seriously considered it due to the fact of its popularity and ubiquity. However ARMv7 is a closed standard and cannot be extended making it unsuitable for the authors. They also found some technical problems as well, but the biggest determent to me was the fact it has over 600 instructions making it quite complex.

The authors go over a few more instruction sets but I think you get the point that none of them were suitable for their needs. Of course you are more than welcome to dig in further yourself, I am just not going to take the time to reiterate their work here.


## Recapping how I learn

The paper continues into the details of the design of the RISC-V architecture. Some of this I will cover in my DotGo EU talk. For the sake of showing how I learn things I urge you to read the paper yourself and when you hit a term or concept you don’t know: research that concept. Continue this until you get a general understanding then jump back up into the paper where you left off. This cycle is how I dive into new things.

At the beginning of this post I said I would take you down the path of how I dug into RISC-V, yet I have not even begun to describe the actual design or features of RISC-V. I did this to make a point. Look how much I dug into the fundamentals of instruction sets before even digging into the thing I set out to learn. This is commonly what I find happens and I wanted to show an example of my process. Now you can go and continue the rest of the process yourself by continuing to read the [RISC-V design paper](https://people.eecs.berkeley.edu/~krste/papers/EECS-2016-1.pdf), watching other [RISC-V talks](https://www.infoq.com/presentations/risc-v-future), or finding other RISC-V papers and learning from those.

Then, buy a board and start playing with it. I got the [HiFive Unleashed](https://www.sifive.com/boards/hifive-unleashed) and it's awesome!

I hope this helps open your mind to learning and digging deeper on any topics that interest you. Happy learning!


