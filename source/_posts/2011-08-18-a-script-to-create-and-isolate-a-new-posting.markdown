---
layout: post
title: A Script to Create and Isolate a New Posting
date: 2011-08-18 16:04
comments: true
categories: nerdliness
link: false
---
With my [Octopress](http://octopress.org "Octopress") instance up and working smoothly I decided I wanted to simplify the process of creating a new posting, isolating it from all the postings, and editing it. Since I have well over 1700 entries on my site each site generation is around seven minutes. Running the generation multiple times to fix typos or edit content is not efficient. 

Fortunately, Octopress comes with a [Rake](http://rake.rubyforge.org/ "Rake") task called **isolate**, which parks all other postings in to a **\_stash** directory so you can work on the current one in, well, isolation. Once the posting is completed, there is an **integrate** task that returns all the postings to the main \_posts directory.

There were three activities I wanted my new post script to accomplish:

1. Create a new posting using the title passed into the script
2. Isolate that new posting using the **rake isolate** task
3. Open the new posting in Textmate (my editor of choice)

The hardest part of creating the script was getting the Rake tasks to run inside of a Ruby script, once I had that figured out the rest was easy.

Here is my script:

{% gist 1155218 %}

I'm relatively new to writing Ruby scripts so I'm sure this could be clean up a bit. Since Octopress is running on Ruby 1.9.2, this script must also be run against Ruby 1.9.2. Using [RVM](http://beginrescueend.com/ "RVM") makes setting the current Ruby version easy so this is not an issue.

With the script installed and my path all I have to do to create a new posting and start editing is this: {% codeblock %}$ newpost.rb "A Script to Create and Isolate a New Posting"{% endcodeblock %} The script takes care of the rest, which looks like this: {% codeblock %}Running: new_post["A Script to Create and Isolate a New Posting"]
Creating new post: source/_posts/2011-08-18-a-script-to-create-and-isolate-a-new-posting.markdown
Running: isolate[2011-08-18-a-script-to-create-and-isolate-a-new-posting.markdown]
Posting created and isolated, opening in editor... {% endcodeblock %}

Sweet.