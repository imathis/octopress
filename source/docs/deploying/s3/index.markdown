---
layout: page
title: "Deploying to Amazon S3"
date: 2012-02-29 20:15
sharing: false
footer: false
---

Amazon Web Services (AWS) is a collection of web services that together make up a cloud computing platform, offered over the Internet by Amazon.com. The most central and well-known of these services are Amazon EC2 and Amazon S3. This page will walk you through setting up a blog on S3.

If you haven't already, go [sign up for an Amazon AWS account](http://aws.amazon.com/s3/) right now. It's very inexpensive and you only pay for what you use. 

You will need to install `s3cmd`. This is available in most Linux distributions, via [Homebrew](http://aws.amazon.com/s3/), or directly from [s3tools.org](http://s3tools.org/download). You'll need to copy & paste `access_key` and `secret_key` from the [Security Credentials](https://aws-portal.amazon.com/gp/aws/securityCredentials) page into `s3cmd`'s configuration wizard.

``` sh
s3cmd --configure         # Begin interactive configuration
```

When finished, your `~/.s3cfg` file should end up looking something like this.

``` ini
[default]
# ...snip...
access_key = ALRJCALDDZUDEGNSSIPE 
secret_key = 9DJWHga1Y+uBAFXntDM1Ujd6FrnnUZb/9dLMOqzn
# ...snip...
```

S3 is really just a huge, fast, and [very reliable](http://aws.amazon.com/s3/faqs/#How_durable_is_Amazon_S3), key-value store which happens to be accessible over HTTP. It doesn't recognize `index.html` as being special (or even the concept of directories, really) unless you enable "website hosting".

Unfortunately, the latest version of `s3cmd` doesn't let you do this yet, so you'll have to use the [AWS Console](https://console.aws.amazon.com/s3/home). Create a bucket having the same name as the fully-qualified domain name of your blog (e.g., `blog.example.com`). Open the Properties pane for your bucket, and then the Website tab to turn this on. Make note of the "endpoint", something like `blog.example.com.s3-website-us-east-1.amazonaws.com`. You can use this directly, but most people will create a DNS CNAME pointing to it instead. 

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
