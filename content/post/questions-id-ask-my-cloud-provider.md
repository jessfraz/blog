+++
date = "2019-04-15T08:09:26-07:00"
title = "Questions I'd Ask My Cloud Provider"
author = "Jessica Frazelle"
description = "A list of questions I'd ask my cloud provider."
+++

I came up with a list of questions I would ask my cloud provider if I was
buying a product. They are as follows:

1. What problem is this solving?

I would ask this to make sure I even need this product. So many people tend to
buy into the hype for "shiny", they miss if they even needed the thing in the
first place.

2. How did _you_ implement this? What is _your_ threat model?

So much of the cloud is built on popsicle sticks and glue. Does that make you
feel safe at night knowing your customer data is being stored in a proof of
concept that was shipped before it should have been? Best to get your security
team to assess if the product is actually built on the _providers side_ up to
standard. This does not mean what you see as a customer, it means the
proprietary bits you cannot see.

What does the service license agreement say for what happens if the provider
themselves is hacked? Do they have to tell you or can they just sweep it under
the rug? What if a vulnerability comes out on the open source project they are
using, do they have to give you a risk assessment as to if you were hacked?

What if they don't know if they were hacked after a vulnerability is public? 
Red flag...

If they themselves do not know their own threat model, that should be a huge
warning sign. 

Bonus points if their implementation is open source; but I will let you in on
a secret, most aren't. The exception is Joyent :)

3. What customers did you speak to before building this feature?

Ties back to number one, what problem is this solving? So often these features
seem to be built _for fun_ or based off a _feeling_ a product manager had.

Hope this helps! I will probably update over time. :)
