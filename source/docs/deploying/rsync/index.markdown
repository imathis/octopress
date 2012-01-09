---
layout: page
title: "Deploying with rsync"
date: 2011-09-10 17:53
sidebar: false
footer: false
---

<h2 id="rsync">Deploying with rsync via SSH</h2>

Add your server configurations to the `Rakefile` under Rsync deploy config. To deploy with rsync, be sure your public key is listed in your server's `~/.ssh/authorized_keys` file.

``` ruby
ssh_user       = "user@domain.com"
document_root  = "~/website.com/"
rsync_delete   = true
deploy_default = "rsync"
```

Now if you run

``` sh
rake generate   # If you haven't generated your blog yet
rake deploy     # Syncs your blog via ssh
```

in your terminal, your `public` directory will be synced to your server's document root.

<h2 id="delete">Regarding rsync delete</h2>

If you choose to delete on sync, rsync will create a 1:1 match. Files will be added, updated *and deleted* from your deploy directory to mirror your local copy.

If you do not choose to delete:

- You can store files beneath your site's deploy directory which aren't found in your local version.
- Files you have removed from your local site must be removed manually from the server.

<h3 id="exclude">Excluding files from sync</h3>

If you would like to keep your Octopress files synced but also want the convenience of keeping some files or directories on the server without having to mirror them locally, you can exclude them from rsync.

When syncing, rsync can exclude files or directories locally or on the server. Simply add an `rsync-exclude` file to the root directory of your project like this:

```sh rsync-exclude
some-file.txt
some-directory/
*.mp4
```

Note: using excludes will prevent rsync from uploading local files, or if the delete option is specified, it will prevent rsync from deleting excluded items on the server.

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

## Deploying to a subdirectory

If for you wanted to host an Octopress blog at `http://yoursite.com/blog/` you would need to configure Octopress for [deploying to a subdirectory](/docs/deploying/subdir).
