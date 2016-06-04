+++
date = "2016-06-04T08:09:26-07:00"
title = "The Art of Closing"
author = "Jessica Frazelle"
description = "How to close patches for your open source project you don't want."
+++

Being an open source software maintainer is hard. The following post is geared
towards maintainers and not contributors. If you are a new contributor to
open source I would stop reading now because I don't want you to get the wrong
idea or discourage you. Tons of patch requests get merged per day, but this is
going to focus on the ones that don't.

I've talked to maintainers from several different open source projects, mesos,
kubernetes, chromium, and they all agree one of the hardest parts of
being a maintainer is saying "No" to patches you don't want.

To quote some very smart people I've worked with in the past:

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">One of the numerous examples of information asymmetry in open source: contributors put effort in a pet PR, but maintainers manage cattle. 🕒</p>&mdash; Arnaud Porterie (@icecrime) <a href="https://twitter.com/icecrime/status/733682351943733249">May 20, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Rule #1 of open-source: no is temporary, yes is forever.</p>&mdash; Solomon Hykes (@solomonstre) <a href="https://twitter.com/solomonstre/status/715277134978113536">March 30, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

To make this rather unpleasant experience of closing someone's patch request
easier I have a few ways of going about it. Now of course I am no expert in this
area, but on the Docker project we have
(stats for just about everything)[https://github.com/icecrime/vossibility-stack].
I _might_ have used this data to make a "Ultimate
Dream Killers" chart with the maintainers who closed (without merging) the most
pull requests, AND I _might_ have been #1 on this chart for some time.

None of the suggestions below are going to save you from that person hate
mailing you since you didn't merge their patch. But hey anything helps.


1. The ego stroke and close.

    People love hearing how awesome they are. They also love hearing how
    awesome their code is. In this option you use this to your advantage.
    Here's an example:

    <blockquote>
    "Thanks so much for spending time on this amazing patch. We really
    appreciate it. However I do not think this is something we want to add
    right now, but in the future this can change. Thanks so much!"
    </blockquote>

    AAAANNNDD close.

2. Close early.

    No one wants to have to do 300 rebases before learning the design of their
    patch isn't approved. If you know there is no way you will ever accept
    their patch, close it right then. Making someone wait and/or do more work
    while waiting will just make the situation worse when you _do_ close it.

3. The "I kinda like this but it's just not right".

    If someone creates a new feature that you might like if it was done differently
    but the current implementation has no way of being merged (maybe for design
    flaws etc.) I believe it's best to close with opportunity for the person
    open another patch with the desired design. Here's an example:

    <blockquote>
    Hi X,
    We really appreciate you taking the time to make this patch. However the
    design was not discussed prior to writing it. We do see potential in what
    you are trying to build here. But we think it would be more effective as
    blah, blah, and blah.
    We are going to close this but would love to see you open a patch that
    takes the above direction. Thanks, this could really be an awesome feature!
    </blockquote>

    See how the ego stroke comes in handy here too :). AAAAAAND close.

4. The carry.

    Carrying a patch is when a maintainer will take a user's patch and add
    edits on top of it so it is mergable. On the docker project we do this
    every so often and for various reasons:

    - Contributor disappeared but the patch is viable just needs some edits.
    - Patch is like #3 above but it would be easier if we just did the
      implementation itself.

    It's important to note if you are going to carry a patch, DO NOT close the
    original patch request until you have opened your carry patch. You
    obviously need to let the contributor know before hand you will be carrying
    it so they know they don't waste their time. Also be sure to keep their
    original commit's and add yours on time so the right people get
    credit :)

    Here's an example:

    <blockquote>
    Hi X, we really like your patch, but since there hasn't been a response in
    Y days we are going to carry this patch and make the edits ourselves. We
    will link to the new pull request here when it's ready.
    </blockquote>

    Maintainer works on patch... opens new patch... then you can close the
    original patch request. See if you close it before opening the new one, the
    contributor will assume you are lying and never going to do it.

These are just a few of the techniques we've used in the past. I hope if you
are a maintainer of a project they are helpful for you, but I would love to
know your tips as well.

Happy Maintaining!
