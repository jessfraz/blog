+++
date = "2016-09-17T08:09:26-07:00"
title = "Blurred Lines"
author = "Jessica Frazelle"
description = "The intricacies of 'choosing your battle' and how personal passion for a project might conflict with corporate motives."
+++

Last week, I gave a talk at [Github Universe](http://githubuniverse.com/program/sessions/#blurry-lines)
and afterwards several people suggested I write a blog post on it. Here it
is. This post will cover intricacies of "choosing your battle" and how personal
passion for a project might conflict with corporate motives.

I have experienced open source from the side of the contributor,
the side of the maintainer,
and the side of the corporate-backed maintainer and contributor. The latter is
what really comes into play here but a lot of the passion I talk about is
obviously present in the former and of course important for empathy for those
on the other side.

## Passion

Passion is a driving force behind involvement in open source software. People
who believe in a project and use it are the ones who contribute and give back
most heavily. Open source is this rare opportunity to work with people who want
to achieve the same things as you.

If you have contributed to an open source project before, you know that feeling
when your first pull request to a project is merged. It is magical. In that
moment you have become a part of something so much bigger than yourself.

### What happens to this fiery passion when it is fueled by a paycheck from a company?

This is where things get complicated. When should you fight? When should you
compromise?

The goal of this post is to show that you can stand up for what you believe in
and keep your job. Getting paid to work on open source is a rare and wonderful
opportunity, but you should not have to give up your passion in the process.
Your passion should be _why_ companies want to pay you.

## Lessons Learned

In my talk (which I will link to the video when it comes out), I told a brief
history of how we evolved the Docker core team during my time there. We even
had three different names: core, meta, engine (yet kept the same team members
the entire time). I'm not going to go over all those stories so I suggest you
checkout the video, but these are the lessons we learned.

### Hire from the community.

Previous to joining Docker I had used Docker, given talks on Docker, and
contributed to the project. The startup I worked at previously built it's
infrastructure around Docker. All members of the Docker core team were a part
of the community before joining. This is important.

When you are a member of a community you feel surrounded by your peers being
a part of it. And this includes all members outside the company. Your passion
for the project will and _should_ always come first. You may get paid by the
company but you will protect the project at all costs, because at the end of
the day, the project and the community were what you were a part of first.

You cannot hire everyone from the community. Then the trust for the project and
any further growth to the community is effectively ruined.

### Maintainership for a project must be earned.

When an employee joins your company they should not automatically get push
access to the project. I almost feel like I should repeat this because it is SO
important to building trust with the community. **Everyone must play by the
same rules.** EVERYONE.

The Docker project collects stats on just about everything using
[github.com/icecrime/vossibility-stack](https://github.com/icecrime/vossibility-stack).
Whether you are contributing code, contributing documentation, commenting on
issues, or doing code reviews you are eligible to become a maintainer after
regular activity.

This is key because this eliminates the "it's all about who you know scenario."
Without hard data of contributions there is no way to be sure you are not
overlooking some amazing gem in your project that should be rewarded for their
hard work.

### Allow saying NO.

A very common conflict that will occur is one between other teams in the
company and your "core" team. The company will have a feature they want to
push, which perhaps lands as a patch bomb right before a release, has no tests,
and has pockets of code relying on a service not even in production yet. They will
just expect this to be merged.

Now of course, your open source team will fight it. They will stand up for the
project. Maybe some members will eventually cave but others will still keep on
fighting. It will cause stress and fear of being terminated. It will also cause
turmoil between these teams internally which creates an awkward work
environment.

There are a few things you can do to avoid this, the first one being: allow
saying NO. Even from external maintainers, since as I said EVERYONE plays by
the same rules, allow saying NO.

### Create explicit guidelines for acceptable patches & release cutoffs.

By creating explicit guidelines you now make sure that everyone plays by these
same rules. People outside the company cannot send a patch bomb
without tests right before a release and neither can those internally. Of
course you can make whatever rules you want, as long as everyone plays by them.

When everyone plays by the same rules, your community will trust you
the most.

### LGTM lasts forever.

When you LGTM a pull request it is there forever, publicly. You can of course
change your mind and revert. But the second that feature gets into
a release, it will take a _very_ long time to depreciate it out if you feel like
you made the wrong decision. Someone will wind up relying on it and removing it
will become a bikeshed only leading to community disagreement.

### LGTM is tied to the individual who said it.

You cannot get a LGTM from a corporation, you get it from an individual. I have
never seen a company with a GitHub account going around doing code reviews.
People do code reviews.

If someone comes back to some feature down the road, they can
see who approved it. It reflects on that person, not on their company.
They will make sure they really mean it before they say it.

### Collaboration and compromise is key.

Do not isolate your "core" team from the rest of the company. Isolation will only
create a non-inviting atmosphere to work in.

You are all on the same team, you can find a way to work together and compromise
to benefit both the company AND the community.

## Go and succeed!

If you are thinking about open sourcing a project at your company, try to keep
these things in mind! It's never easy and there will always be some friction,
but the benefits of creating a great open source project and community will pay off!
Most of all **LISTEN** to the people at your company with the passion for the
project.
