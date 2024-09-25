+++
title = "Upgrading VyOS from Version 1.3 (Equuleus) to Version 1.4 (Sagitta): A Walkthrough of Issues and Resolutions"
date = 2023-05-20T13:05:00Z
description = "Issues I encountered while upgrading VyOS 1.3 to 1.4 and how I solved them."

aliases = ["upgrading-vyos-from-version-1-3-equuleus-to-version-1-4-sagitta"]

[taxonomies]
tags = ["Technology","Self-Hosting","Linux"]
+++

I've been using VyOS 1.3 for some time now in my Homelab and it has been working great overall. Recently though I encountered some issues with BGP Peer Groups, required me to reboot VyOS on almost every configuration change. I found the related Bug report and the issue is related to the legacy code, used in version 1.3. The issue has been fixed by the newer replacement Python code in Version 1.4.

While new software versions usually bring advancements and improvements, sometimes they can introduce unanticipated changes that may cause issues with an existing configuration. This blog post documents my personal experiences and observations from the upgrade process, providing insights and solutions to issues encountered.

## Interface-Route removed

The first issue I came across during the upgrade was the disappearance of static interface-routes. I previously used these to route my VPN traffic to my Wireguard interface.

After the upgrade, I noticed that my Wireguard VPN tunnel wasn't working and I found that my routes were missing.

It turned out that the syntax was changed and no migration to the newer syntax happened during the upgrade process.

The old syntax that I had looked like this:

```
interface-route 10.0.10.0/24 {
    next-hop-interface wg0 {
    }
}
```

This was altered in VyOS 1.4 (Sagitta) to the following new syntax:

```
route 10.0.10.0/24 {
    interface wg0 {
    }
}
```

Once I manually re-added my routes using the syntax, the interface-route issue was successfully resolved.

I apprechiate the change overall, as it feels more logical to me, but a proper migration would have been nice.

## QoS / Traffic Shaping

While delving further into the upgraded system, I noticed that my DSL-OUT traffic policy was not functioning correctly. It seemed like the mere existence of the policy was reducing the bandwidth to about 1/20 of its original capacity. However, the LAN-OUT seemed to be unaffected and operating normally.

I had to make the following changes to the policies to make them work correctly again:

```
shaper DSL-OUT {
    bandwidth 40mbit
    default {
        bandwidth 40mbit  // Explicitly set, no longer a percentage
        // burst 4k  // Removed, default of 15k used instead to improve connection speed
        codel-quantum 300
        queue-limit 1000
        queue-type fq-codel
        // target 30ms  // Removed, default of 5ms used to reduce throughput spikes
    }
}
shaper LAN-OUT {
    bandwidth 190mbit
    default {
        bandwidth 190mbit  // Explicitly set, no longer a percentage
        // burst 4k  // Removed, default of 15k used instead to improve connection speed
        codel-quantum 570
        queue-limit 1000
        queue-type fq-codel
        // target 30ms  // Removed, default of 5ms used to reduce throughput spikes
    }
}
```

During this process, I encountered several issues:

- The `bandwidth 100%` command I used previously triggered this error: `WARNING: Interface speed cannot be determined (assuming 10 Mbit/s)`. Thus I'm now setting the bandwidth explicitly in the `default` block.
- The `burst 4k` configuration was limiting the connection speed. The default is 15k and seems to work better with the new version. (Also recommended for my speed in the VyOS docs)
- The `target 30ms` configuration also caused peculiar throughput spikes. The default setting in VyOS 1.4 is 5ms, which seems to work better. (VyOS recommends turning it to a maximum of 15ms for speeds less than 3Mbit.)

After adjusting these parameters, the QoS policies started functioning correctly.

## LAN Interface missing

On my second VyOS installation on my Hetzner Server, VyOS seemed to have forgotten the configuration of my LAN interface.

I re-added it exactly like in the old config and it worked again.

## Dynamic DNS

The last issue I encountered was with the Dynamic DNS service, which stopped updating after the upgrade. Here's what the old configuration looked like:

```
  interface pppoe0 {
    service cloudflare {
        host-name dyn.jsteuernagel.de
        login jonatan+cloudflare@jsteuernagel.de
        password xxx
        protocol cloudflare
        zone jsteuernagel.de
    }
    use-web {
        skip "Current IP Address: ";
        url http://checkip.dyndns.com/
    }
}
```

To fix this issue, I had to remove the &quot;use-web&quot; part, as it seems to be unnecessary in VyOS 1.4.

I had previously used it due to a bug in VyOS 1.3, where it couldn't pick up the IP address of the pppoe0 interface directly.

# Conclusion
While the upgrade process to VyOS 1.4 was somewhat challenging due to the above-mentioned issues, troubleshooting and resolving them helped deepen my understanding of the changes in the new version. It was a learning experience that I hope others can benefit from. As with all network changes, remember to have a backup of the existing configuration, as otherwise spotting the things that didn't migrate properly wouldn't be as easy.
