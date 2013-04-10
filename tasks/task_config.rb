module TaskConfig
  ## -- Rsync Deploy config -- ##
  # Be sure your public key is listed in your server's ~/.ssh/authorized_keys file
  SSH_USER       = "user@domain.com"
  SSH_PORT       = "22"
  DOCUMENT_ROOT  = "~/website.com/"
  RSYNC_DELETE   = false
  RSYNC_ARGS     = ""  # Any extra arguments to pass to rsync
  DEPLOY_DEFAULT = "push"

  # This will be configured for you when you run config_deploy
  DEPLOY_BRANCH  = "gh-pages"

  ## -- Misc Configs -- ##

  PUBLIC_DIR      = "public"    # compiled site directory
  SOURCE_DIR      = "source"    # source file directory
  BLOG_INDEX_DIR  = 'source'    # directory for your blog's index page (if you put your index in source/blog/index.html, set this to 'source/blog')
  DEPLOY_DIR      = "_deploy"   # deploy directory (for Github pages deployment)
  STASH_DIR       = "_stash"    # directory to stash posts for speedy generation
  POSTS_DIR       = "_posts"    # directory for blog files
  THEMES_DIR      = ".themes"   # directory for blog files
  NEW_POST_EXT    = "markdown"  # default new post file extension when using the new_post task
  NEW_PAGE_EXT    = "markdown"  # default new page file extension when using the new_page task
  SERVER_PORT     = "4000"      # port for preview server eg. localhost:4000
end