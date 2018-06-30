+++
date = "2017-12-16T11:25:24-04:00"
title = "Personal Infrastructure"
author = "Jessica Frazelle"
description = "An overview of my personal infrastructure and services I host."
+++

This post is kind of like "part two" on my series on all the weird things I do
for my personal infrastructure. If you missed "part one", you should check out
[Home Lab is the Dopest Lab](https://blog.jessfraz.com/post/home-lab-is-the-dopest-lab/).

I run a lot of little things to make my life easier, like a CI, some bots, and
a bunch of services just for the lolz. This post will go over all of those. These
run scattered across my NUCs and the cloud. 

Let's start with the most useful.

### Continuous Integration

I host my own continuous integration server. Yes, you guessed it... it's Jenkins.
I use the Jenkins DSL plugin to keep everything in sync. You can find all my
DSLs in my repo [github.com/jessfraz/jenkins-dsl](https://github.com/jessfraz/jenkins-dsl).
This has all the configurations for views, keeps forks up to date, mirrors all my
repositories to private git (more on this in [git](#git-server)),
builds all Dockerfiles to push to Docker Hub and my private registry (more on
this in [private docker registry](#private-docker-registry)) and a bunch of
maintenance scripts.

The [Makefile](https://github.com/jessfraz/jenkins-dsl/blob/master/Makefile) in
this repo calls out to bash scripts which generate new DSLs for any new GitHub
repos I create. Yep I even generate the automation...

There's a bunch of other fun things in there as well that you can discover by
poking around yourself.

I host my own postfix server alongside Jenkins. You
can find the postfix docker image at `r.j3ss.co/postfix` or the [Dockerfile](https://github.com/jessfraz/dockerfiles/tree/master/postfix). It's super minimal and less gross than literally every
other postfix image in existence.

You can run it with:

```bash
$ docker run --restart always -d \
    --name postfix \
    --net container:jenkins \
    -e "ROOT_ALIAS=root@blah.com" \
    -e "RELAY=[smtp-relay.gmail.com]:587" \
    -e "TLS=1" \
    -e "MY_DESTINATION=...., localhost" \
    -e "MAILNAME=blah.com" \
    r.j3ss.co/postfix
```

### Private Docker Registry

I host my own private docker registry with my own notary server and authentication
server. Why? Well because about 4 years ago when I started using docker, Docker
Hub was super slow and I came to love having my own super fast one.

I still push all the images to both Docker Hub and my registry and both are
signed so it's really like I am using Docker Hub as my backup. Yay, highly
available... just kidding.

I made a pretty shitty UI for it. You can play with it at [r.j3ss.co](https://r.j3ss.co/).
The UI is from my [reg](https://github.com/jessfraz/reg) project but the
server component lives in the [server subdirectory](https://github.com/jessfraz/reg/tree/master/server).

The really nice thing about both the `reg` command line and server is that you
can get a list of CVEs on an image.

![cves](/img/cves.png)

I do this by hosting my own instance of [CoreOS's Clair](https://github.com/coreos/clair).

Most of my Dockerfiles live at
[github.com/jessfraz/dockerfiles](https://github.com/jessfraz/dockerfiles) if
you are curious.

I also went over all of this on my talk on [Over Engineering my
Laptop / Container Linux on the Desktop](https://docs.google.com/presentation/d/17Hml1iFqdXElxOcrh9caQSC5px5mDgaS015Vhaz42ZY/edit?usp=sharing). This includes all the reasons why I have continuous integration as well.

I have a script to cleanup the registry of old images [clean-registry](https://github.com/jessfraz/dotfiles/blob/master/bin/clean-registry). This deletes old registry blobs that are not used
in the latest version of the tag. I don't really care about old images and
I don't want to have a huge registry filled with old shit. There is a [jenkins
DSL](https://github.com/jessfraz/jenkins-dsl/blob/master/projects/maintenance/garbage_collect_registry.groovy) to run this.

### Git Server

I host my own git server. You
can find the gitserver docker image at `r.j3ss.co/gitserver` or the [Dockerfile](https://github.com/jessfraz/dockerfiles/tree/master/gitserver).

You can run it with:

```bash
$ docker run --restart always -d \
    --name gitserver \
    -p 127.0.0.1:22:22 \
    -e "PUBKEY=$(cat ~/.ssh/authorized_keys)" \
    -v "/mnt/disks/gitserver:/home/git" \
    r.j3ss.co/gitserver
```

It has it's own UI that is run with Gitiles. You
can find the Gitiles docker image at `r.j3ss.co/gitiles` or the [Dockerfile](https://github.com/jessfraz/dockerfiles/tree/master/gitiles).

You can run it with:

```bash
$ docker run --restart always -d \
    --name gitiles \
    -p 127.0.0.1:8080:8080 \
    -e BASE_GIT_URL="git@git.blah.com" \
    -e SITE_TITLE="git.blah.com" \
    -v "/mnt/disks/gitserver:/home/git" \
    -w /home/git \
    r.j3ss.co/gitiles
```

### ghb0t

This is one of my most useful things. It's a GitHub Bot to automatically delete
your fork's branches after a pull request has been merged.

I am _so_ OCD about keeping git repos clean and this is my little helper.

Check out the repo: [github.com/jessfraz/ghb0t](https://github.com/jessfraz/ghb0t).

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">I go to fork your thing and there is like 300 branches my face is like <a href="https://t.co/JpdpO447KS">pic.twitter.com/JpdpO447KS</a></p>&mdash; jessie frazelle (@jessfraz) <a href="https://twitter.com/jessfraz/status/823425160787021825?ref_src=twsrc%5Etfw">January 23, 2017</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

### IRC Bouncer

I host my own IRC Bouncer with ZNC.
You can find the ZNC docker image at `r.j3ss.co/znc` or the [Dockerfile](https://github.com/jessfraz/dockerfiles/tree/master/znc).

You can run it with:

```bash
$ docker run --restart always -d \
    --name znc \
    -p 6697:6697 \
    -v "/mnt/disks/znc:/home/user/.znc" \
    r.j3ss.co/znc
```

### upmail

This service provides email notifications for [sourcegraph/checkup](https://github.com/sourcegraph/checkup).
If you are unfamiliar with checkup... it's distributed, lock-free, self-hosted
health checks and status pages, written in Go.

I wrote a small little server to send email alerts for it and it lives
at [github.com/jessfraz/upmail](https://github.com/jessfraz/upmail).

### iPython

Not really all that novel but I also run an iPython server for doing little
script things in. I just use the `jupyter/minimal-notebook` Docker image for that.

### Conclusion

I run a lot of little shitty services for a personal [pastebin](https://github.com/jessfraz/pastebinit)
and other things
but those are all really less cool. My attention span for blog posts is about
5 minutes and we have runneth over so I am going to call it a day with
this... until next time. Peace out.
