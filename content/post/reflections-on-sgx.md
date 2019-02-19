+++
date = "2019-02-19T13:16:52-04:00"
title = "Reflections on SGX"
author = "Jessica Frazelle"
description = "Reflections on my initial thoughts on Intel's SGX technology."
+++

I like to consider all the variables in a problem space before coming to a conclusion. As humans we have a tendency to jump to conclusions rather quickly. I try not to do this but everyone makes mistakes.

More information about Intel SGX was brought to my attention after my [initial blog post](https://blog.jessfraz.com/post/the-firmware-rabbit-hole/) on it. I’d like to take the time to go through that information and my current thoughts on the technology after having this extended context.

Trammel Hudson ([@qrs](https://twitter.com/qrs)) pointed out to me yesterday that SGX was originally built for the use case of DRM for Netflix, Microsoft, etc. Having this context makes the problems that arise when you try to do code execution inside an enclave seem like a forgivable sin. It was not until the [HAVEN paper](https://www.usenix.org/conference/osdi14/technical-sessions/presentation/baumann) that people even considered using enclaves as an execution environment. In that regard, the HAVEN paper was truly novel. I may disagree with shoving an entire operating system in there, but the idea of executing code in an environment with encrypted memory as a way to use the cloud without trusting the cloud is a respectable feat.

Another person who I truly respect and admire for the thought they put into what they build is Joanna Rutkowska ([@rootkovska](https://twitter.com/rootkovska)). She recently started working at [golem](https://golem.network/) a shared compute providing company focused on security and privacy. She wrote [an awesome blog post](https://blog.invisiblethings.org/2018/06/11/graphene-ng.html) considering all the tradeoffs of a technology such as SGX. The post links to other posts where she really weighs the pros and cons of the technology. This is why I really respect her thoughts on the matter. The solution is pretty cool in that you can run docker containers inside the enclave. It’s better than the SCONE paper, which also runs containers, in my opinion, because it doesn’t do the crazy syscall toss outside the enclave. It’s more aligned with the HAVEN paper in that it includes all the code inside the enclave. Her post is great; it really goes into detail on their thought process and what they designed their solution to prioritize.

Considering SGX was not built as an execution environment, I think it will be interesting to see where Intel takes this technology in the future now that people are using it as such. It will also be interesting to see how they solve the problems with side-channel attacks. Computing is all about tradeoffs. I learned from experience with everything I’ve worked on that people will use it for things it was not built for. This happened a lot with Docker. It’s always fun to see the new ways people use what you build and then to iterate considering the new use cases.

I value taking all contexts into consideration when thinking about a problem. I hope you all do the same. Hope you enjoyed my additional learnings and thoughts. Always be learning and open to new thoughts.

I'll be giving a talk on SGX at QCon London the first week of March :) hope to see some of you there.
