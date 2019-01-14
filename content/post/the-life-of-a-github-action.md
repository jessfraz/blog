+++
date = "2019-01-13T08:09:26-07:00"
title = "The Life of a GitHub Action"
author = "Jessica Frazelle"
description = "A detailed overview of what happens when you create a GitHub Action."
+++

I thought it might be fun to write a blog post on "The Life of a GitHub Action." When you go through
orientation at Google they walk you through "The Life of a Query" and it was one of my favorite things.
So I am re-applying the same for a GitHub Action.

For those unfamiliar Actions was a feature launched at GitHub's conference Universe last year. 
You can sign up for the beta [here](https://github.com/features/actions/).

The overall idea is scriptable GitHub but rather than do all that hand-wavy crap to try and explain I will
take you through what happens when you run an Action.

## The Problem

Here is a typical workflow:

- I create a pull request on a repository.
- The pull request is merged.
- The branch lingers around until the end of time and eats away at the part of my soul that likes everything to be clean.

Let's focus on my pain of the lingering branches. This is totally a problem right? So let's solve it by creating an Action to delete branches after the pull request has been merged.

All the code for this action lives [here](https://github.com/jessfraz/branch-cleanup-action) if you want to skip ahead.

## The Workflow File

You can create actions from the UI or you can write the Workflow file yourself. In this post, I am just going to use a file.

Here is what it ends up looking like and I will explain what everything means in comments on the file. This lives in `.github/main.workflow` in your repository.

```
## Workflow defines what we want to call a set of actions.
workflow "on pull request merge, delete the branch" {
  ## On pull_request defines that whenever a pull request event is fired this 
  ## workflow will be run.
  on = "pull_request"
  
  ## What is the ending action (or set of actions) that we are running. 
  ## Since we can set what actions "need" in our definition of an action,
  ## we only care about the last actions run here.
  resolves = ["branch cleanup"]
}

## This is our action, you can have more than one but we just have this one for 
## our example.
## I named it branch cleanup, and since it is our last action run it matches 
## the name in the resolves section above.
action "branch cleanup" {
  ## Uses defines what we are running, you can point to a repository like below 
  ## OR you can define a docker image.
  uses = "jessfraz/branch-cleanup-action@master"
  
  ## We need a github token so that when we call the github api from our
  ## scripts in the above repository we can authenticate and have permission 
  ## to delete a branch.
  secrets = ["GITHUB_TOKEN"]
}
```

## The Event

Okay so since this post is called "The Life of an Action" let's start on wtf 
actually happens. All actions get triggered on
a GitHub event. For the list of events supported [see here](https://developer.github.com/actions/creating-workflows/workflow-configuration-options/#events-supported-in-workflow-files).

Above we chose the `pull_request` event. This is triggered when a pull request is assigned, unassigned, labeled, unlabeled, opened, edited, closed, reopened, synchronized, a pull request review is requested, or a review request is removed. 

Okay let's assume we triggered this event. 

### "Something" happened on a pull request....

Now, GitHub is like "oh holy shit, something happened on a pull request, let me fire all ze missiles of things that happen on
a pull request."

Going back to our Workflow file above, GitHub says "I am going to run the workflow 'on pull request merge, delete the branch'".

What does this resolve? Oh it's "branch cleanup". Let me order all the Actions branch cleanup requires (in this case none) and run them in order/parallel
so we end on "branch cleanup."

## The Action

At this point GitHub is like 'yo you guys, I need to run the "branch cleanup" Action. let me get what it is using.'

This takes us back to the `uses` section of our file. We are pointing to a repository: `jessfraz/branch-cleanup-action@master`.

In this repository is a Dockerfile. This Dockerfile defines the environment our action will run in.

### Dockerfile

Let's take a look at that and I will add comments to try and explain.

```
## FROM defines what Docker image we are starting at. A docker image is a bunch 
## of files combined in a tarball.
## This image is all the files we need for an Alpine OS environment.
FROM alpine:latest

## This label defines our action name, we could have named it butts but
## I decided to be an adult.
LABEL "com.github.actions.name"="Branch Cleanup"
## This label defines the description for our action.
LABEL "com.github.actions.description"="Delete the branch after a pull request has been merged"
## We can pick from a variety of icons for our action.
## The list of icons is here: https://developer.github.com/actions/creating-github-actions/creating-a-docker-container/#supported-feather-icons
LABEL "com.github.actions.icon"="activity"
## This is the color for the action icon that shows up in the UI when it's run.
LABEL "com.github.actions.color"="red"

## These are the packages we are installing. Since I just wrote a shitty bash 
## script for our Action we don't really need all that much. We need bash, 
## CA certificates and curl so we can send a request to the GitHub API
## and jq so I can easily muck with JSON from bash.
RUN	apk add --no-cache \
	bash \
	ca-certificates \
	curl \
	jq

## Now I am going to copy my shitty bash script into the image.
COPY cleanup-pr-branch /usr/bin/cleanup-pr-branch

## The cmd for the container defines what arguments should be executed when 
## it is run.
## We are just going to call back to my shitty script.
CMD ["cleanup-pr-branch"]
```

### The Script

Below is the contents of the bash script I am executing.

```bash
#!/bin/bash
set -e
set -o pipefail

# This is populated by our secret from the Workflow file.
if [[ -z "$GITHUB_TOKEN" ]]; then
	echo "Set the GITHUB_TOKEN env variable."
	exit 1
fi

# This one is populated by GitHub for free :)
if [[ -z "$GITHUB_REPOSITORY" ]]; then
	echo "Set the GITHUB_REPOSITORY env variable."
	exit 1
fi

URI=https://api.github.com
API_VERSION=v3
API_HEADER="Accept: application/vnd.github.${API_VERSION}+json"
AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"

main(){
    # In every runtime environment for an Action you have the GITHUB_EVENT_PATH 
    # populated. This file holds the JSON data for the event that was triggered.
    # From that we can get the status of the pull request and if it was merged.
    # In this case we only care if it was closed and it was merged.
	action=$(jq --raw-output .action "$GITHUB_EVENT_PATH")
	merged=$(jq --raw-output .pull_request.merged "$GITHUB_EVENT_PATH")

	echo "DEBUG -> action: $action merged: $merged"

	if [[ "$action" == "closed" ]] && [[ "$merged" == "true" ]]; then
        # We only care about the closed event and if it was merged.
        # If so, delete the branch.
		ref=$(jq --raw-output .pull_request.head.ref "$GITHUB_EVENT_PATH")
		owner=$(jq --raw-output .pull_request.head.repo.owner.login "$GITHUB_EVENT_PATH")
		repo=$(jq --raw-output .pull_request.head.repo.name "$GITHUB_EVENT_PATH")
		default_branch=$(
 			curl -XGET -sSL \
				-H "${AUTH_HEADER}" \
 				-H "${API_HEADER}" \
				"${URI}/repos/${owner}/${repo}" | jq .default_branch
		)

		if [[ "$ref" == "$default_branch" ]]; then
			# Never delete the default branch.
			echo "Will not delete default branch (${default_branch}) for ${owner}/${repo}, exiting."
			exit 0
		fi

		echo "Deleting branch ref $ref for owner ${owner}/${repo}..."
		curl -XDELETE -sSL \
			-H "${AUTH_HEADER}" \
			-H "${API_HEADER}" \
			"${URI}/repos/${owner}/${repo}/git/refs/heads/${ref}"

		echo "Branch delete success!"
	fi
}

main "$@"
```

So at this point GitHub has executed our script in our runtime environment.

GitHub will post the status of the action back to the UI and you can see it from the Actions tab.

Hopefully this has made some clarity as to how things are run in GitHub Actions. I can't wait to see what you all build.
