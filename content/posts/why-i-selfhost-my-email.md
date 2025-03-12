+++
title = "Why I self-host my email"
date = 2025-03-12T11:00:00Z
description = "Explaining why I self-host my email and can't accept any alternatives anymore"

[taxonomies]
tags = ["Technology","Self-Hosting"]
+++

When one spends enough time in the self-hosting bubble, one will inevitably come across someone thinking about self-hosting email.
After all it's one of the few remaining open standards from a long time ago, that are still hugely important today.

Also inevitably there will be a flood of people telling that person not to do it, as email nowadays has become a terrible mess because of the centralization of power in a few big providers and that one will likely end up in spam folders forever.

But there is also those few people who say that they've been self-hosting email since its inception and would never do it any other way.

Thus, driven by curiosity, me 6 years ago, in university, set out to just give it a try.
What I didn't expect back then is for it to not only be some fun learning experience, but turn into **one of my most important services that I would not want to give up again under any condition.**

# The Problems

## Technological

As alluded to, email isn't what it used to be anymore.

Starting out as a simple and open protocol, we had to bolt on more and more different technologies to have it keep up with the times, in terms of security and spam prevention.
Thus we have moved beyond simple unencrypted SMTP and now stuff *can* be TLS encrypted, senders *can* be verified by things like SPF, DMARC and DKIM.

Notice the word *can* because technically none of these things are necessary, but good luck landing your email in the inbox of any big provider, if you don't have them.
(Funnily enough, I recently found that a good amount of email that I receive doesn't actually fulfill all of these criteria, and they still arrive. Why that is is black magic to me.)

## Blacklists

Now all of these parts are purely technological and one can implement all of these things pretty easily, but one might still not land email in someones inbox.
This is because there are additional aspects which are not as straight forward.

There is domain reputation, ip reputation and (most-annoyingly) blacklists...

Blacklists are supposed to be lists of ips or domains that are known to be used for sending out spam and can be used to just outright block them.
That might sound good in theory, but there are a lot of blacklists, each with different policies on when they might include some entry or how one can get removed from the list.
Some outright block entire ip prefixes, if there is one offending ip in the prefix.

This happened to me early on in my journey, where suddenly my emails didn't deliver almost anywhere anymore and I learned that the prefix my VPS was in god blacklisted.
And the blacklist it was in was one, where one couldn't just simply get removed from, because their policy is that "spam is a systematic approach and we need the hoster to fix their problems to consider removal".
Basically just telling me "fuck off".
Thus I was forced to move my mail server somewhere else with a new ip and because this time it's not just a VPS that spammers like to use, but a dedicated server, my ip is from a prefix that is less likely to be used for spam.

## Centralization

Most people have their email with either Microsoft or Google.

So if either of those doesn't like your mail server for whatever reason, you will be basically out of luck.
But on the flip side, if you can reliably get mail to both of them, your basically set.
And in my experience, getting them to accept my email, is not that hard.

At least compared to some German providers, who won't accept your emails unless you have an Impressum on an associated website...

# What I do

I am still using one of the easiest setups imaginable.

I use the ready-made mail stack [Mailcow](https://docs.mailcow.email/).
I've used it since the start and I still am very happy with it.
The documentation is solid and getting it to work with it is a breeze.
I have a dedicated Debian VM to run it and the only problems I ever had with it were caused by my own stupidity.

It provides a really nice web interface, a good-enough webmail interface, even provides Apple configuration profiles, which are super handy for use with Apple devices.

By now it is hosting multiple of my personal domains, plus a few domains for family.

I am thinking about diving deeper into the stack and configuring my own setup from scratch, but that isn't in the near future.

# Why I do it

- Freedom
- Flexibility
- Data Ownership

I want technology to serve me and do what I want. I don't like arbitrary limitations, but that's what I get with ever commercial email provider.

- Want to add multiple domains? That'll be a different account
- Want to have multiple mailboxes? Well that'll be different users and thus you pay for each
- Wanted to have aliases? Yes, please explicitly each and every one of them. Oh you want more than 20 aliases? Haha, no!

With my Mailcow I can add as many domains as I want at any time and create as many addresses, aliases or whatever, as I please. I am in control.

My data is also on a machine I control. It won't suddenly start being used for AI model training, because my provider changed their ToS and now I can either accept it or suffer.
And I also won't suddenly be provided with access to "Gemini" or whatever other fucking AI assistant company X now wants to shove into my face.

> *(I just realized, I can't even really use X as a placeholder for a company name anymore, can I? Now people might think I'm refering to the literal company named X, instead of just a placeholder)*

And if Mailcow ever decides it wants to do such things?
Well I would hope they maintain a switch to just turn it off, or I can just take my mails and migrate them to another mail stack, Mailcow isn't the only choice, it's just currently the most convenient for me.

# Conclusion

In recent time, with the rise of AI nonsense, I have clearly felt that the criteria I have for a good service are vastly different from commercial providers.

This post was just about email, because it is one of the more uncommon services to liberate for oneself by self-hosting.
But the message applies to so many more things.

To me the choice at the moment is most often between "Not using a thing" or "Having a self-hosted variant of it".
Because I can't take most of the stuff that is commercially fed to me.

**I want to have agency over my digital life.**
