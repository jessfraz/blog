+++
date = "2016-09-30T08:09:26-07:00"
title = "Scripting Your Way Outta Hell"
author = "Jessica Frazelle"
description = "You changed your GitHub username and now all your builds are
broken. Script your way out of hell."
+++

It all started innocently enough. I _had_ "jfrazelle" as my GitHub handle for
years, but my twitter, irc and other handles are all "jessfraz". No one on
GitHub was actually using "jessfraz" so I sat on it waiting to make my move.

I'm currently on vacation this week so of course I was looking to break all the
things. One thing you must know about me is that at no point was I thinking
I hate this. I actually love stuff like this, I live for pain lol. Why else
would I run Linux on the desktop?

I polled the twitterverse...

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Over/Under how many links you think I will break if I change my github username? (Yes, I know there are redirects, but still.)</p>&mdash; Jess Frazelle (@jessfraz) <a href="https://twitter.com/jessfraz/status/781697124748722177">September 30, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

And then I made my move...

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">It is done. Let&#39;s watch the world burn together. <a href="https://t.co/YpLqpP1X38">https://t.co/YpLqpP1X38</a> <a href="https://t.co/4MX1tTthHO">pic.twitter.com/4MX1tTthHO</a></p>&mdash; Jess Frazelle (@jessfraz) <a href="https://twitter.com/jessfraz/status/781705751626670081">September 30, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

Everything was fine for a few minutes. One thing you must know about me is:
I have a private Jenkins instance for continuous builds and testing. Yes I am
this much of a nerd, but it is essential for building all the Dockerfiles for
my publicly readable private docker registry at `r.j3ss.co`. I will save all
that for another blog post, but the jobs started triggering. Immediately
I got a bunch of emails about failed builds because Jenkins could not clone the
repos.

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">oh noe <a href="https://t.co/ZRQnwWNR5L">pic.twitter.com/ZRQnwWNR5L</a></p>&mdash; Jess Frazelle (@jessfraz) <a href="https://twitter.com/jessfraz/status/781745173168619520">September 30, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

"This is fine" I thought to myself. It's all configured with Jenkins DSLs and
I can just do a sed on those files and it will work again.

I do this.

The "apply-dsl" job is still read, *oh duh* because it cannot clone the repo
where the DSLs live to even fix the problem. So I change it manually.

This is fine.

The builds all start again. Except now all the Go builds are failing because
importing "jfrazelle/..." is not working. Vendor your crap kids!!!

So I fix all these repos with the best vim command ever `argdo`. `argdo` will
apply the script you run to all the open buffers, so just open the buffers of
all the go files and run this:

```
argdo %s/jfrazelle/jessfraz/g | update
```

The `| update` makes sure it saves the buffer after.

Ok after ~50 repos of this I am tired but it's fine.

It's all fine. Things are working again.

Now I'm wondering who else I have broken... I search GitHub to see...

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">I&#39;m going to need some more tires for this fire. <a href="https://t.co/YGgMWmaETt">pic.twitter.com/YGgMWmaETt</a></p>&mdash; Jess Frazelle (@jessfraz) <a href="https://twitter.com/jessfraz/status/781941461164052480">September 30, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

I am for sure going to hell for this. What have I done?

I [made/am making some pull requests](https://github.com/search?utf8=%E2%9C%93&q=%22jfrazelle+-%3E+jessfraz%22+author%3Ajessfraz&type=Issues&ref=searchresults)
to various repos. A few of those in the query above
are actually forks of my repos that don't show up in GitHub as forks because
of the way the person forked it so they can be ignored.

Overall I _think_ I really f*cked this entire situation by having an account for
"jfrazelle" and an account for "jessfraz" and swapping them.  I think this is
why the `git clone/fetch/etc` redirects that should happen when you change your
username are broken. So let me just make this clear, none of this is GitHub's
fault. I pretty much did this super wrong. Also I have a deep fear of someone
taking my old username and making fake repos to try and trick imports in Go so
I figured I will squat on it forever to avoid this. Maybe someone from GitHub
can alleviate my probably irrational fear.

I _actually_ think everything _is_ fine now. :)


