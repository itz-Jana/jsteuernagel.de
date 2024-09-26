+++
title = "Hetzner Object Storage: Initial Impressions"
date = 2024-09-24T16:30:00Z
description = "A summary of my initial findings regarding the Hetzner Object Storage beta. Looking at IPv6, access keys, speed and cost."

[taxonomies]
tags = ["Technology","Self-Hosting","Object Storage"]
+++

A few days ago, at their Hetzner Summit, Hetzner finally announced that they are going to be offering Object Storage in the future.
Right now, they are offering a beta that will run for 1 to 2 months and you can request access to from the Hetzner Cloud panel.

I'm excited for this, because I've been on the lookup for a good, reasonably priced object storage provider for a while.
I've not been very successful though, because most conventionally used providers don't have support for IPv6 on their S3 endpoints yet (it's 2024, get on it!).

This has left me stranded on my only option: Scaleway.
And even though their service works, I've not been a fan of their their UI, handling of permissions and their unannounced rug-pull of their 75GB of free storage.

So here I'll share my initial observations surrounding the service.
I'll add updates to the post, if I discover anything else that I would consider relevant.

## IPv6

The most important part out of the way, right away.

Yes, Hetzner Object Storage has IPv6 and it works.
As I'm writing this, I am transferring 60 GB of data onto it, from an IPv6-only VM.
I will see if there will be any issues with it in the future.

```sh
> nslookup fsn1.your-objectstorage.com

Non-authoritative answer:
Name:    fsn1.your-objectstorage.com
Addresses:  2a01:4f8:b001::1
            88.198.120.64
```

## Access Keys

Hetzner has integrated the handling of access keys into their usual Hetzner Cloud UI and project structure.
This means you can create buckets in a new section of a cloud project.
Each project can have multiple buckets and multiple access keys.
Access keys always have access to all buckets in the same project.

But this isn't all, because if desired one can also use bucket policies to further restrict access of certain access keys.
This doesn't have any UI elements though and is purely managed through the CLI, as described [here](https://docs.hetzner.com/storage/object-storage/faq/s3-credentials).

## Speed

I still need to do further testing on the speed of the object storage, but my initial transfer of data easily ran at up to 500 Mbps and I don't know if the bottleneck because the files were so small, because of Scaleway or because of Hetzner.

According to [Hetzner's documentation](https://docs.hetzner.com/storage/object-storage/overview#limits), each bucket can go up to 1 GBit/s of bandwidth.

## Cost

During the beta, usage is entirely free.
Hetzner seems to intend to enable billing, starting at the 1st of November.
One can then decide whether to keep using the service, or delete all data and never have payed a cent.

According to Hetzner, pricing will be 6€ per TB of data stored, plus 1,19€ per TB of egress.
Ingress and any Hetzner-internal traffic is excluded.

This means, pricing isn't as interesting as their Storage Box offering, but rather market average.
But if the service ends up performing well, I don't see that being an issue and I'd gladly use it to have IPv6 and simplified permission handling.

## Conclusion

At first glance everything seems to be working really well.
I just took the gamble and moved the media cache of my [Mastodon instance](https://social.jsteuernagel.de/@jana) over to Hetzner Object Storage, so I will see if any problems with it arise in the coming days.
I also intend to do some more experiments with NixOS Binary Caches and maybe HLS Live Streaming to see how low the latency is.

## Update: Issue 1

I initially created my Mastodon bucket as public, because for Mastodon that's necessary.
But after a day, I saw that some of the images from my instance were disappearing.
I realized that the ones that were still there, were still in my CloudFront cache and that every access to Hetzner was giving me an "AccessDenied" error.

I checked the visibility via the `mc` CLI and surprisingly it was now set to private.
I don't know why or how the value changed, but simply setting it back to public fixed my issue.

I will continue to look out of this happens again with any of my tests.