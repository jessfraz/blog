+++
date = "2020-04-18T06:09:26-07:00"
title = "The Art of Automation"
author = "Jessica Frazelle"
description = "An article focused on why automation boosts productivity, some examples of my personal automations, and a look at products built to bring the power of scripting to the consumer market."
+++

I am unsure if my love of automation comes from a dislike of doing the same thing twice or an overall desire to be more productive and make everything more efficient. Like a lot of programmers, I often ask myself “can this be scripted” when I find myself doing a manual task.

I was inspired recently by reading Wolfram’s writing on his personal infrastructure for productivity[^1]. I, too, have written about my personal infrastructure[^2], but not at the level of depth or with the same focus on productivity as Wolfram. There is no time like the present to take another swing at it! 

Not only do I want to touch on some of the ways I have automated tasks in my life, I also want to spend some time unpacking how common automation patterns are starting to appear in a lot of things people use day to day. Apple’s Shortcuts, home automation, and IFTTT make automation patterns available to the masses in a way that is unprecedented. Before diving into the details, let’s first answer the question of why.

## Why automate?

Time is one of the most valuable resources in the world. If there was something you could do to free more time for yourself, why wouldn’t you? When I automate myself out of a task I transfer the burden of doing said task to some other script, service, API, or a combination of all of these. 

I, personally, feel at my best and most productive when I am building something, solving a problem, or learning something new. In none of those situations does that include “doing something manual that could otherwise be scripted/automated away.” Or when it does… I automate it away. In any circumstance when I find myself in a position to automate something, I will automate it. Especially if I consider the time spent automating the task to be less than any time spent in the future doing the task manually. This is the ultimate pay off: time.

I like to think of automation as the following equation.

$$
\begin{equation}
time gained =  (time doing the task manually) - (time to automate the task)
\end{equation}
$$

It’s important to note that in the equation above, the time to automate the task also includes any future bugs you might have to fix in the automation itself.

By automating tasks, I can focus my time on doing the things where I feel at my best and most productive while at the same time being more efficient and getting more done.

## Some recent automations

For myself, when I automate things, I tend to start by making it work and then making it pretty. In our equation above, the goal is to keep the time automating the task to a minimum. By getting the thing to work first without wasting time on making it pretty, I find I can gain the most time and be most productive. Cleaning up whatever mess I made with scripts or APIs after is a lot easier and faster after you get it to work. You can imagine that most of my automations start out looking like a Rube Goldberg machine. Let’s dive into some of the most recent things I have automated. 

### On-boarding new hires

For our startup, we have been hiring quite a bit quickly. I wanted to make sure our on-boarding process was streamlined and consistent. Adding new folks to GSuite, Zoom, and GitHub teams manually is a huge waste of time and doing it manually tends to lead to human error. I automated on-boarding new folks into all our tools with a Rust script. This was also a nice excuse for me to tinker with the Rust programming language. 

Now when folks join the company, they get added to a config file which then automatically sets up an email account in GSuite, creates them a Zoom account, adds them to all the right GitHub teams, and then sends an email to them outlining all the tools and their accounts. It’s been improved with every new hire’s feedback as well, which makes it even better.

### Newsletter RSS feeds

Another thing I recently automated was clearing out all the newsletters I get to my email inbox everyday. Most of these are subscriptions to people’s blogs, like The Morning Paper[^3]. Since most of these are actually RSS feeds, I instead now pipe the RSS feed updates to Pocket[^4]. This way everyday I can check Pocket for my list of things to read versus my email inbox being used for that. I found that when these newsletters were going to my inbox, I never actually read them since I tend to use my inbox as a TODO list and I would archive the newsletters right away since they aren’t a priority. Now, I keep my inbox clear of clutter _and_ actually have a place for storing things I want to read later.

### Gmail filters

Speaking of email inboxes… I am an absolute stickler about Gmail filters. At the time of writing this article, I have 72 different filters. I constantly improve my labeling and automatic archiving of emails through a configuration file. This management system is a little Go tool I made for Gmail filters called gmailfilters[^5]. For mailing lists, I tend to archive the messages unless they are sent directly to me, whether in `cc` or `to`. This keeps my inbox clean, while also making sure each mailing list gets sorted into its own Gmail label so I can easily view all the messages if I need to. By maintaining Gmail filters in a configuration file, versus the user interface, I save a bunch of time trying to find the filter I want to edit, editing it, and saving it. Also, if I make a mistake and want to revert it, I now have a git history of past filters, so this is as simple as `git revert`.

These are just a few of the things I automate for my day to day life. If you are interested in more of these, please refer to my original posts on my personal infrastructure[^6]. As developers, automation is not a new concept, we tend to deal with the patterns of automation day to day through continuous integration (CI) and continuous delivery (CD). For the rest of the world, it is interesting to see the patterns of automation are starting to play a role in consumer products.

## Automation for the masses

### Apple Shortcuts

Recently, I switched back to an iPhone and got an iPad. I was delighted to play with the new “Shortcuts” feature. A Shortcut allows users to do multiple tasks and streamline them together into one action. For example, you could create a shortcut that on your commute home from the office: gets the latest traffic report, plays your favorite new podcast on the drive home, then turns on your lights when you get home (assuming you have smart lights). You can build anything you like depending on the apps you have installed and your preferences. It’s really quite extensible, while also being approachable by the mass market of iPhone adopters.

### Home automation

Speaking of lights that can automatically turn on, home automation is another way that wider audiences can create automation patterns for themselves. Between Google Home, Apple’s Homekit, and Amazon Alexa adoption, more and more folks are seeing the power that technology can unleash and time saved by automating everyday tasks. Most of these devices have a concept of creating and using “routines” to chain multiple tasks together. For example, when I leave the house, turn off all the lights, set the temperature so the AC is no longer running, and turn on the security system. This user experience and ease of use enables consumers to boost their productivity and save time in the same way a developer would through programming and scripting. 

There is, of course, a darker side to IoT devices if consumers are uneducated. Whether it’s your lightbulbs, thermostat, home security system, or refrigerator, it is important to research the security of the IoT devices you buy.

### IFTTT

If-this-then-that ([IFTTT](https://ifttt.com/)) has been around for quite some time, but I wanted to take the time to call it out as an early way that automation was brought to a larger audience without people having to program. IFTTT clones are a dime a dozen now. There is [Zapier](https://zapier.com/home), [Huginn](https://github.com/huginn/huginn), and [automate.io](https://automate.io/), just to name a few. All these products have one thing in common: promoting personal productivity through combining and chaining various tasks together into a single, automated workflow.

## Productivity progress

I am glad that the patterns of automation have started to make their way mainstream so that mass market consumers can see the same productivity gains without programming that developers achieve through scripting. The user interface might be different but the goal is the same: saving time and eliminating the need to do manual tasks repeatedly. I hope in the future we continue to see easier and more creative ways to automate while granting the same automation superpowers to everyone, not just programmers. The feeling developers get after writing a script to make their life easier should not be exclusive.


[^1]: https://writings.stephenwolfram.com/2019/02/seeking-the-productive-life-some-details-of-my-personal-infrastructure/
[^2]: https://blog.jessfraz.com/post/home-lab-is-the-dopest-lab/
[^3]: https://blog.acolyer.org/
[^4]: https://getpocket.com/
[^5]: https://github.com/jessfraz/gmailfilters
[^6]: https://blog.jessfraz.com/post/personal-infrastructure/
