---
layout: post
title: "run rake task in the background and log to file"
date: 2012-07-30 02:16
comments: true
categories: general, Ruby, Ruby on rails, Open source
---

I am working with rake tasks a lot, I love the simplicity of creating one and just running one on the server.

For the real heavy lifting I am using a queue system of course, but when I just want to throw something in the queue for example, I will usually create a rake task for it and run it on one of the servers.

I use quick and dirty `puts` messages to log the progress.

For example I could have a rake task like this:


```ruby
User.find_each do |user|
  puts "Going over user: #{user.id}"
  Resque.enqueue(...)
end
```

To run this on the server, I just ssh into is and then I do `screen` so when I log out of the server the session will save the process and not kill it.

Then, I run this command:


```
rake foo:bar  --trace 2>&1 >> log/some_log_file.log
```

That's it, you can now leave the server and let it do all the work, periodically, you can log in and check the progress just by tailing the file.