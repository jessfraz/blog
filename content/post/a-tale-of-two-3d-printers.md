+++
date = "2020-06-10T08:09:26-07:00"
title = "A tale of two 3D printers"
author = "Jessica Frazelle"
description = "Comparing the MakerBot Replicator+ to a Form Labs Form 3."
draft = true
+++

I have wanted a 3D printer for a very long time. I had been keeping my eyes on
the product space for quite some time. When I finally decided to get one
I couldn't decide. So I ended up getting two: 
the [MakerBot
Replicator+](https://www.makerbot.com/3d-printers/replicator-educators-edition/) and the
Form Labs [Form 3](https://formlabs.com/3d-printers/form-3). I figured I would
try them both then donate the one I liked less to a nearby school.

I'm going to go over my decision for choosing both of these printers as well as
my experience using both of them. One thing I want to make clear up front is
I was looking for a 3D printer _product_. I say product because I wanted
something that was easy to setup, easy to use, and had a fully integrated
experience between the hardware and the software. I don't want to have to debug
my 3D printer when something goes wrong and I don't want to have to finagle
a bunch of software with bash, popsicle sticks, and glue just to get it to work.
I want a _product_.

## MakerBot Replicator+

I chose this printer mainly because it is a classic. MakerBot has a great
community with [Thingiverse](https://thingiverse.com) and they have been around
since 2009 so I figured in 11 years of experience with products they should have
hopefully nailed it by now. I did some research and realized MakerBot has an
iPad app and that I could print any design from Thingiverse directly from my
iPad. This was super appealing to me! I can print any community design or my
own custom designs super easily as long as I upload them to Thingiverse, sweet!

This 3D printer arrived first so it was my first experience with 3D printer
other than when I have messed around with someone else's. I installed the iPad
app and got started setting up the printer. You can see a picture of it below.

![makerbot](/img/makerbot.png)

### Adding the network

If you have ever bought an IoT device you might be familiar with the setup
workflow of joining the devices network on your mobile device and then
configuring the main network to be your WiFi network. This is the same setup
process as the MakerBot. The iOS app leaves a bit to be desired. I just feels
clunky, it is not really snappy and is pretty slow. Kinda feels like what
I would expect an app written by devs with hardware expertise, rather than
software expertise, would feel like. Setting up the network failed for me
numerous times from my iPad so I instead decided to try an old defunct Android
phone instead. Again, the Android app felt clunky and non-native. It even asked me to go into my Android settings and grant more permissions to the app versus just prompting me for permissions... but finally this setup worked! Now my printer showed up in my account on
the Android device and I could get through the setup process.

Being used to the cloud, I expected my printer would just appear on my iPad app
now since I was logged in. It did not. I had to manually enter the printers IP
address on my local network. That seemed like an unnecessary step, my MakerBot
account should have stored that information and synced it to my other devices
after I completed the setup on my initial device. But I digress. At least now
I could complete my dream of printing designs directly from my iPad. I use
[Shapr3D](https://www.shapr3d.com) on my iPad to design so this is super convenient.

I printed the initial test print and calibrated the device. You can see the
result of the initial test print in the image below.

![makerbot-initial-test-print](/img/makerbot-initial-test-print.png)

I then printed a battery holder, you can see the result in the image below.
This took about 11 hours. It's important to note the time because later we will
compare it to the Form 3 time.

![makerbot-battery-holder](/img/makerbot-battery-holder.png)

This was not a great result and not super clean like I anticipated. I recalibrated the machine again to print some more thinking that might help.

I printed a 9V battery holder, you can see the result below. This took about
3 hours.

![makerbot-9V](/img/makerbot-9V.png)

This one was a bit cleaner. But still not great. You will notice all of these
are in the grey filament, this was only because it was the first color to
arrive, not by choice.

I then printed some rocket cookie cutters. These took about [TODO fill this in].
You can see the result below.

![makerbot-cookie-cutters](/img/makerbot-cookie-cutters.png)

These came out a bit better but still not as great as I would hope. At this
point, I was pretty bored of the MakerBot and decided to wait for the Form 3.

## Form 3

When the Form 3 arrived, I was thinking wow this is complex. Versus the single
boxed MakerBot, the Form 3 came in 4 separate boxes. I realized after opening
this was because I got the printer, the [Form Wash](https://formlabs.com/wash-cure/), and the [Form Cure](https://formlabs.com/wash-cure/) as well as a few different resins.

## Resin vs. Filament

Most 3D printers use filament like the MakerBot but the Form Labs printers use
resin. This was why I wanted to try both these machines. Filament seems to have
been a kinda defacto standard in the 3D printing industry from what I could
tell, so for Form Labs to break this mold would mean they knew something
everyone else did not. I was curious to find out if their way was better than
filament.

With filament, the printer works almost like an ink jet printer in that it adds
more filament to a design gradually building it from the bottom to the top. With
resin, the liquid resin fills what is called a "tank" and from here the build 

- Talk about SLS https://formlabs.com/blog/what-is-selective-laser-sintering/
- SLS versus SLA https://www.plunkettassociates.co.uk/faqs/plastic-parts/what-are-the-differences-between-sla-and-sls.php
- SLS versus FDM https://blog.trimech.com/sls-vs-fdm-technology-review
- SLS versus FDM https://formlabs.com/blog/fdm-vs-sla-vs-sls-how-to-choose-the-right-3d-printing-technology/
