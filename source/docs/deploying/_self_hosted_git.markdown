<h2 id="self_hosted_git">Host Your Own Remote Repository</h2>

If you want to set up a private git repository on your own server, here's how you'd do it. You'll need SSH access to follow along.

```sh
ssh user@host.com
mkdir -p git/octopress.git
cd git/octopress.git
git init --bare
pwd  # print the working directory, you'll need it below.
logout
```

The url for your remote repository is `ssh://user@host.com/(output of pwd above)`
