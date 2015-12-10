+++
date = "2015-10-02T11:47:47-07:00"
title = "Cgroups all the way down"
author = "Jessica Frazelle"
description = "How to prevent decompression bomb attacks with control groups and containers."
draft = true
+++

I went to a meetup recently where a talk was given by Cara Marie of the NCC
Group. She talked about decompression bombs and the various compression
algorithms that can create these malicious artifacts. You might be familiar
with Russ Cox's post [Zip Files All The Way Down](http://research.swtch.com/zip),
which goes over self-reproducing zip files. However most programs will not
decompress the files fromm his blog post recursively. Which just leaves us with
the problem of the _more sofisticated_ decompression bomb.

During the talk, I couldn't help but think about how we recently got a pull
request to [Add support for blkio read/write bps device](https://github.com/docker/docker/pull/14466/files).
Granted, this does not control disk space utilization, **BUT** it does allow
for throttling the upper limit on write/read to the device.

Let me give an example of how this works.

```
# lets set read-bps-device to 1MB/second
# this will set a limit on the bandwidth rate of that device
# to 1MB/second
$ docker run --rm -it --read-bps-device /dev/zero:1mb debian:jessie bash

# now we are in the container, lets test that the cgroup is working correctly
$ dd if=/dev/zero of=/dev/null bs=4K count=1024 iflag=direct
1024+0 records in
1024+0 records out
4194304 bytes (4.2 MB) copied, 4.0001 s, 1.0 MB/s

# pretty cool right?
```
