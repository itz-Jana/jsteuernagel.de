+++
title = "Starting out with BSD"
date = 2024-09-13T11:30:00Z

[taxonomies]
tags = ["Technology","Self-Hosting","FreeBSD","OpenBSD"]
+++

I recently started testing out some operating systems of the BSD family, notably FreeBSD and OpenBSD.
Previously I was never interested in any of them, because I felt like Linux perfectly fulfilled my need for a terminal-centric server operating system.
But after having used Linux for many years by now, I've felt some of the common pain points of it and heard that the grass might be greener on the BSD side of the operating system ocean.

Namely I was interested in concept of these OSes developing the kernel and the base system together and thus maintaining compatibility long term.
While on Linux tools might regularly get replaced by other tools that in essence do the same thing, but slightly differently, on BSD things that worked years ago, should work the same today.
They focus on adding functionality to existing tools, instead of replacing them or breaking compatibility.

As my fleet of servers and VMs keeps growing, I want to test out more and more things in parallel, while having less overall time on my hands, this suddenly sounds very interesting to me.
In recent times the systems I have most appreciated are the ones that I've installed and since have just kept working flawlessly for years.

# FreeBSD

I started out by trying FreeBSD, because it appeared to be the biggest BSD operating system and the official handbook is quite extensive.
Plus I immediately felt welcomed by the FreeBSD installer and highly appreciated it asking whether I want to set certain hardening options, all of which I enabled and everything just worked.
Awesome!

Starting out I felt completely out of my element, as seemingly nothing I knew from Linux OSes worked.

I constantly found myself typing `ip a` to find my IP address.

I constantly typed out `sudo` (which I could use, but I opted for `doas` instead, so this one is on me).

I had no idea where to find configuration files.

Yet I set out to learn about all of these aspects of the OS and I could quickly make sense of most of it.

What I find especially fascinating is learning an entirely new set of tools and learning about their quirks.

I get to learn about pkg, ports, jails, FreeBSDs update and upgrade process and many more.

## Plans

I intend to using FreeBSD for my next iteration of Home NAS.
This one is incredibly basic and only needs to do a few things:

1. Use ZFS
1. Run Samba
1. Run NFS
1. Be incredibly stable

FreeBSD seems like a perfect choice for this.

# OpenBSD

Next I took a look at OpenBSD.
I've heard a lot of good things about it, specifically for networking related tasks, due to it bundling most tools necessary, plus integrating nice IPv6-related features into pf, like `af-to`.

Coming from the nice installer from FreeBSD, this was quite a difference.
It was not as nice and some of the questions confused me a lot.
Like I have no idea yet, which sets I want to install, so I guess I just take all?
But without games, because that seems unnecessary?

After the initial install I figured out, that OpenBSD has a different package manager, so I went onto figuring out that one, which was pretty easy.

And then I was pleased to see that yes, in fact, OpenBSD has everything I need to setup a router, nice!

So in order to properly learn about it, I set out to use it to power the routers of my ASN 215080, which at this point is nothing more than a playground, so I can afford to just completely replace the existing VyOS routers (which also have only be causing me trouble in this case).

This was, yet again, surprisingly easy and I had a basic working setup within a few hours.
I loved the detailed man pages that OpenBSD has for all of its tools.
On Linux I most of the time don't even bother with man pages anymore, because most times they don't get me what I want anyways, but this feels different.

And I also loved that there are configuration examples provided directly in `/etc/examples`, nice!

Because this setup requires multiple similar installations, I decided to dig out an old friend Ansible and create [this](https://gitea.jsteuernagel.de/jana/ansible-asn) playbook, to keep the installations in sync.
