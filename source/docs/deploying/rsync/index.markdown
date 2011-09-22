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

## Version control

You'll want to keep your blog source in a remote git repository,
so either [set up a Github repository](https://github.com/repositories/new) or [host your own](#self_hosted_git) and then do this.

```sh
# Since you cloned Octopress, you'll need to change the origin remote
git remote rename origin octopress
git remote add origin (your repository url)
# set your new origin as the default branch
git config branch.master.remote origin
```


{% render_partial docs/deploying/_self_hosted_git.markdown %}

{% render_partial docs/deploying/_subdir.markdown %}

