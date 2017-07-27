+++
date = "2017-07-27T08:09:26-07:00"
title = "A Rant on Usable Security"
author = "Jessica Frazelle"
description = "The past, present, and future of usable security. With a focus on containers."
+++

I recently gave a talk at DevOps Days
([slides](https://docs.google.com/a/jessfraz.com/presentation/d/1QnakgUC8AaNydPZCmKGYYja8gs2WoHbHRSjioIVdD9g/edit?usp=drivesdk))
and it had a pretty great response. I'm still pretty care-mad about the topics
it covered so I figured I would turn some key points from it into a blog post.

The overall outline of the talk covered the past, present, and future of
usable security. Let's start with the past.

## The Past

A lot of the security tooling of the past (that we still use today)
require users to jump through a lot of hoops or learn a hard to grok interface.
One of the examples I used was GPG. Contrary to popular opinion, I actually
don't find GPG entirely unusable. I obviously agree that it could be easier
to use, rotate keys, revoke keys blah blah blah. While I find it not exactly
terrible, I can see and completely understand why the majority of
criticism I hear about GPG is that it is hard to use.

There is a point at which better security comes at the expense of convenience.
This needs to stop happening. Stop compromising convenience for security.
Instead find the right balance between the two. Doing this takes collaboration
from both security engineers and software engineers.

Dave Cheney recently had a great tweet.


<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Why is all software shit? Today I discovered the <a href="https://twitter.com/duosec">@duosec</a> API returns 200 even if someone denies the 2fa request.</p>&mdash; Dαve Cheney (@davecheney) <a href="https://twitter.com/davecheney/status/889725425781424129">July 25, 2017</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>



I love this tweet because it reeks of the stench that only security engineers
built this API. Most software engineers I know would decide to use an HTTP
status code... I mean that's what they are for. ;)

When you combine expertise in different areas you build better products. This is
not rocket science. However egos tend to get in the way as well as biases
towards people who know and like the same things you do. I assure you,
though, when security and software engineers work together
truly usable security will be the outcome.

## The Present

A lot of the content for this portion of the talk focused on how containers make
securing your infrastructure easier. I will touch on some of that but if you
wish to know more you should checkout the
[slides](https://docs.google.com/a/jessfraz.com/presentation/d/1QnakgUC8AaNydPZCmKGYYja8gs2WoHbHRSjioIVdD9g/edit?usp=drivesdk)
or some of my other blog posts on container security.

Two key features in Docker are the default AppArmor and Seccomp profiles.
AppArmor and Seccomp are Linux Security Modules that are not exactly usable
by someone who is unfamiliar with either.

AppArmor can control and audit various process actions such as file
(read, write, execute, etc) and system functions (mount, network tcp, etc).
It has its own meta language, so to speak, and I actually have a repo that changes
the docs for it to more a readable format via a cron job:
[github.com/jessfraz/apparmor-docs](https://github.com/jessfraz/apparmor-docs).
The default profile for AppArmor does super sane things like preventing writing to
`/proc/{num}`, `/proc/sys`, `/sys` and preventing `mount` to name a few.

Syscall filters allow an application to define
what syscalls it allows or denies. The default in Docker is a whitelist that I
initially wrote. Some of the key things it blocks are:

- `add_key`, `keyctl`, `request_key`: Prevent containers from using the kernel
keyring, which is not namespaced. I wrote a blog post on
[Two Objects not Namespaced by the Linux Kernel](https://blog.jessfraz.com/post/two-objects-not-namespaced-linux-kernel/)
and the keyring was one I mentioned.
- `clone`, `unshare`: Deny cloning new namespaces. Also gated by `CAP_SYS_ADMIN`
for `CLONE_*` flags, except `CLONE_USERNS`. I specifically wanted to block
cloning new user namespaces inside containers because they are notorious
for being points of entry for kernel bugs.

There also is an
[entire document that I started in the docker repo](https://github.com/moby/moby/blob/52f32818df8bad647e4c331878fa44317e724939/docs/security/seccomp.md#syscalls-blocked-by-the-default-profile)
that outlines what we block and why.

Having written the default seccomp profile for Docker I am pretty familiar with
how hard this would be for other people. It requires a deep knowledge of the
application being contained and the syscalls it requires. This was also a quite
terrifying feature to add to Docker. When I added it, Docker was already very
popular and if anything would break in a big way it would be on the front page
of hacker news and all the maintainers would have a very bad day. So turning
on something that will `EPERM` by default if we left out any important syscall
is terrifying. I had stress nightmares for weeks. In the end everything went
much smoother than I feared but that was also after HEAVY HEAVY testing. Luckily
I run super obscure things in containers so I even caught that we left out `send`
and `recv` right before the release by running Skype (a 32 bit application) in
a container.

By making a default for all containers, we can secure a very large amount of
users without them even realizing it's happening. This leads perfectly into
my ideas for the future and continuing this motion of making security
on by default and invisible to users.

## The Future

I tend to have pretty weird brain child ideas and this is one of them.
I started thinking about where else a kernel feature like seccomp could easily
be integrated and used by a large number of people. The answer is...
programming languages. I do work with the Go team and as a full content warning
none of this crazy that follows is in any way endorsed by them. ;)

The idea I had is to do **build-time generated** seccomp filters that will be
**applied on run**.

#### Why generate seccomp filters at **build-time**?

Generating security filters/profiles at runtime has been done in the past
& failed... over and over and over again. Something is always missed while
profiling the application. You cannot guarantee that everything that your
application will do will be called while in this profiling phase. Unless of
course you have 100% test coverage, which if you do: Good For You. When the
"thing that was missed" is called and blocked, users will just turn off the
"security." This happens all the time with things like SELinux and AppArmor.

By generating filters at build-time we can ensure ALL code is included in the
filter. I wrote a POC of this and I showed it at
[Kiwicon](https://kiwicon.org/the-con/talks/#e253).

There are three problems though.

1. Executing other binaries. I can't know what syscalls the binary being called
is going to use so we are back at square one.

    ```
    package main

    import (
        "fmt"
        "log"
        "os/exec"
    )

    func main() {
        cmd := exec.Command("myprogram")
        out, err := cmd.CombinedOutput()
        if err != nil {
            log.Fatal(err)
        }
        fmt.Printf("%s\n", out)
    }
    ```


2. Plugins. This problem is solvable in that _if_ this feature was to exist
we could export at the plugin build time the seccomp filters to a
field in the ELF binary or something similar.

    ```
    func main() {
        p, err := plugin.Open("plugin_name.so")
        if err != nil {
            log.Fatal(err)
        }
        v, err := p.Lookup("V")
        if err != nil {
            log.Fatal(err)
        }
        fmt.Printf("%#v\n", v)
    }
    ```

3. Sending arbitrary arguments to `syscall.RawSyscall` and similar.

    ```
    func main() {
        if len(os.Args) <= 3 {
            log.Fatal("must pass 4 arguments to syscall.RawSyscall")
        }
        r1, r2, errno := syscall.RawSyscall(strToUintptr(os.Args[0]),
            strToUintptr(os.Args[1]),
            strToUintptr(os.Args[2]),
            strToUintptr(os.Args[3]))
        if errno != 0 {
            log.Fatalf("errno: %#v", errno)
        }
        fmt.Printf("r1: %#v\nr2: %#v\n", r1, r2)
    }
    func strToUintptr(s string) uintptr {
        return *(*uintptr)(unsafe.Pointer(&s))
    }
    ```

While this is not perfect by any stretch of the imagination I believe it should
open your mind to what _could_ be possible in the future. Hopefully my dream
of making binaries sandbox themselves will eventually get there. I know I won't
stop until it does. ;) Overall, I would like you to remember to find the
right balance between secure AND usable. Don’t break users and get security
engineering and software engineering working together!
