+++
title = "Live replacing all K3s master nodes"
date = 2023-05-13T13:27:00Z
description = "My experience live replacing all nodes of a K3s cluster"

aliases = ["live-replacing-all-k3s-nodes"]

[taxonomies]
tags = ["Technology","Self-Hosting","Kubernetes","Linux"]
+++

I am running a 3 node K3s HA Kubernetes cluster at home, to run most of my selfhosted services. Before going all in with the cluster and migrating all of my stuff onto it, I decided that I wanted to upgrade the internal SSDs of all nodes to 1 TB.

But instead of re-installing the whole cluster, I wanted to do a rolling upgrade and replace the nodes 1 by 1, keeping the existing Kubernetes installation and my data in Longhorn intact.

Here is a quick guide on how to do this, using K3s, as I had a few question on the way.

## Removing a node

The first step is to remove a node from the cluster, this is done in 3 simple steps:

- Drain the node using `kubectl drain NODENAME --delete-emptydir-data --ignore-daemonsets`
- Run the [k3s-uninstall.sh](https://docs.k3s.io/installation/uninstall) script: `/usr/local/bin/k3s-uninstall.sh`
- Remove the node from etcd: `kubectl delete node NODENAME`

Now the cluster is running with only 2 nodes. Longhorn will display replication errors on the Dashboard, but everything should keep running. Now it's time to upgrade the node and re-install it.

## Adding the node

After upgrading the node and re-installing the OS, it's time to join it back into the K3s cluster. For the second and third node, this is easily done, by using the same command, as was done during the initial install. But what about the first node, which was started with the `--cluster-init` command? As it turns out, the init is only relevant during the first start of K3s, afterwards it will be ignored anyways, as it would ignore `--server`. Thus one can join the old init node to the cluster, by just using `--server IP-OF-RUNNING-NODE`.

So I used this command to re-join my first node (of course, don't forget to set the K3s version and the Token env variables first!):

```sh
curl -sfL https://get.k3s.io | sh -s - server --server https://10.0.0.14:6443
```

and this one for the second and third node

```
curl -sfL https://get.k3s.io | sh -s - server --server https://10.0.0.13:6443
```

## Result

After joining a node back, all necessary pods will automatically get scheduled again and Longhorn will replicate all necessary data back onto the node. After the replication is done, one can proceed with the next node.

All in all, this process was surprisingly painless and has given me a lot of confidence in the resiliency of my system.
