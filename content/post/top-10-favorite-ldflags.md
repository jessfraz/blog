+++
date = "2016-07-18T13:00:14-07:00"
title = "10 LDFLAGS I Love"
author = "Jessica Frazelle"
description = "My favorite LDFLAGS."
+++

Hello and welcome to what will become the most sarcastic post on my blog.
This is going to be a series of "buzzfeed" style programming articles and after
this post I very happily pass the baton to [Filippo Valsorda](https://twitter.com/FiloSottile/status/754774945847209988) to continue. And I urge you to write your own as well.

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/jessfraz">@jessfraz</a> &quot;We asked Jess for her top 10 ldflags; you won&#39;t believe what happened next&quot;</p>&mdash; adg (@enneff) <a href="https://twitter.com/enneff/status/754737186960838656">July 17, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>


So here they are:

1. `-static`

    I would be an embarassment to myself if I didn't start with the flag that
    tells the linker to not link against shared libraries. This is the best flag.
    STATIC BINARIES FTW.

2. `--export-dynamic`

    This flag tells the linker to add all the symbols to the dynamic symbol
    table. This is especially important if you want to do ["The Macgyver of Dlopening"](https://github.com/jessfraz/macgyver) and `dlopen` yourself.

3. `--whole-archive`

    This is another flag that comes in handy when you want to `dlopen`
    yourself. See most linkers will only take into account the things it knows
    it needs. But with this flag, you tell it "YOLO, I want it all" so that
    later you can `dlopen` yourself with that symbol that was never actually
    used until runtime. FUN!

4. `--no-whole-archive`

    This flag un-sets the `--whole-archive` flag which is nice for when you
    only want the whole archive of one library but not all the others you are
    linking to.

5. `--print-map`

    This flag is just dope. It prints a link map to stdout. This gives you
    information about object files, common symbols, and the values assigned to
    symbols.

6. `--strip-all`

    This flag strips all the symbol information from the artifact produced. If
    say you are a few KB/MB off from your binary fitting on a floppy disk, this
    flag is your friend.

7. `--strip-debug`

    This flag is very similar to `--strip-all` except it only strips the debug
    symbol information. This all really depends on how much you need to shave
    off to fit that binary on a floppy disk.

8. `--trace`

    This flag is great for debugging. It prints the names of the input files as
    `ld` processes them.

9. `-nostdlib`

    This flag forces the linker to only search the libraries you specify with
    `--library-path` or `-L`. This is nice when _someone_ completely messes
    with your library path and the world is burning and you just want to link
    to those things you put in some random directory somewhere.

10. `--unresolved-symbols=ignore-all`

    This flag is helpful when telling the linker you DGAF about unresolved
    symbols and to stop yelling at you.
