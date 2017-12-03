+++
date = "2017-12-03T11:25:24-04:00"
title = "Home Lab is the Dopest Lab"
author = "Jessica Frazelle"
description = "How I set up my home lab to be my very own cloud."
+++

I always have some random side project I am working on, whether it is making the
[world's most over engineered desktop OS all running in containers](https://drive.google.com/open?id=17Hml1iFqdXElxOcrh9caQSC5px5mDgaS015Vhaz42ZY) or updating all my Makefiles to
be the definition of glittering beauty.

This post is going to go over I how I recently redid all my home networking and
ultimately how I got to here:


<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">ssh-ed into my dev NUC from a Pixelbook 39,000 feet, authenticated from an ssh key on a yubikey, the future is dope AF</p>&mdash; jessie frazelle (@jessfraz) <a href="https://twitter.com/jessfraz/status/933155384419897344?ref_src=twsrc%5Etfw">November 22, 2017</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>



I used [Unifi](https://unifi-sdn.ubnt.com/) for everything and this is what I got:

- Access Point: [AP AC SHD](https://unifi-shd.ubnt.com/)
- Switch: [Switch 16-150W](https://www.ubnt.com/unifi-switching/unifi-switch-16-150w/)
- Router: [Security Gateway](https://www.ubnt.com/unifi-routing/usg/)

It was so good looking when it arrived.


<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">My network is about to get real... fast!!!<br><br>This switch is (dare I say it) sexy as hell. <a href="https://t.co/fmaLkW2AFB">pic.twitter.com/fmaLkW2AFB</a></p>&mdash; jessie frazelle (@jessfraz) <a href="https://twitter.com/jessfraz/status/931304322100539395?ref_src=twsrc%5Etfw">November 16, 2017</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>


I love fun side projects so obviously I set it all up right away. You need
a "controller" to have the nice Unifi UI. You can buy a cloud key but I wanted
to run the controller in container just like [Dustin Kirkland](http://blog.dustinkirkland.com/2016/12/unifi-controller-in-lxd.html). So I set about writing a Dockerfile for the
controller and it is now at [r.j3ss.co/unifi](https://github.com/jessfraz/dockerfiles/blob/master/unifi/Dockerfile).

You can run it with:

```bash
docker run -d --restart always \
    --name unifi \
    --volume path/to/where/you/want/your/data:/config \
    -p 3478:3478/udp \
    -p 10001:10001/udp \
    -p 8080:8080 \
    -p 8081:8081 \
    -p 8443:8443 \
    -p 8843:8843 \
    -p 8880:8880 \
    r.j3ss.co/unifi
```

The web UI is at https://{ip}:8443. To adopt an access point, and get it
to show up in the software you will need to ssh into the AP and run:

```bash
ssh ubnt@$AP-IP mca-cli set-inform http://$address:8080/inform
```

Then I went crazy and made sure everything that needed to talk to each other
was on the same subnet and everything else was isolated into it's own subnet.
I used VLANs to do this.

Also be careful not to subnet yourself into a hole ;)


<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">me just now: &quot;this was my fear! sub-netting myself into a hole!&quot;</p>&mdash; jessie frazelle (@jessfraz) <a href="https://twitter.com/jessfraz/status/936253292556050433?ref_src=twsrc%5Etfw">November 30, 2017</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>


### NUCs

I have a bunch of Intel NUCs thanks to [Carolyn Van Slyck](https://twitter.com/carolynvs) and [Joe
Beda](https://twitter.com/jbeda) for their thought leadership... my wallet is
not happy with you two.


<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">They have LEDs on the front that change color. There is a kernel driver for them.</p>&mdash; Joe Beda (@jbeda) <a href="https://twitter.com/jbeda/status/920672603177607168?ref_src=twsrc%5Etfw">October 18, 2017</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>


I hooked them all into my Switch (**glorious**) and into their own subnet. Then
I went about setting up SSH for all of them.

I use Yubikeys for authentication to GitHub and literally everything else where
that is possible so I made a bot to sync any new ssh keys added to my GitHub to
the authorized keys on my server. It lives at [github.com/jessfraz/sshb0t](https://github.com/jessfraz/sshb0t).

I would **ONLY** recommend doing that if you have two factor auth turned on so
you ensure no one else but you can access your account. And honestly if someone
gets into my GitHub account I am going to have wayyyy worse issues that them
getting into my NUCs.

I have ssh keys on Yubikeys that I set up. There is a [really great guide to
doing this on GitHub](https://github.com/drduh/YubiKey-Guide) so I am not going
to repeat it.

For the Chromebook Pixelbook ssh client authentication you just need the Smart Card
reader extension and you are good to go! You can find the guide on that from
the [Chromium Docs](https://chromium.googlesource.com/apps/libapps/+/master/nassh/doc/hardware-keys.md).

Let me just answer the most common question I get... No, I don't use Crouton
on my Chromebooks I just ssh to the cloud or to my home lab. I like things
clean and minimal if you have not noticed already.

Okay so that's all for now. I'll do another deep dive into the rest of my
infrastructure when I'm not overwhelmed with how much there is...


<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">There’s so much:<br>- scripts for setting up ssh on yubikeys<br>- unifi setup<br>- nuc provisioning <br>- auto updates &amp; maintenance<br>- build infrastructure for all my images etc<br>- security of all the things<br>- cameras<br>- keeping all laptops up to date</p>&mdash; jessie frazelle (@jessfraz) <a href="https://twitter.com/jessfraz/status/935667037145305088?ref_src=twsrc%5Etfw">November 29, 2017</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

