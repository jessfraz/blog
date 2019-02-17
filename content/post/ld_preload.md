+++
date = "2019-02-17T08:09:26-07:00"
title = "LD_PRELOAD: The Hero We Need and Deserve"
author = "Jessica Frazelle"
description = "A summary of my undying love for LD_PRELOAD."
+++

I’m a huge, HUGE, fan of `LD_PRELOAD` let me tell you… oh wait it’s my blog so I’m going to. Where do I begin…

About three years ago, I wrote a blog post about the 
[10 `LDFLAGS` I love](https://blog.jessfraz.com/post/top-10-favorite-ldflags/). 
After writing the post, I realized I should have made the number odd because I think that is part 
of BuzzFeed’s “click algorithm.” But more seriously, I realized just how many people on the internet you 
can upset when you don’t include `LD_PRELOAD` in your favorite `LDFLAGS` post. I am going to take the time right 
now to make one thing very clear, VERY CLEAR, listen closely:  `LD_PRELOAD` IS NOT A FLAG. 
It is an environment variable. Wake up sheeple! Phew! 

Now that’s out of the way, we can continue… I love `LD_PRELOAD`. I love it so much I am devoting this 
entire blog post to professing my undying love for it. So here we go…


## Background

For those who don’t know what `LD_PRELOAD` is: [TODAY IS YOUR LUCKY DAY!](https://xkcd.com/1053/)
`LD_PRELOAD` allows you to override symbols in any library by specifying your new function in a shared object.

When you run `LD_PRELOAD=/path/to/my/free.so /bin/mybinary`, `/path/to/my/free.so` is loaded 
*before* any other library, including libc. When `mybinary` is executed, it uses your custom function for `free`. 
PRETTY FREAKING AWESOME RIGHT! 


![kronk](/img/kronk.gif)


FEEL THE POWER! Okay, so moving on…


## Fun Times on the Internet

One night, I’m just hanging around in my apartment, laying on my couch, and I think 
“oh I’m going to ask the Internet what they’ve done with `LD_PRELOAD`." This is how most of my tweets start 
for what it’s worth. So I asked…


<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">yo internet nerds, tell me all the ways you&#39;ve done dirty things with LD_PRELOAD.... I need them.... for... science...</p>&mdash; jessie frazelle 👩🏼‍🚀 (@jessfraz) <a href="https://twitter.com/jessfraz/status/1087468414707343362?ref_src=twsrc%5Etfw">January 21, 2019</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>


This tweet blew up in THE BEST WAY! I got some really cool responses I will highlight below.

<blockquote class="twitter-tweet" data-conversation="none" data-lang="en"><p lang="en" dir="ltr">Not mine but my favorite: <a href="https://t.co/zljcn70pmh">https://t.co/zljcn70pmh</a></p>&mdash; ダデイさま (@leifwalsh) <a href="https://twitter.com/leifwalsh/status/1087496833058914304?ref_src=twsrc%5Etfw">January 21, 2019</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>


<blockquote class="twitter-tweet" data-conversation="none" data-lang="en"><p lang="en" dir="ltr">$ FORCE_PID=42 LD_PRELOAD=./getpid.so bash -c &#39;echo $$&#39;<br>42<br><br>For forcing specific bad ssh key generation when the RNG was busted...</p>&mdash; 𝙺𝚎𝚎𝚜 𝙲𝚘𝚘𝚔 (@kees_cook) <a href="https://twitter.com/kees_cook/status/1094391729422123008?ref_src=twsrc%5Etfw">February 10, 2019</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-conversation="none" data-lang="en"><p lang="en" dir="ltr">i didn&#39;t use this but dropbox recently stopped working on non-ext4 filesystems and there&#39;s this LD_PRELOAD hack to make it work anyway <a href="https://t.co/DqRL12FNMk">https://t.co/DqRL12FNMk</a></p>&mdash; 🔎Julia Evans🔍 (@b0rk) <a href="https://twitter.com/b0rk/status/1087478518534098945?ref_src=twsrc%5Etfw">January 21, 2019</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-conversation="none" data-lang="en"><p lang="en" dir="ltr">Intercept readline calls to add undo to any interpreter that uses readline<a href="https://t.co/M44lDMaeFy">https://t.co/M44lDMaeFy</a><a href="https://t.co/aoeldkK4X6">https://t.co/aoeldkK4X6</a> <a href="https://t.co/w84O715eQG">pic.twitter.com/w84O715eQG</a></p>&mdash; Thomas Ballinger (@ballingt) <a href="https://twitter.com/ballingt/status/1087473790227951616?ref_src=twsrc%5Etfw">January 21, 2019</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-conversation="none" data-lang="en"><p lang="en" dir="ltr">We actually mention this in an academic paper! <a href="https://t.co/qg5ac6vXx7">https://t.co/qg5ac6vXx7</a> We used LD_PRELOAD to interpose on the OnStar software modem audio interface.</p>&mdash; Karl (@supersat) <a href="https://twitter.com/supersat/status/1087472112611282945?ref_src=twsrc%5Etfw">January 21, 2019</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-conversation="none" data-lang="en"><p lang="en" dir="ltr">I wrote a silly hack that let you mount an app’s objc runtime as a filesystem so you could easily browse the class hierarchy.  It could be inserted via dyld. Here is a screenshot of the Finder browsing the runtime. <a href="https://t.co/zyYxSsGaoS">https://t.co/zyYxSsGaoS</a></p>&mdash; Bill Bumgarner (@bbum) <a href="https://twitter.com/bbum/status/1087556645473796096?ref_src=twsrc%5Etfw">January 22, 2019</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-conversation="none" data-lang="en"><p lang="en" dir="ltr">enabling rapid-fire railguns in quake3 rocket arena by hooking gettimeofday() via LD_PRELOAD, enable/disable by hooking strstr() and using console commands</p>&mdash; HD Moore (@hdmoore) <a href="https://twitter.com/hdmoore/status/1087470884896628737?ref_src=twsrc%5Etfw">January 21, 2019</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>


<blockquote class="twitter-tweet" data-conversation="none" data-lang="en"><p lang="en" dir="ltr">I made a thing to disable SSL certificate verification in a bunch of popular applications/libraries 😈<a href="https://t.co/jMWQtbl0Kb">https://t.co/jMWQtbl0Kb</a></p>&mdash; Dаvіd Вucһаnаn (@David3141593) <a href="https://twitter.com/David3141593/status/1087469585798959105?ref_src=twsrc%5Etfw">January 21, 2019</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>




This isn’t all of them but isn’t the internet utterly awesome! You can poke through the thread 
more and find ones you love as well. But let's move on to some mad science...




## SCIENCE

No, not the [Incubus album](https://en.wikipedia.org/wiki/S.C.I.E.N.C.E.)… 
but my science experiment that I did with `LD_PRELOAD`. My friend, [@grepory](https://twitter.com/grepory), 
and I came up with this absolutely insane idea for "kernelless". Yeah, it’s a joke making fun of all the other 
“-less”s. But ours was special, m’kay. He even made a dope website for it, [kernelless.cloud](http://kernelless.cloud/). 

So the way we were going to implement this in a mad science way would be as “Cloud Native Syscalls.” 
Let me tell you about the “Cloud Native Syscalls”…


## Cloud Native Syscalls

The first part of the “Cloud Native Syscalls” architecture consists of a daemon on a cloud VM 
which has a network endpoint accepting incoming syscalls and their arguments. 
The daemon then performs these syscalls, almost in a code execution as a service type way.

To use “Cloud Native Syscalls”, you compile your binary with the library as follows: 
`LD_PRELOAD=/path/to/my/cloudnativesyscalls.so /bin/ls`. This ensures that all your syscalls when you run `ls` 
on *your host* are actually performed in the cloud and sent to the daemon described above.


![nuts](/img/nuts.gif)


F’king nuts right… I know. We are working on our A-round don’t worry. It’s truly revolutionary.

Anyways, that was our little science experiment. Hope you liked it, or at least enjoyed all the other people’s 
fun hacks. :) Keep `LD_PRELOAD`ing.


![everyday-im-ld-preloading](/img/everyday-im-ld-preloading.jpg)

