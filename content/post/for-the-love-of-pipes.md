+++
date = "2019-01-21T08:09:26-07:00"
title = "For the Love of Pipes"
author = "Jessica Frazelle"
description = "Why unix pipes are awesome."
+++

My top used shell command is `|`. This is called a pipe.

In brief, the `|` allows for the output of one program (on the left) to become
the input of another program (on the right). It is a way of connecting two
commands together. 

For example, if I were to run the following:


```
echo "hello"
```

I get the output `hello`.

But if I run:

```
echo "hello" | figlet
```

The `figlet` program, changes the letters in `hello` to look all bubbly and
cartoony.

This is a really blunt way of describing something that, in my
opinion, is brilliant software design, but I will get into that in a second.

Let's go back to the origin of pipes.

According to [doc.cat-v.org/unix/pipes/](http://doc.cat-v.org/unix/pipes/), the
origin of pipes came long before Unix. Pipes can be traced back to this note from
Doug McIlroy in 1964:

```
          - 10 -
    Summary--what's most important.

To put my strongest concerns into a nutshell:

1. We should have some ways of coupling programs like
garden hose--screw in another segment when it becomes when
it becomes necessary to massage data in another way.
This is the way of IO also.

2. Our loader should be able to do link-loading and
controlled establishment.

3. Our library filing scheme should allow for rather
general indexing, responsibility, generations, data path
switching.

4. It should be possible to get private system components
(all routines are system components) for buggering around with.

                                                M. D. McIlroy
                                                October 11, 1964 
```

The Unix philiosophy is also documented by Doug McIlroy as:

```
1. Make each program do one thing well. To do a new job, build afresh rather 
than complicate old programs by adding new "features".

2. Expect the output of every program to become the input to another, 
as yet unknown, program. Don't clutter output with extraneous information. 
Avoid stringently columnar or binary input formats. 
Don't insist on interactive input.

3. Design and build software, even operating systems, to be tried early, 
ideally within weeks. 
Don't hesitate to throw away the clumsy parts and rebuild them.

4. Use tools in preference to unskilled help to lighten a programming task, 
even if  you have to detour to build the tools and expect to throw some of 
them out after you've finished using them.
```

What I love about Unix is the philosophy of "do one thing well" and "expect the output of every 
program to become the input to another". This
philosophy is built on the use of tools. These tools can be used separately or
combined to get a job done. This is in stark contrast to monolithic programs that do
everything or one-off programs used to solve a specific problem.

System programs and commands like `echo`, which we saw above, output information to your terminal by
default. For example, `cat` will "concatenate" (it's namesake)
files and print the result to your terminal.
While reading [Program design in Unix](http://harmful.cat-v.org/cat-v/unix_prog_design.pdf),
I realized that printing the output of the tool to the user's terminal was actually the
special case. 

> "Perhaps surprisingly, in practice it turns
> out that the special case is the main use of the program."

When a user redirects the output of `cat` via a `|` to some other program,
`cat` becomes so much more than what
the original author intended. This is one of the most brilliant design
patterns, in my opinion.  For one, programs being simple and doing one thing
well makes them easy to grok. The beautiful part, though, is the fact that in 
combination with a operator like
`|` the program becomes one step in a much larger plan. The original author of
`cat` does not even need to know about the larger plan. That is the beauty of
the `|` it allows for solving problems by combining small,
simple programs together.

I love software design that enables creativity, values simplicity, and doesn't put users in a box.
The pipe, is a key element for keeping programs simple while enabling
extensibility. A simple program in combination with a `|` becomes so much more than what the
original author could have dreamed of.

I hope this post helped you learn something, if not, just pipe it to
`/dev/null`.
