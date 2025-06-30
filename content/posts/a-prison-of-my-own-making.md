+++
title = "A prison of my own making"
date = 2025-07-30T12:00:00Z
description = "Killing the joy of homelabbing with my own expectation"

[taxonomies]
tags = ["Technology","Self-Hosting"]
+++

Yesterday I realized something:
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

Here's where this all started, if you are interested:

<blockquote class="mastodon-embed" data-embed-url="https://social.jsteuernagel.de/@jana/114768460919053583/embed" style="background: #FCF8FF; border-radius: 8px; border: 1px solid #C9C4DA; margin: 0; max-width: 540px; min-width: 270px; overflow: hidden; padding: 0;"> <a href="https://social.jsteuernagel.de/@jana/114768460919053583" target="_blank" style="align-items: center; color: #1C1A25; display: flex; flex-direction: column; font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Oxygen, Ubuntu, Cantarell, 'Fira Sans', 'Droid Sans', 'Helvetica Neue', Roboto, sans-serif; font-size: 14px; justify-content: center; letter-spacing: 0.25px; line-height: 20px; padding: 24px; text-decoration: none;"> <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="32" height="32" viewBox="0 0 79 75"><path d="M63 45.3v-20c0-4.1-1-7.3-3.2-9.7-2.1-2.4-5-3.7-8.5-3.7-4.1 0-7.2 1.6-9.3 4.7l-2 3.3-2-3.3c-2-3.1-5.1-4.7-9.2-4.7-3.5 0-6.4 1.3-8.6 3.7-2.1 2.4-3.1 5.6-3.1 9.7v20h8V25.9c0-4.1 1.7-6.2 5.2-6.2 3.8 0 5.8 2.5 5.8 7.4V37.7H44V27.1c0-4.9 1.9-7.4 5.8-7.4 3.5 0 5.2 2.1 5.2 6.2V45.3h8ZM74.7 16.6c.6 6 .1 15.7.1 17.3 0 .5-.1 4.8-.1 5.3-.7 11.5-8 16-15.6 17.5-.1 0-.2 0-.3 0-4.9 1-10 1.2-14.9 1.4-1.2 0-2.4 0-3.6 0-4.8 0-9.7-.6-14.4-1.7-.1 0-.1 0-.1 0s-.1 0-.1 0 0 .1 0 .1 0 0 0 0c.1 1.6.4 3.1 1 4.5.6 1.7 2.9 5.7 11.4 5.7 5 0 9.9-.6 14.8-1.7 0 0 0 0 0 0 .1 0 .1 0 .1 0 0 .1 0 .1 0 .1.1 0 .1 0 .1.1v5.6s0 .1-.1.1c0 0 0 0 0 .1-1.6 1.1-3.7 1.7-5.6 2.3-.8.3-1.6.5-2.4.7-7.5 1.7-15.4 1.3-22.7-1.2-6.8-2.4-13.8-8.2-15.5-15.2-.9-3.8-1.6-7.6-1.9-11.5-.6-5.8-.6-11.7-.8-17.5C3.9 24.5 4 20 4.9 16 6.7 7.9 14.1 2.2 22.3 1c1.4-.2 4.1-1 16.5-1h.1C51.4 0 56.7.8 58.1 1c8.4 1.2 15.5 7.5 16.6 15.6Z" fill="currentColor"/></svg> <div style="color: #787588; margin-top: 16px;">Post by @jana@social.jsteuernagel.de</div> <div style="font-weight: 500;">View on Mastodon</div> </a> </blockquote> <script data-allowed-prefixes="https://social.jsteuernagel.de/" async src="https://social.jsteuernagel.de/embed.js"></script>
