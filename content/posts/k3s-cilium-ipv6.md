+++
title = "How to configure K3s for IPv6-only operation using Cilium"
date = 2024-09-12T16:30:00Z

[taxonomies]
tags = ["Technology","Self-Hosting"]
+++

After a conversation on Mastodon I realized that I never publicly documented the steps I took to configure K3s to run using only IPv6 addresses from a public prefix.
Thus I am writing this post to recount the steps I needed to take to make this setup work.

## Design Goals

I wanted to create a single-node K3s installation on my server to be able to make use of the Kubernetes tool ecosystem and not have to fight with Dockers IMO horrible IPv6 implementation.

I wanted to use K3s, because it's lightweight, and Cilium, because I've had previous success with it, like their documentation the most and because the developers were previously quite helpful on an Issue I had opened on Github.

In order to advertise the IPs, I've chosen to use a BGP connection to my router, because that was the easiest for me.

## K3s

The initial K3s install requires quite a few installation arguments to disable features that are normally included with K3s, that I was going to replace.
Also I needed to provide it with the IPv6 CIDRs I was going to use, such that the Kubernetes API will remain functional.

This resulted in this installation command.

```bash
export INSTALL_K3S_VERSION=v1.29.3+k3s1
export INSTALL_K3S_EXEC="\
--disable traefik \
--disable servicelb \
--disable-network-policy \
--flannel-backend=none \
--cluster-cidr=2a01:4f8:a0:1720::1:0/112 \
--kube-controller-manager-arg=node-cidr-mask-size-ipv6=112 \
--service-cidr=2a01:4f8:a0:1720::2:0/112"

curl -sfL https://get.k3s.io | sh -
```

I disable Traefik, because I'm replacing it with Ingress-Nginx, so that's not strictly necessary to make a successful IPv6-only install.

ServiceLB, Network Policy and Flannel will be replaced by Cilium, so they need to be disabled.

Then I provide K3s with the 2 CIDRs I intend to use for the Pods (cluster-cidr) and the Services (service-cidr).

## Cilium

In order to deploy Cilium into the empty K3s cluster I'm using the Cilium CLI and this command:

```sh
cilium install --helm-set \
bgpControlPlane.enabled=true,\
ipv4.enabled=false,\
ipv6.enabled=true,\
ipam.operator.clusterPoolIPv6PodCIDRList={2a01:4f8:a0:1720::1:0/112},\
routingMode=native,\
ipv6NativeRoutingCIDR=2a01:4f8:a0:1720::1:0/112,\
enableIPv6Masquerade=false,\
policyEnforcementMode=always \
--version 1.16.1
```

This does the following:

- Enable BGP
- Disable IPv4
- Enable IPv6
- Provide Cilium with the Pod CIDR
- Set routingMode to native, as I have no need for any of the packet encapsulation Cilium can do via VXLAN. This will just work on my single-node setup, in a proper cluster the nodes need to know how to route traffic to the other nodes and will require additional setup, that I haven't looked into.
- Tell Cilium that our Pod subnet will be natively routed
- Disable IPv6 masquerading (This is IPv6, I'm doing this to avoid any NAT)
- Set policyEnforcement to always, such that by default no traffic is allowed and has to be configured via Network Policies (Not strictly necessary, as my node is behind another Firewall, but I wanted to test it. If there is no Firewall in front of the Cluster, this is absolutely necessary, as otherwise one will risk exposing Pods directly to the internet)

An extra step I needed to take to make BGP work is to assign my node a router-id.
BGP uses router IDs, which are normally derived from the IPv4 address.
As there is none here, we need to give it one.
This can be any IP, as long as it's unique on the peer.

```sh
kubectl annotate node NODENAME cilium.io/bgp-virtual-router.CLUSTERASN="router-id=X.X.X.X"
```

Now the only 2 things that are missing are to configure the IPPool and BGPPeeringPolicy of Cilium with a yaml file, applied via kubectl:

Note: Use a 3rd CIDR here. This is not for internal Pods or Services, but for IPs that will be used for LoadBalancer Services.

```yaml
---
apiVersion: "cilium.io/v2alpha1"
kind: CiliumLoadBalancerIPPool
metadata:
  name: ip-pool
spec:
  blocks:
    - cidr: "CIDR/112"
```

```yaml
---
apiVersion: cilium.io/v2alpha1
kind: CiliumBGPPeeringPolicy
metadata:
  name: bgp-peer
spec:
  nodeSelector:
    matchLabels:
      kubernetes.io/os: linux
  virtualRouters:
    - localASN: CLUSTERASN
      neighbors:
        - peerASN: PEERASN
          peerAddress: PEER-IPv6-ADDRESS/128
      serviceSelector:
        matchExpressions:
          # Cilium requires an expression to apply the Policy to certain nodes. This is set in order to apply it to all nodes.
          - { key: somekey, operator: NotIn, values: ["never-used-value"] }
```

If one has enabled the policyEnforcementMode always, one also needs to add some basic network policies to allow DNS and Egress, something like this:

```yaml
---
apiVersion: "cilium.io/v2"
kind: CiliumClusterwideNetworkPolicy
metadata:
  name: "allow-dns"
spec:
  description: "Policy for ingress allow to kube-dns from all Cilium managed endpoints in the cluster"
  endpointSelector:
    matchLabels:
      k8s:io.kubernetes.pod.namespace: kube-system
      k8s-app: kube-dns
  ingress:
    - fromEndpoints:
      - {}
      toPorts:
        - ports:
          - port: "53"
            protocol: UDP
---
apiVersion: "cilium.io/v2"
kind: CiliumClusterwideNetworkPolicy
metadata:
  name: "allow-egress"
spec:
  description: "Policy to allow egress"
  endpointSelector: {}
  egress:
    - toEntities:
      - "all"
```

## Conclusion

Overall this setup is not too complicated and has been working well for me for almost a year now.

I'd like to try using it with multiple nodes in the future, as that surely will bring some more unexpected challenges.
