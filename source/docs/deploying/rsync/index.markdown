---
layout: page
title: "Deploying with Rsync"
date: 2011-09-10 17:53
sidebar: false
footer: false
---

<h2 id="rsync">Deploying with Rsync via SSH</h2>

Add your server configurations to the `Rakefile` under Rsync deploy config. To deploy with Rsync, be sure your public key is listed in your server's `~/.ssh/authorized_keys` file.

``` ruby
    ssh_user       = "user@domain.com"
    document_root  = "~/website.com/"
    deploy_default = "rsync"
```

Now if you run

``` sh
    rake generate   # If you haven't generated your blog yet
    rake deploy     # Syncs your blog via ssh
```

in your terminal, your `public` directory will be synced to your server's document root.

