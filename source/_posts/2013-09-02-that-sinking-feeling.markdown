---
layout: post
title: "That Sinking Feeling"
date: 2013-09-02 21:22
comments: true
categories: 
---
On Friday of PuppetConf I jumped on a video call with my coworker back at the office to get news that the president of engineering had asked for me to join the team supporting the new site that we had recently acquired. Everything about this was super exciting. It brought with it the chance to finally do something production in AWS and the potential to be a little more focused on a single property. 

While I have generally kept up with how AWS works and have dabbled a bit here and there, I have never done anything that would constitute production. I had heard about the occasional shit show that is EBS and was able to grok how all the components came together. In my excitement, I spent the weekend using Cloud Formation to spin up simple HA setups and then tying in New Relic for monitoring.

Then Monday hit. Like a ton of bricks. So many unanswered questions and so much new infrastructure to learn. More technologies to contend with that I have never gotten super good at like MySQL and MongoDB. The overwhelmingness and uncertainty of things like team makeup, on-call and such added to the technical things I had in front of me.

The rest of the week was a blur. I made a few changes here and there but in general avoided doing so. Even basic changes like setting up nscd seemed to cause problems. I really started questioning if I was in over my head.

This all got me thinking about my own fears and apprehension about things. First of all, I realized the emotions I go through with these kinds of new technical changes are standard for me. I tend to be overly cautious, hesitant to make changes, and easily spooked when the metrics don't look right.

But why? Why do these things have such an affect on me? In many ways experience is to blame. Not just a lack of experience but the bad experiences along the way. I know what the command or action is "supposed" to do but I have come to question, is that what is actually going to happen? While I have faith in reading the docs, you just don't know until you have run the command a few times what to expect.

While I understand security groups, etc. there is always the question of environment separation. I know that as long as I do the right things, nothing bad is going to happen and the world is going to be separate. That said my API keys have just as much power to kill prod instances as they do dev instances. And, as I have already discussed, I have a hard time trusting the tools.

Finally, the known unknowns kill me. The more I learn about MySQL the more I understand how little I actually know. While I will learn and become more familiar with its inner workings, I continue to be a bit hesitant to make large changes because, almost without fail, the database is the thing that breaks everything.

So what now? How do I work through these inner demons? I guess the simplest answer is to experiment and move forward. To remind myself that this is no different than any of the other times I have wadded knee deep into new infrastructure. To setup mock production environments and get a feel for what is actually going on. To do some reading and reach out to my amazing friends for help and advice.

That said, taking the weekend to step away and reflect has helped tremendously. So here is to an amazing new week ahead of me.