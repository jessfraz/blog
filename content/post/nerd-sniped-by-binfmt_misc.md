+++
date = "2018-03-04T11:25:24-04:00"
title = "Nerd Sniped by BINFMT\_MISC"
author = "Jessica Frazelle"
description = "How to script in any language thanks to rootless containers and
BINFMT\_MISC."
+++

This is a story about how I got nerd sniped by 
[a blog post from Cloudflare Engineering](https://blog.cloudflare.com/using-go-as-a-scripting-language-in-linux/).
The TLDR on their post is that you can script in Go if you use BINFMT\_MISC in
the kernel.

[BINFMT\_MISC](https://www.kernel.org/doc/html/v4.14/admin-guide/binfmt-misc.html) is really well documented and awesome. In the end all they had to do to script in Go was to mount the filesystem:

```console
$ mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc
```

Then, register the Go script binary format:

```console
$ echo ':golang:E::go::/usr/local/bin/gorun:OC' | sudo tee /proc/sys/fs/binfmt_misc/register
:golang:E::go::/usr/local/bin/gorun:OC
```

Then you can `./` any go file on your host.

```console
$ chmod u+x helloscript.go
$ ./helloscript.go
Hello, world!
```

They go through all the extraordinary details of exit codes for the shell and
blah blah blah. It's a great post you should really read it. Do it, go read it,
then come back here and I will take it to 11.

...

Okay, cool, you are back. That post was dope right?

I kinda want to do this with all languages. Because I LOVE SCRIPTING. Have you
seen my [cloud native dotfiles](https://github.com/jessfraz/dotfiles)? My bash
scripts smell like roses.

Right, so I want to do this with _all_ languages... but what I also hate is
installing shit on my host. Ew, we have containers for those things. Luckily,
I know a thing or two about containers...

A few years ago I made a project called [bincr](https://github.com/jessfraz/binctr). It creates fully static, unprivileged, self-contained, containers as 
executable binaries. (Wow that was a lot of words, let's break it down.) What
`binctr` does is embed an entire container image (aka rootfs) _into_ a fully
static binary and when you execute the binary it will unpack the image and run
it as a container. So you get containers without a daemon or privileges and
without even having the image for the rootfs of the container. You just need
this one binary.

(Huge thanks to [@lordcyphar](https://twitter.com/lordcyphar) who got rootless
containers into runc so I could actually archive my gross hack for `binctr`.)

Kinda seems like the perfect match for trying to use all languages with
BINFMT\_MISC. So I tried it.

(Preface: this post should not be tried at home, which is why I did not
unarchive `binctr`, I am merely showing a different, very crazy, abstraction).

I put common lisp in a container. Why common lisp? Well I could do this with
_any language_ and I'm a bit insane haven't you noticed...

Then I embedded the container into a binary with `binctr`. I made one slight
modification to the spec in `binctr` that allowed me to use local files,
basically so I could get the script into the container after I ran in.

Then I registered my common lisp binary format with BINFMT\_MISC...

```console
$ echo ':clisp:E::lisp::/usr/local/bin/clisp:OC' | sudo tee /proc/sys/fs/binfmt_misc/register
:clisp:E::lisp::/usr/local/bin/clisp:OC
```

And boom, now I can "dot slash" any `.lisp` file and it will run in my common
lisp container.

Obviously my container needed to be packaged with any dependencies and packages
I needed but I didn't need to install any of that shit on my host so I consider
it a win.

Imagine if an entire OS had all the languages packaged this way so that
eveything could be "dot slashed" and executed but without actually installing
the language to your host operating system.

I think it would be dope.

Thanks for tuning into this crazy blog post. Hacker news, you can shove your
comments right up your

