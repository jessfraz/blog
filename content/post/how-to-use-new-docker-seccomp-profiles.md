+++
date = "2016-01-04T23:21:07Z"
title = "How to use the new Docker Seccomp profiles"
author = "Jessica Frazelle"
description = "Debugging and creating custom seccomp profiles for Docker containers."
+++

In case you missed it, we recently merged a [default seccomp profile](https://github.com/moby/moby/pull/18979) for Docker
containers. I urge you to try out the default seccomp profile, mostly so we can
rest easy knowing the defaults are sane and your containers work as before.
You can download the master version of Docker Engine from
[master.dockerproject.org](https://master.dockerproject.org) or
[experimental.docker.com](https://experimental.docker.com).

We even have a doc describing the [syscalls we purposely block](https://github.com/jessfraz/docker/blob/52f32818df8bad647e4c331878fa44317e724939/docs/security/seccomp.md) and [security vulnerabilities the profile blocked]( https://github.com/jessfraz/docker/blob/6837cfc13cba842186a7261aa9bbd3a8755fd11e/docs/security/non-events.md).

But that's not what this blog post is about. This post is about how you can
create your own custom seccomp profiles for your containers. And how to debug when
your profile is missing a syscall.

So this is not the most sane thing in the world, I even tried in the process
to create a bash script that takes the output from strace, collects the
syscalls, and generates a profile. But like all tools of this sort (eg.
`aa-genprof`) it missed some, well to be exact it missed **6**. Which is no
small feat to debug, so this post is in the format: learn by example. I am
going to take you step by step through what I did.

1. Wake up go to starbucks... just kidding... not that specific.

I wanted to make a custom profile for my `chrome` container.
I decided to get the syscalls it used by changing the entrypoint for my
[`chrome/Dockerfile`](https://github.com/jessfraz/dockerfiles/blob/master/chrome/stable/Dockerfile)
to `ENTRYPOINT [ "strace", "-ff", "google-chrome" ]`. So the only things that
changed was wrapping the command in `strace` and of course installing `strace`
in the container. The `-ff` option makes sure `strace` follows forks. Which is
essential for chrome because they fork a bunch of processes (*fun fact*: each tab
is a process with it's own PID namespace).

Cool beans, moving on.

So I used chrome the **entire day** like this to create the most verbose
`strace` output so I wouldn't miss any syscalls.

At the end of the day I saved this output into a file by running
`docker logs chrome > $HOME/chrome-strace.log 2>&1`.

Then I used the world's most janky bash script to generate a profile:

```bash
#!/bin/bash
set -e
set -o pipefail

main(){
	local file=$1
	local name=$(basename "$0")

	if [[ -z "$file" ]]; then
		cat >&2 <<-EOF
		${name} [strace-output-filename]

		You must pass a filename that has the strace output.
		EOF
	fi

	# get just the syscalls
	local IFS=$'\n'
	raw=( $(perl -lne 'print $1 if /([a-zA-Z_]+\()/' "$file" | sort -u) )
	unset IFS


	syscalls=( )

	tmpfile=$(mktemp /tmp/seccomp-strace.XXXXXX)

	curl -sSL -o "$tmpfile" https://raw.githubusercontent.com/torvalds/linux/master/arch/x86/entry/syscalls/syscall_64.tbl

	for syscall in "${raw[@]}"; do
		# clean the trailing (
		syscall=${syscall%(}

		if grep -R -q -w $syscall "$tmpfile"; then
			syscalls+=( $syscall )
		fi
	done

	# start the seccomp profile
	cat <<-EOF > "$tmpfile"
	{
		"defaultAction": "SCMP_ACT_ERRNO",
		"syscalls": [
		EOF

		for syscall in "${syscalls[@]}"; do
			cat <<-EOF
			{
				"name": "${syscall}",
				"action": "SCMP_ACT_ALLOW",
				"args": null
			},
			EOF
		done >> "$tmpfile"

		# remove trailing comma
		sed -i '$s/,$//' "$tmpfile"

		cat <<-EOF >> "$tmpfile"
		]
	}
	EOF

	cat "$tmpfile"
	rm "$tmpfile"
}

main $@
```

You use this script like so:

```bash
$ ./shitty-seccomp-profile-generator.sh chrome-strace.log
```

Now you have a whitelist generated from your strace output. But it's super bad
and when you try to run your container with it you get a vague error and
`Operation not permitted`.

Just for this example the error was:
`[1:1:0104/214046:ERROR:nacl_fork_delegate_linux.cc(314)] Bad NaCl helper startup ack (0 bytes)`.

So now we have to use our brains. WHAT!? NOOOOO!

So I opened the generated profile and took a look at what it was allowing.

Now I know a little bit about how chrome uses namespaces/seccomp to create a
sandbox, so my first thought was let's make sure we allow `unshare`, `clone`,
`seccomp` and `setns`. Sure enough, `unshare` and `setns` were missing... thanks `strace`
you really sucked that one up, even _I_ know chrome calls those.

After further thought I realized it was also missing `setgid` and
`exit`/`exit_group`.

This all took a super long time of guessing and checking but I ended up with
this [profile](https://github.com/jessfraz/dotfiles/blob/master/etc/docker/seccomp/chrome.json).

Obviously noone else is going to do this, debug for hours the syscalls that are
missing. This is why the default profile is so important, we wanted to create
sane defaults that would protect people but also not cause all this pain.

So please, please, please try it out and open an issue if you find your
container that used to run perfectly is now giving `Operation not permitted`.

If you are curious about syscalls or are trying to track down what you are
missing, this is a great syscall table: [filippo.io/linux-syscall-table](https://filippo.io/linux-syscall-table/).

Also, things are going to get better. We are working on sane security profiles
for containers that don't make you want to pull your hair out. You can read up
on the proposal at
[docker/docker#17142](https://github.com/docker/docker/issues/17142#issuecomment-148974642).
