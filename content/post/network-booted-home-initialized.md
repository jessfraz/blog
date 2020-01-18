+++
date = "2020-01-17T11:25:24-04:00"
title = "Network booted, home initialized"
author = "Jessica Frazelle"
description = "An overview of building out our office space."
+++

I had a lot of fun writing blog posts in the past about my 
[home lab](https://blog.jessfraz.com/post/home-lab-is-the-dopest-lab/)
and some of my 
[personal infrastructure](https://blog.jessfraz.com/post/personal-infrastructure/)
so I thought I would do the same as we built out our office. Much like moving
into a new place, the first thing I always plan to have setup on move-in day is
internet. We did the same with our office as well. Before we even had any
real furniture, we made sure that we had a network connection.

![picture before we had furniture](/img/empty-office.jpg)

For the office I really wanted our network infrastructure to be off-the-charts
good. Everyone knows shitty internet is a productivity _killer_. Since I use
UniFi for my network setup at home, we used the same for the office.

Here's what we got:

- [48 Port Switch](https://store.ui.com/collections/routing-switching/products/usw-pro-48-poe)
- [Dream Machine](https://store.ui.com/products/unifi-dream-machine)
- [2 Wifi APs](https://store.ui.com/collections/wireless/products/unifi-ap-ac-shd)
- [A couple of cameras](https://store.ui.com/collections/surveillance/products/unifi-protect-g4-pro-camera)
- [Amplifi Alien](https://store.amplifi.com/products/amplifi-alien)

## The Switch

We have a hard line coming from the 48 port switch to each section of desks.
I cabled all this myself. As we grow we will likely segment this off to each
desk having its own little 4- or 8-port network switch but for now this works.

### The Cables

All the cables running to the desks are Cat7s from Monoprice. Every type of 
cable has a maximum distance. For ethernet cables, the maximum distance is the
maximum upload/download speed. Cat7 gets praised for its 100 Gbps speed, 
but that will only work for distances up to 15 meters (slightly over 49 feet).
From 15 meters up to 50 meters, a Cat7 cable downgrades to 40 Gbps.
Beyond that, it drops to the same 10 Gbps speed of Cat6 and Cat6a, however it 
still retains its superior 600 Mhz bandwidth. We use 100ft cables to the desks
and 50ft cables wherever we can reach to maximize speed.

![picture of cabling](/img/cabling.jpg)

## The Router 

The Dream Machine is acting as our gateway and controller. Before we got the
other 2 APs, it was our only access point and did a great job of that.

### The Access Points

We have a large warehouse with a lot of square feet, while the Dream Machine
does have coverage to every corner, it's nice to have a strong signal from
anywhere in the office. As we grow we will have more and more devices on
our network, so having some other APs to handle that load is necessary.

## The Cameras

The cameras will be installed outside our office so we can see what is going on
when we are not there. This is mainly for security.

## The Isolated Network Router

Lastly, is the AmpliFi Alien. Since AmpliFi is not a part of
the rest of the UniFi fleet, it exposes its own network. I foresee
this becoming the network for our lab equipment or anything we don't want on
the main network. It's a very, very nice secondary network that is fully
isolated with Wi-Fi 6 capabilities and a max speed of 4804 Mbps. If only all 
devices supported Wi-Fi 6!

It's been fun to build out the network infrastructure in our office and make
sure it scales while we scale out the team. We have hired some of
the brightest folks that I am happy to call coworkers.  This is just one very 
small detail of our startup journey, but I am glad I got to share it. Our
previously empty office is now one with 20 desks, 2 kitchen tables and a 
large, cozy couch area with whiteboards for brainstorming. Can't wait to see 
what the future brings!

![picure of office now](/img/office-jan.jpg)
