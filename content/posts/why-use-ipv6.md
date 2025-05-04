+++
title = "Why use IPv6?"
date = 2025-04-30T14:00:00Z
description = "Making the case for why to use IPv6"

[taxonomies]
tags = ["Technology","Self-Hosting"]
+++

Whether you're following me on the Fediverse or have read some of my other blog posts, you'll know that I am somewhat obsessed with IPv6.

If a software or product only supports IPv4, I will not use it unless I have no alternative options.

My home network is entirely Dual Stack and I keep trying to get it to work reliably with IPv6-mostly (I keep running into some bugs with my hardware).

Most of the VMs on my server are IPv6-only and get their addresses automatically via SLAAC.

The single-node Kubernetes "cluster" this blogs runs on is entirely IPv6-only.

I run a NAT64 and SNI-based auto-configuring reverse proxy on my router to enable access to services from legacy IPs.

I inter-connect different sites with BGP over WireGuard tunnels that are IPv6-only with only link-local addresses.

This has caused me to find all kinds of bugs, issues or stupid defaults in different software.
I have thus started saying:

> You aren’t actually running #IPv4, until you disable IPv4.

So naturally someone would be inclined to ask: **Why?**

Good question, let me try to explain.

# Benefits of IPv6


