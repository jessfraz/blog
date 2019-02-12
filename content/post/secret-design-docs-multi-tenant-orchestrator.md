+++
date = "2019-02-12T08:09:26-07:00"
title = "Secret Design Docs: Multi-Tenant Orchestrator"
author = "Jessica Frazelle"
description = "A design doc from my personal archive detailing a general case muti-tenant container orchestrator."
+++

I thought it would be fun to start a blog post series containing design docs from my personal archive that never saw the light of day. This will be the first of the series. It contains what I thought about in detail for a general multi-tenant secured container orchestrator. The use case would be for running third party code securely isolated from each other. If you would like to see this in google doc form it also lives [here](https://docs.google.com/document/d/1qDcDuahakVWSQaJR5tixpNTUFbHIF0DNxFKfI_gwF0I).

## Requirements

### Base

- API to run docker images in such a way that each process is isolated entirely from all the others.
- Abusive actions can be terminated immediately.
- The agent should be auto-updateable to handle security issues as they arise.
- Ability to use the entire syscall interface for the processes being run.

### Other Features

- Disallow and kill any and all bitcoin miners from using the infrastructure
- Firewall off any existing network endpoints
- Firewall off the container running the process from everything around it on the local links and any reachable internal IP
- If one layer of isolation is compromised, rely on another layer of isolation entirely. If two layers are compromised then we at least tried our best...

## Design
The host OS and up needs to be secure.

### Overview
We require the following per container running:

- Block/io cgroups so that disk does not have noisy neighbors
- CPU limit
- Memory limit
- Network/bandwidth limiting
- Isolated network from everything else on the network (bpf or iptables)

### Host OS
The host OS should be a reduced  operating system, minimal distribution (though possibly shared with the OS used inside containers). This is for reasons of security in locking down the available weaknesses in the host environment and lessening the control plane attack surface. 

#### Operating Systems
Examples of these Operating Systems include:

- CoreOS Container Linux
- Container Optimized OS
- Intel Clear Linux
- LinuxKit

##### Features
CoreOS Container Linux and Container Optimized OS both the following have the features:

- Verified boot
- Read-only /usr
  - Container Optimized OS has root filesystem ("/") mounted as read-only  with some portions of it re-mounted as writable, as follows: 
    - `/tmp`, `/run`, `/media`, `/mnt/disks` and `/var/lib/cloud` are all mounted using tmpfs and, while they are writable, their contents are not preserved between reboots.
    - Directories `/mnt/stateful/partition`, `/var` and `/home` are mounted from a stateful disk partition, which means these locations can be used to store data that persists across reboots. For example, Docker's working directory `/var/lib/docker` is stateful across reboots.
    - Among the writable locations, only `/var/lib/docker` and `/var/lib/cloud` are mounted as "executable" (i.e. without the noexec mount flag)
  - CoreOS Container Linux has root filesystem (`/`) mounted as read_write and `/usr` is read-only.

All the operating systems allow seamless upgrades for security issues.

### Container Runtime
The container runtime should be a hypervisor to make sure user configurations of Linux containers do not diminish the security of the cluster. 

#### Why not containers?

It should not go without saying that is is possible to have multi-tenancy with containers as is proven with [contained.af](https://contained.af) that no one has managed to break out of. 

To be allowed to use the entire syscall interface though ([my ACM Queue Research for Practice article](https://queue.acm.org/detail.cfm?id=3301253)), [Firecracker](https://firecracker-microvm.github.io/) seems like the right fit. 

Just using containerd out of the box as a base and building on that should be perfect :)

### Network

The network should be locked down by default with a deny all policy for Ingress and Egress. This will create a form of security that makes sure all networking between pods or to the rest of the world is explicit.

This could be done with iptables or directly with BPF (which in my opinion is way more clean).

### DNS

Do not allow any inter-cluster DNS.

### No Scheduling on Master and System Nodes

Make sure that the master and system nodes in the cluster cannot be scheduled on. 

This allows a separation of concerns from system processes to anything else.

#### The Scheduler

The scheduler should **not** do bin packing. Seen this fail in a lot of scenarios with transient workloads where the first few nodes get burned out while all the other nodes are not being used. Because the workloads are constantly completing freeing up resources on those first few nodes (in the case of batch jobs).

There is knowledge in: [kube-batch scheduler](https://github.com/kubernetes-sigs/kube-batch). It is built on years of experience from HPC clusters at IBM. We can use the same type of logic. This is more meant for batch jobs though so if we plan on supporting long term applications we would need to modify.

We should also account for proximity to the docker image being pulled. The largest constraint on time for running a container is pulling an image so let’s optimize for making that as short as possible.

If we are running on bare metal we need to account for power management, BIOS updates, hardware failures and more. These are all things the orchestration tools of today completely ignore.

### Resource Constraints

Manage resources and set limits with cgroups.

- Disk IO
- Network Bandwidth
- Memory
- CPU

## Other

### Why not kubernetes?

I’m super pragmatic about these things and don’t want to reinvent the world for nothing but I have now seen this go terribly wrong, as in people turning off firewalls accidentally…. And I don’t want the security of something that allows arbitrary code execution to have only one layer of security which someone might inevitably turn off by accident.

We don’t need 90% of the features of kubernetes.

Kubernetes is hard to secure… there are a lot of components and there is no isolation between etcd and the kubelet to apiserver communication cannot be isolated either. 

I wrote a blog post on secure k8s and we are a long ways off. It’s too complex and has too many third party drivers. 
([my hard multi-tenancy in kubernetes blog post](https://blog.jessfraz.com/post/hard-multi-tenancy-in-kubernetes/)). All in all thought the surface area is just too big and we don’t need all the feature set anyways. 

By keeping our implementation more simple it is easier to keep track of the components communication and ensure it is secure. The surface area is WAYYY smaller. The only downside is we operational knowledge of k8s but the concepts and patterns are the same.

The biggest Kubernetes cluster is 5000 nodes and they hit a lot of issues: [blog.openai.com/scaling-kubernetes-to-2500-nodes/](https://blog.openai.com/scaling-kubernetes-to-2500-nodes/). We might need a different key value store and multiple clusters. And like I noted above I would not be confident considering it “secure”.

Kubernetes will by default schedule at most 110 pods per node. This is something you can change but it is also important to note that the default scheduler in kubernetes is extremely not resource aware and we would have to fix that as well. See above in “[The Scheduler.](#the-scheduler)” And the first few nodes in a cluster get burned through quickly due to the logic of the default scheduler.

Even Google doesn’t use Kubernetes internally to schedule VMs, that is a whole separate thing. 

Kubernetes inserts a bunch of extra env variables into the containers we would have to take care of as well… as seen here: [Kubernetes Hard Multi-Tenancy Design Doc](https://docs.google.com/document/d/1PjlsBmZw6Jb3XZeVyZ0781m6PV7-nSUvQrwObkvz7jg/edit).

### What do we do if there is a kernel 0day that effects the isolation?

For one, update the kernel, but if that is not possible we can trap the kernel function that is vulnerable using ebpf and kill any container trying to exploit the vulnerability. This has a trade off of jobs failing but we can try to get it as close as possible to have no false positives.

This assumes we have systems in place to continually build kernels and apply patches.

### How secure is this?
Well let’s think about the threat model. Mostly it would be someone attacking our infrastructure itself so we should make sure all these servers are isolated on the network from the rest of the stack.

The next threat would be the users code and secrets that we are running. After breaking out of a container it would leave the hacker still in the firecracker VM so they will still need to break out of the VM. This would be the case in the event of a container runtime bug.

#### Monitoring, monitoring, monitoring.

We should detect using eBPF or otherwise any rogue process on the host that is not that of our containers or of our agents_infrastructure and kill_alert immediately.

Any file that is touched that is outside the scope of the given container should have the container killed and alerted on.

Additionally we can even hide the fact that it is running in a specific container runtime etc. So there is less knowledge of the environment, unless of course they read this doc.
