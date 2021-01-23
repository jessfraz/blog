+++
date = "2021-01-22T12:17:58-07:00"
title = "DUM-E and U"
author = "Jessica Frazelle"
description = "How would the hydraulic robot arms in Iron Man actually work?"
+++

DUM-E (“dummy”) and U (“you”) are the names of the robot arms in the Iron Man movies. After watching this movie for the n-teenth time, I have a strong urge to also have robotic arms in a workshop like Tony Stark. You can see the value of the robots clearly throughout the movie. The robots allow Tony to produce suits more quickly, help test the suits, and provide periodic comedic relief. At one point, DUM-E even saves Tony’s life. As a bit of a thought experiment, I considered what it would take to get the same functionality in reality. What this ends up leading to is a configuration management system for manufacturing, much like a build system. This post is going to outline that a bit!

The most popular open-source framework for building robots is [ROS (Robotics Operating System)](https://www.ros.org/). You can add different components like cameras or sensors and program all the functionality you need for your specific use case. The underlying infrastructure works by passing messages, through a pub/subsystem. [Elementary Robotics](https://www.elementaryrobotics.com/) created their own OS called [atom](https://github.com/elementary-robotics/atom). It’s pretty cool, it uses Redis for the messaging layer and [docker](https://atomdocs.io/tutorials.html#camera-element-tutorial) for packaging and defining the individual components. Need a camera on your robot? Include the camera container in your atom OS config file. You can then pipe the messages from the camera into machine learning in another container. It’s important to know the basics of these frameworks to continue into how we would build DUM-E and U.

Let’s dive in. The end goal here is to be as productive as Tony Stark at building things.

## Fire extinguisher robot

One of my favorite scenes with DUM-E is when Tony is testing the suits and it’s DUM-E’s job to blast him with a fire extinguisher when he is on fire. For comic relief in the movie, DUM-E messes this up a bunch and blasts Tony when he’s not on fire. 

Let’s break this down, starting with a robot that will shoot a fire extinguisher on any fire. First, what you would need is the robotic arm base, maybe you build your own, maybe it’s ABB, Kuka, FANUC, or any other robot arm maker. Let’s assume you have some sort of robotic arm with an SDK/API you can program. You also need a fire extinguisher. Since we are hackers we will just duct tape this to the robot arm and have a trigger on the switch to fire it programmatically. Next, we need a camera. Let’s also duct tape this and all the wires to the robot. We need to know if something in our proximity is on fire and where it is. We will need some code to determine if something is on fire. You could likely train a machine learning model to do this. So when the ML model identifies something as on fire, we need to calculate where it is in relation to the distance from the camera identifying it to the fire extinguisher we duct-taped to the robot. This is all doable and pretty much depends on how well we trained our model.

In the movie, DUM-E is quite bad at identifying fire. It is _just a movie_ but we should consider it might be hard for the model to differentiate fire from the color of the suit when it’s not on fire. If you recall, Iron Man’s suit is crimson and gold which could be misidentified as fire if it’s moving in the same pattern a fire might move. Tony does fly and move around at very fast speeds. This really comes down to how well Tony trains the model. As long as DUM-E continually learns, which he should, by the time Iron Man has been blasted by mistake a few times, the model should know the difference between the two (on fire and suit that looks like fire moving in a weird way). We also get to witness this learning in the movie.
Lifesaver
DUM-E, despite his namesake, is very intelligent. A major scene in the movie is when he saves Tony’s life by passing him the reactor to power the magnet in his chest. The reactor is just out of Tony’s reach as he is dying and DUM-E realizes this and passes it to him. This could be programmed in a few different ways. 

One way would be the equivalent of hard coding this behavior. Maybe Tony trained DUM-E to pass him the reactor. That’s a bit lame and wouldn’t be very useful outside this context. Let’s assume DUM-E was programmed a different way.

What would be more useful overall is if DUM-E had some programming that when Tony is reaching for an object just outside his reach, DUM-E should know to pass it to him. Again this relies on a camera and a very precise machine learning model. Instead of the fire extinguisher though, we would need a claw to pick up the object and pass it. The machine learning model for this behavior would have to:

## Identify a human

Identify the difference between a human in a resting state and a human reaching for something, arms extended
Identify the object the human is reaching for, scan for objects a certain distance from the end of the hand
We’d also want some code to know when the object is out of reach and the robot should help or if the human is fine on their own, don’t want the robot arm getting in my way when I actually want to grab something. So maybe watch the rate of the reach and calculate if it’s possible for the arm to extend to any objects around where it is headed.

This should all be possible. For bonus points let’s make it even more useful. Tony uses his robots to help him build things in his workshop and at times he asks them to pass him tools. Let’s add a microphone component to the robot and a model to identify when I am asking for an object. Now the robot needs to correctly identify objects based on a name, and let’s hope it parses what I said correctly in the first place. We could also help the robot identify objects, by using the camera to identify if I pointed to a specific object when I asked for it. This would be super helpful and like having another set of arms around.

## Assembling the suits

Both DUM-E and U help Stark assemble the Iron Man suits. To do this, the robots need to know the final configuration of the suits when put together. They also need to know where on Tony’s body they need to attach the suit. So we need:

A camera to identify Tony and where to put the parts of the suit, we need to identify the parts of the suit as well
We need a claw with the tools to do the final welding and putting together of the suit

## Hardware mode

After building a few suits, Tony’s workshop is viewed in less of an “I am actively building things” configuration. You can see the floor is more clear and there are fewer tools and materials strewn about. It’s basically like someone cleaned up and things have been at rest for a while. When Tony needs to build the reactor to create the element to power the suit, he tells the robots “We are going back into hardware mode.” This had me thinking, wouldn’t it be cool if there were different configurations of factory floor layouts that could be named and switched to on a whim? How would we do this? 

Up til now, we’ve programmed all the robots to do what we wanted with code. Assuming we used ROS or Atom, we would have some configuration files and code laying around in a repo somewhere. Let’s assume a repo per robot or a repo per behavior of the robot, either way, we have a single place where code is defined that determines the behavior of the robots. What we need on top of this is a few things:

A programmatic map of the factory floor with coordinates so we can assign robots to specific coordinates, we could use geocoding or something else for this, imagine a whatever powers your Roomba
Each robot needs a camera and a tracking mechanism for knowing where to go to get to its defined coordinates for this workflow (if it is stationary), if not the robot might already have a task of moving something from one place to another, more on that later
A configuration to specify:
What robot or machine is being used for this step
Where a robot or machine needs to go
The code that needs to be loaded into the robot for its tasks now, or if the code is already loaded into the robot, the robot needs to know what code to execute for this configuration
Ex. is this code for analyzing an object to make sure it is up to quality? Is this code to pass objects? Should it now go into laser cutting mode? 
Any artifacts the robots need to work with
For example, say in the configuration file our first step was a desktop metal printer printing a certain stl file. Much like a CI pipeline, our artifact would be the finished 3D printed object itself.
The next robot in the pipeline might be a robotic arm, assigned to coordinates between the printer and the assembly line. This next configuration in the file would know it needs to take that artifact (since we would define it) and pass it to the assembly line
Then the rest of the configuration file could define the assembly line

So now we can have configuration files for several different assembly processes. If we want to start building something different we just load the new file and the robots would update their code. So when Tony says, “we are going back to hardware mode” we can think of this as him telling the system to load the new file.

Sample file:
```
name: “hardware-mode”
steps:
machine: desktop-metal-1
  runs: |
    my-super-cool-stl-file.stl
  artifact: part-hook
machine: dum-e
	location: near-desktop-metal-1 # or maybe actual code coordinates, would be nice if there were shortcuts that translated to those
  runs: |
    part-hook | assembly-line # code the dum-e robot needs to execute, or maybe point to the repo where the code is stored
```

The cool thing about this setup is now our entire factory is configured in code. We can roll back by reverting a commit or we can add more functionality by modifying the file. We also gain tracking the entire history of the factory setup for free. Possibly CAD programs could help generate these files. It is the equivalent of a build pipeline but for manufacturing, I guess it could be considered a physical build pipeline.

Overall, this was a fun thought experiment. I can only hope to get a few robots and try and hack a real pipeline together one day. I do think becoming as productive as Tony Stark could be possible, just need the funds and time to hook it all together. And, of course, something to build!

