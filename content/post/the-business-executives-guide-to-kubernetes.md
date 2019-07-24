+++
date = "2019-07-23T08:09:26-07:00"
title = "The Business Executive's Guide to Kubernetes"
author = "Jessica Frazelle"
description = "Some hard truths about Kubernetes and what it means for your business."
+++

Hello!

I thought it would be fun to write a post aimed towards business leaders making technology decisions for their
organizations. There is a lot of hype in our field and little truth behind the hype.

Like most things I write about, this started from an idea I had on Twitter:

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">has anyone ever done technical breakdowns of these products in Gartner reports that are actually just trash, is this something you&#39;d read..?</p>&mdash; jessie frazelle 👩🏼‍🚀 (@jessfraz) <a href="https://twitter.com/jessfraz/status/1153866738452221952?ref_src=twsrc%5Etfw">July 24, 2019</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

This post will cover some hard truths of Kubernetes and what it means for your organization and business. 
You might have heard the term "Kubernetes" and you might have been lead to believe that this will solve all the
infrastructure pain for your organization. There is some truth to that, which will not be the focus of this post. To get 
to the state of enlightment with Kubernetes, you need to first go through some hard challenges.
Let's dive in to some of these hard truths.

## Stateful Data is Hard

Kubernetes is not to be used for stateful data. There has been a lot of work done in this area
but it is still not sufficent. For the more technical members of our audience I direct you to 
[exhibit A](https://github.com/kubernetes/kubernetes/issues/67250). The linked issue goes over 
problems when a "StatefulSet" gets into an error during deploying or upgrading. This can lead to data 
loss or corruption since Kubernetes will need manual intervention
to fix the state of the deployment. This could even lead to the point where the only recommended fix is you _delete the state_. 
What does this mean for your business? Well, if you lose or corrupt your data it could mean a lot of different things depending
on what the data was. If the data was your customer database of new account signups, well you might have just lost the data for
your new customers. If you are an ecommerce site, it might have been your latest sale. If you are in banking or investments, 
it might have been data accounting for the movement of capital.

Databases holding valuable information like the examples above should always have mechanisms for replication which is not 
something Kubernetes is going to solve for you. While you might chose to use Kubernetes for stateful data, you should always remember
to handle replicating that data in case there is a failure.

## Exposed Dashboards

A lot of organizations are dipping their toes into Kubernetes but forgetting to disable or secure the dashboard for the control plane
from the rest of the internet. The control plane dashboard is a website you can navigate to that controls your cluster.
Leaving the dashboard exposed to the public can have huge implications on your business. If your dashboard is exposed, _anyone_
could find your dashboard and then control it. Finding an exposed dashboard is not that difficult if you know what you are looking for 
and have access to a site like [shodan](https://www.shodan.io/). 

What would the finder of the dashboard control? Everything running in Kubernetes. If your website is running in Kubernetes, it
means someone else could make your website go offline, someone else could replicate your website but send all sales and monetary 
transactions to their own bank account, someone else can breach your customers data, or someone else could hold your 
infrastructure up for ransom and not give you back control of your website 
unless you pay what they demand. This is just a few things I thought of off the top of my head but you could probably think of more. 

There is a whole other aspect of this in that if this breach goes public, then you have a huge public relations 
problem on your hand. Which for a public company might even have implications on your stock price 
if shareholders end up losing trust from the news of your company's technical incompetence and they decide to sell their shares.

If it's not the dashboard being exposed it might be your API server or another service. There's a few
options for this particular failure mode.

## Upgrading your Kubernetes version seems to always break something

I've heard from a bunch of people that whenever they need to upgrade their production environment of Kubernetes it always leads to something breaking.
It's recommended that you have [more than one cluster in production](https://twitter.com/kelseyhightower/status/1138586423978672129) for this very reason.
Then, if one cluster in production is broken from being upgraded, the other cluster that has not been upgraded is still running the technical parts of 
your business. This is very good from a reliability point of view. 
It means reaching your website has a "plan B" where if the "plan A" infrastructure has a problem, everything
will be redirected to "plan B" and your customers will not even know the difference. As a downside, your operations teams 
now have to figure out ways for managing and maintaining two clusters (more work for them) but your business is 
in a better place for it.

The other option is you just don't upgrade. However, if you don't upgrade, your infrastructure might be vulnerable to
security threats and then we are back in the situation above where you might have data breached by hackers, a hostile takeover of your
website, and then a huge public relations scandal leading to investors and shareholders selling their stock.

## Steep learning curve, complexity is king, and operational pain

A lot of the criticism I hear about Kubernetes is how complex it is. For your organization, this means
your staff are going to have to surmount this very steep learning curve. As with learning anything, things only
get worse before they get better. So get ready for a lot of production outages and failovers as your team starts to 
learn the ins and outs of this overly complex system. What does this mean for your website and customers? Availability will
be spotty for awhile but we hope _eventually_ it will even out. Lastly, to quote someone very wise (send a pull request if you know who!), "Hope is not a strategy."

## Managed Kubernetes

Now you are probably thinking, "my cloud provider said they'd take away all the pain you just described by selling 
me their managed Kubernetes." That is indeed the dream. However, it is not reality. Having worked for some cloud providers,
I have seen the pain customers still go through trying to learn the patterns Kubernetes implements and applying 
those patterns to their existing applications. This means your teams will still have to handle the steep learning curve. Just
because it's managed does not mean that your application's uptime and availibility are covered. That is still on _your_ team.
Customers being able to use your website on the internet is your team's responsibility and understanding
Kubernetes is still required for that. For every line of YAML written and debugged to get your website running, it is time
that is being taken away from building on what your business actually does. Unless of course you are a business
of selling Kubernetes, then if so, carry on.

You will also want to be sure your cloud provider did not fall prey to the pitfalls I outlined above as well.
You should make sure your cluster is fully isolated from other customer's clusters. The way the managed Kubernetes offerings
work is by the cloud provider managing the "master" for your cluster. This means all the data for your cluster is managed by
your cloud provider. If your data is not properly isolated from all the other customer's data, it means that
if the cloud provider gets breached by means of a different customer's cluster then your data has been breached as well.
Then, we are in the scenario where a hacker owns your website, can hold it for ransom, or cause a very public incident
for your company that you will need to handle.

This was just a brief overview and I am not trying to throw shade. I merely wanted to phrase some of these prevalent problems
in a way that people running a business might be more aware of the impact adopting this technology might have. It should not be understated, if your organization does tackle these difficulties (and others I didn't mention), then you will possibly see
great impact on developer productivity, faster feature releases and deployments (among all the other wins Kubernetes can provide).
Just be aware that with the good, comes some bad.

