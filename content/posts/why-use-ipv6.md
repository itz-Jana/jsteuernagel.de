+++
title = "Why use IPv6?"
date = 2025-05-05T14:00:00Z
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

First of all I'll explain the benefits that IPv6 has in isolation, I'll talk about Dual Stack later on.

## No NAT

Network Address Translation (NAT) is a hack that was established in the 1990s (?) as a way to postpone the impeding issue of IP address space exhaustion.
That's right, already in the 1990s this was an issue that was considered, as the IPv4 space is pretty limited in size and IPv6 was developed as a solution for that.
Yet as everyone that has been living on this earth for long enough knows: Humans will rather find a way to extend the lifetime of an existing solution than to implement significant change.
So NAT was born to allow for entire networks to work via only 1 public IPv4 address.

NAT causes all kinds of issues that we've found various hacks to circumvent.
Static NAT mapping (commonly called port forwarding), STUN and TURN servers (?), ...

Now with IPv6 none of these are necessary, because we aren't interested in using NAT anymore.
We are restoring the end-to-end connectivity that the internet was originally designed with, where every device has one or more globally unique addresses with which it can directly talk to other globally addressable devices.

### But what about Security?

Whenever I say that we don't have NAT anymore someone will raise security concerns and that's fair.
In a world where NAT and a Firewall are most often run on the same device, it's easy to confuse the function of either.

> NAT is not a firewall!

NAT only described the process of translating a public address to a private one and (most often) facilitating continous connectivity using state table.
Whether a device is allowed to talk to another is independently determined by a firewall, which continues to exist with IPv6.
So even though a device becomes globally addressable with IPv6, it won't be globally reachable by default.

Now sure, if no firewall were to exist and NAT wouldn't map any ports from the public IP to a private IP that device can technically not be reached by another device on the internet.
But that's like leaving your front door unlocked and relying on no one knowing where you live to prevent someone from entering.

Another related concern is the worry about tracking of individual devices and that's a valid one.
With IPv4, all outgoing connections of a network could only be pinned down to that network, but not an individual device in that network.
With IPv6, each devices can be individually identified and even it's MAC address can be determined based on the address.

Luckily, someone also thought about that and we have the IPv6 Privacy Extensions.
Due to it being normal for a device having multiple IPv6 addresses, devices supporting Privacy Extensions will generate 2 IPv6 addresses.
One address with a static suffix, based on the MAC address, and another one that is randomly generated, preferred for all outgoing connections and regularly rotated (?).
Thus devices are still individually identifyable for some time, but longer term tracking is prevented.
Association with a network is still possible as before, based on the IPv6 prefix of the network, so that hasn't changed.

## No IP collisions

Due to the amount of available IPv6 addresses, we can have unique addresses for every device.
Even if someone would choose to use a Unique Link-Local Address (ULA), which one shouldn't unless there is a very good reason for it, the spec has a mechanism to ensure those are likely to be unique and not create collissions if two existing networks were to be connected.

This is very nice, as with IPv4 it's pretty likely to run into problems where, for example, a company VPN just so happens to be using the same IPv4 prefix as the own network and thus stuff breaks (ask me how I know...).

## Enforcement of good practices

One common criticism I hear about IPv6 is that the addresses are so long.
Who will be able to remember those?

Well, you don't.
I consider the fact that you can trivially memorize an IPv4 address a bug and not a feature.
Because do you know what is even easier to remember than any address?

A hostname.

Because I can't trivially remember IPv6 addresses, I have create DNS records for them and made sure that my DNS configuration is consistent.
Before that my DNS config was an inconsistent mess.

## It's just routing

I feel the need to re-iterate this, because I enjoy this part so much.

Because there is no NAT to think about, connections turn into simple routing problems.
A packet needs to go here, where do I need to send it?

I can trivially use the same address and thus DNS entry for a device and depending on whether I am inside one of my networks or on the wider internet, it just gets routed differently.

Private IPs in Public DNS? A thing of the past. Everything is global.

# The hell that is Dual Stack

Now, if I managed to catch your interest in IPv6 at least a bit, cool, amazing, let me keep you from making the most common mistake that there is in order to not ruin your experience.

Many people that want to use IPv6 default to wanting to use Dual Stack, where every device on the network simultaneously has an IPv4 address and IPv6 addresses.
That is a good approach for an end-user network, as many devices, operating systems and programs still don't play well with only having IPv6 addresses.
So in that case: Enable IPv6 in your router and dis-disable it on your devices (In case you ever looked up some networking problem and the helpful people on the internet insisted you turn of IPv6...) and your good!

But we are talking about a server environment, Dual Stack is not the answer.
Having both networking stack enabled not only means that you will have to maintain both of them, but you will also be bound to the limitations of both of them and thus can't take advantage of some of the benefits of IPv6.
Too often have I seen networks that ran Dual Stack, but no one ever verified if IPv6 even works properly, so DNS entries would only be IPv4, firewall rules would only be IPv4, ....

Sure, with due diligence one can make such a setup work, but why not just make your life networking easier and better?

# IPv6-only is the solution

So run IPv6-only, I say!

If you drop IPv4, you are no longer beholden to the limitations of it.

> "But what if someone that doesn't have IPv6 needs to reach my service?"

Good question!
The reality is that IPv6 adoption is not that high.
Germany is one of a few countries that has widely-available IPv6-support, but whenever friends from different countries want to access my stuff, they couldn't if I didn't have some way to make IPv4 work.

But luckily that's not a problem.
We aren't completely dumping IPv4 (even though I would love to), but we are instead moving the problem to the network edge.
We are treating IPv4 as the legacy technology that it is: Keeping it running as best as possible, but not having it be the primary concern.

## Transitional technologies

To make that work there are a multitude of solutions one can use.
The most important ones are DNS64 and NAT64 (Yes, it's NAT again, we aren't getting around it as long as IPv4 is in play).

DNS64 generates AAAA (IPv6) DNS entries for any domain that doesn't have one by using a prefix that is routed to a NAT64 instance and mapping the IPv4 address into it.
`64:ff9b::/96` is the well-known prefix for use with NAT64, so an IPv6 mapped IPv4 address would look something like this `64:ff9b::140.82.121.4` (This is an IP of Github. One of the biggest and most annoying services to not support IPv6).

NAT64 takes incoming traffic from the translation prefix and forwards them to the indented destination, translating between networking stacks.
This of course means that whatever runs NAT64 needs to have IPv4 connectivity, so I most often run it directly on whatever is the router.

Both of those technologies can facilitate outgoing connections to IPv4-only services, like Github.
For incoming connections we need some sort of reverse proxy.

For that one can use basically any common reverse proxy software like Nginx, HAProxy, Caddy or other.
Though to make this setup as seemless as possible (I don't want to have to think about IPv4 whereever possible), I've been using [`snid`](https://github.com/AGWA/snid).
snid accepts incoming HTTPS connections on IPv4, does a DNS lookup for the IPv6 address of the service, validates that it's within an allowed IPv6 prefix, and forwards the traffic.
No manual configuration necessary, when a new service is added.

Because snid only runs on Linux, but I also have an OPNsense (So FreeBSD-based) router at home, I've come up with a similar solution using Nginx, the config for which is pretty simple:

```
TODO
```
