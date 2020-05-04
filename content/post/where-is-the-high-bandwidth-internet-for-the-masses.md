+++
date = "2020-05-03T08:09:26-07:00" 
title = "Where is the high bandwidth internet for the masses?" 
author = "Jessica Frazelle" 
description = "A bit of a dive into pixel density and internet bandwidth." 
+++

Being cooped up at home got me looking into the new Xbox and PlayStation 5.
I was curious about the innovations in the consoles since their successors. Both
claim to have ray tracing and support for 8K graphics. This then got me thinking
about how prevalent 8K televisions are today. 8K televisions seem to be in the
same state as 4K televisions a few years ago. One thing I know through my life
is that pixel density will continue to get bigger and bigger. I almost wonder if
there is a Moore’s Law equivalent for pixel density… let’s take a look at
televisions through the years.

## Pixel density through the years

### Standard definition television

The first electronic television was invented in 1927[^1]. Cable television systems
originated in the United States in the late 1940s and were designed to improve
reception of commercial network broadcasts in remote and hilly areas[^2]. We can
consider the televisions of this time to be what we know of as “standard
definition.” Standard definition television (SDTV) is designed on the assumption
that viewers in the typical home setting are located at a distance equal to six
or seven times the height of the picture screen — on average some 10 feet away. 

### High definition television

High definition television (HDTV) has its roots in research that was started by
Japan’s public broadcaster, NHK, in 1970[^3]. For comparison, a 1080i HDTV signal
offers about six times the resolution of a conventional 480i SDTV signal. HDTV
also features a wider 16:9 aspect ratio format that more closely resembles human
peripheral vision than the 4:3 aspect ratio used by conventional TVs in the
past. Furthermore, HDTV is based on a system of 3 primary image signal
components rather than a single composite signal, thus eliminating the need for
signal encoding and decoding processes that can degrade image quality. Perhaps
the biggest advantage over the old analog SDTV system is that HDTV is an
inherently digital system.

### 4K resolution

In 1984, Hitachi released the CMOS (complementary metal–oxide–semiconductor)
graphics processor ARTC HD63484, which was capable of displaying up to 4K
resolution when in monochrome mode. The first displays capable of displaying 4K
content appeared in 2001, as the IBM T220/T221 LCD monitors[^4]. 

### 8K resolution

Just like with HDTV, Japan's public broadcaster, NHK, was the first to start
research and development of 8K resolution in 1995. The format was standardized
in October 2007 and the interface was standardized in August 2010 and
recommended as the international standard for television in 2012. The world's
first 8K television was unveiled by Sharp at the Consumer Electronics Show (CES)
in 2012[^5]. Screenings of 2014 Winter Olympics in Sochi and the FIFA World Cup in
Brazil in June 2014 were done in 8K[^6].

While there was a huge gap in time between HD and 4K televisions, HDTV continued
to get better and better during those years. It is not like the industry was
stagnant, there were more improved and better HDTVs made. It might be fun to
take a bet that pixel density will double in size every ten years, but that is
just being presumptuous.

## What does this mean for bandwidth?

While it is fun to stick a finger in the air and try to estimate future pixel
density growth, there is another point I want to make. If the next wave of
consumer televisions is 8K what does that mean for streaming? Surely, this must
have an effect on bandwidth. 

For streaming HD, most providers recommend about 10mbps. For streaming 4K,
providers recommend 25mbps. For streaming 8K, providers recommend 100mbps. This
comes from the fact that 8K televisions have a frame rate of 120fps (frames per
second). This is in contrast to 4K televisions that have a frame rate of either
30fps or 60fps. It’s also important to note, this doesn’t take into account that
typically multiple devices on a network share the same bandwidth, so if your TV
needs 100mbps, it is going to be shared between a computer, iPad, multiple
phones, IoT devices, and whatever else is on your network. Typically you would
want a multiple of the recommended speed so you can have multiple devices
connected at the same time.

Let’s take a look at the average network speed. According to a report[^7] by
speedtest.net in 2018[^8], the average network download speed in the United States
was 96.25[^9]. In the United Kingdom, the average network download speed was 50.16[^10].
In Spain, the average network download speed was 60.12[^11]. The United States seems
to be the highest overall, but is still not cutting it for 8K streaming.

If we know that the pixel density of televisions is only going to increase over
time, causing streaming services to need more bandwidth, why are we not seeing
a bunch of fiber being laid down or other innovations to get faster internet to
the mass market?[^12] 

The problem with the Google Fiber project was what is known as the “last mile”
problem. The “last mile” is the last bit of cable to get the connection to your
home or business, these are known as drop cables. Most folks have existing cable
lines running to their home, which leaves fiber providers deciding between using
those existing lines causing a decrease in speed or laying new fiber lines which
is very expensive. Google Fiber chose the latter and it paid for that decision.
The solution to the “last mile” problem might be wireless, which leads us to the
current innovations with satellites.

## What about satellites?

Startups like Astranis[^13] claim to be able to provide broadband internet to the
masses through satellites. Astranis’ first satellite will offer 7.5 gigabits per
second of capacity for Pacific Dataport to use[^14]. Elon’s Starlink[^15] has the same
ambitious mission. Starlink claims they will offer plans to consumers with
speeds up to a gigabit per second[^16]. 

While most of the world is spending time at home, video chatting and streaming
services have become a household essential. As the world continues to move from
physical to digital at a rapid pace, we should see high bandwidth internet take
a front and center role. As someone who has wanted the dream of fiber, super
fast internet for everyone, I can’t wait to see what comes of this. Whether by
fiber or satellite, I hope we can reach massive bandwidth speeds across the
world.

[^1]: https://bebusinessed.com/history/history-of-the-television/
[^2]: https://www.britannica.com/technology/standard-definition-television
[^3]: https://ecee.colorado.edu/~ecen4242/marko/TV_History/related%20standards/HDTV_Past.htm
[^4]: https://en.wikipedia.org/wiki/4K_resolution
[^5]: https://www.businesstoday.in/technology/launch/ces-2013-sharp-showcases-worlds-first-8k-tv/story/191438.html
[^6]: https://en.wikipedia.org/wiki/8K_resolution
[^7]: It’s definitely worth understanding _why_ these numbers are so low. It is hard to know from just the data. It might be overall network capacity or possibly the network backbone is at capacity while the “last mile” is not. The former could be solved by more capacity as noted throughout this article, but the latter could be solved by more and better CDNs. Thanks to Alex Rasmussen for pointing this out!
[^8]: I tried to find more recent numbers that were not from a sketchy source and couldn’t, would love if anyone knows of any.
[^9]: https://www.speedtest.net/reports/united-states/2018/#fixed
[^10]: https://www.speedtest.net/reports/united-kingdom/#fixed
[^11]: https://www.speedtest.net/reports/spain/#fixed
[^12]: Another great question is _if_ consumers had 100mbps, would their (typically shitty) wifi setups even let them reap the benefits? Thanks to Scott Andreas for that great question!
[^13]: https://www.astranis.com
[^14]: https://spacenews.com/astranis-will-share-a-falcon-9-for-2020-small-geo-launch/
[^15]: https://www.space.com/spacex-starlink-satellites.html
[^16]: https://www.fastcompany.com/90458407/spacex-satellite-broadband
