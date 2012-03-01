---
layout: page
title: "Deploying to Amazon S3"
date: 2012-02-29 20:15
sharing: false
footer: false
---

If you haven't already, go [sign up for an Amazon AWS account](http://aws.amazon.com/s3/) right now. It's very inexpensive, usage based, and you only pay for what you use. 

You will need to install `s3cmd`. This is available in most Linux distributions, via [Homebrew](http://aws.amazon.com/s3/), or directly from [s3tools.org](http://s3tools.org/download).

In your `~/.s3cfg`, set `access_key` and `secret_key` according to the [Security Credentials](https://aws-portal.amazon.com/gp/aws/securityCredentials) page.

``` ini
[default]
access_key = ALRJCALDDZUDEGNSSIPE 
secret_key = 9DJWHga1Y+uBAFXntDM1Ujd6FrnnUZb/9dLMOqzn 
```

S3 is really just a huge, fast, and reliable, key-value store which happens to be accessible over HTTP. It doesn't recognize `index.html` as being special (or even the concept of directories, really) unless you enable website hosting.

Unfortunately, the latest version of `s3cmd` doesn't let you do this yet, so you'll have to use the console again. Create a bucket having the same name as the fully-qualified domain name of your blog (e.g., `blog.example.com`). Open the Properties pane for your bucket, and then the Website tab to turn this on. Make note of the "endpoint", something like `blog.example.com.s3-website-us-east-1.amazonaws.com`. You can use this directly, but most people will create a DNS CNAME pointing to it instead. 

In your `Rakefile`, set the deploy default to s3 and configure your bucket.

``` ruby
deploy_default = "s3"
s3_bucket      = "blog.example.com"
```

Now if you run

``` sh
rake deploy     # Syncs your blog to S3
```

in your terminal, your `public` directory will be synced to your bucket.
