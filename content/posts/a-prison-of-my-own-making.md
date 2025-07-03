+++
title = "A prison of my own making"
date = 2025-06-30T12:00:00Z
description = "Killing the joy of homelabbing with my own expectation"

[taxonomies]
tags = ["Technology","Self-Hosting"]
+++

[Yesterday I realized something](https://social.jsteuernagel.de/@jana/114768460919053583):
**I've built myself into a prison and didn't realize it.**

Let me explain:

Working on tech projects has always been something relaxing for me.
If I was stressed about something, I could always turn to my homelab as a source of calm and it would usually provide exactly the balance that I needed to keep going.

But recently I found this not to be the case anymore.
I would turn to a project and just stare at the screen.
I was thinking of all of the things I would need to do to set something new up and I felt overwhelmed.

I was overwhelmed by all of the things that I convinced myself to be necessary.

- **Everything needs to be declarative**
- **Machines as cattle, not pets**
- **Immutable systems and containers**
- **GitOps all the things**
- **Automated deployment**
- **CI/CD pipeline**
- **Security considerations**

This lead me to my current setup, where it feels impossible to just do something.

Want to try out a new program?
Better first figure out how to run it in a container and make it run on Kubernetes.
And manifests need to be committed to Git.

Quickly spinning up a simple file share to give a friend a download link?
Impossible.
I don't have a single machine where I could just touch an nginx config and point it at a folder.

Install something on the home server?
Change the Nix config.
Oh, I didn't update it in a while, let's also do that.
Aaaand the rebuild is broken or there is yet another bug in nixpkgs that only shows itself after a few days.

Now today I realized that this goes even further:
I use Fedora Silverblue on my laptop.
That's an immutable distro and what has it caused?
I can't just install a program anymore.
I need to figure out whether it is available as a Flatpak, run it in distrobox (which I hate) or layer it and reboot.

None of these things are inherently bad.
All of these practices have their place.
Many make working on something with multiple people way easier.
But I am just myself and just documenting what I did in markdown files works *incredibly* well for me.

Spelling it out now, it feels like I should have realized way earlier what was killing my joy.
But now I did, so I'll be undoing a lot of this mess.

So here are a rough set of rules I have decided on for myself, so I hopefully don't fall into the same trap again:

- Stay away from immutable distros
- Only use deployment tools if they make things easier (Like setting up multiple machines at once)
    - And only use them for the parts that they actually make easier. I don't need purity here.
- Ditch CI/CD pipelines (I want to go back to the simplicity of a shell script in a cronjob)
- Stuff gets installed in the easiest way possible, preferable a container on a single host with Containerfiles neatly organized in a directory, otherwise throw it into a VM
- Not everything needs to be fully declarative. Just doing a backup of state is fine!
- Purity is a sin. Accept compromise if it makes something work better for me.
