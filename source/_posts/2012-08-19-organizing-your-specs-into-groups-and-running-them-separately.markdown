---
layout: post
title: "organizing your specs into groups and running them separately"
date: 2012-08-19 13:57
comments: true
categories: Ruby, Ruby on rails, General
---

A while back I answered [this StackOverflow question](http://stackoverflow.com/questions/10029250/organizing-rspec-2-tests-into-unit-and-integration-categories-in-rails/10029504#10029504).

When you have a lot of specs, it makes sense to run them in separate logical groups and not just with `rspec spec` or something like that.

This way, you can save time and you can also run them in separate processes on the CI.

For example:

```
bundle exec rake spec:unit
bundle exec rake spec:integration
bundle exec rake spec:api
```

In order to achieve this, you need to change the `spec.rake` file.

```ruby
  namespace :spec do
    Rspec::Core::RakeTask.new(:unit) do |t|
      t.pattern = Dir['spec/*/**/*_spec.rb'].reject{ |f| f['/api/v1'] || f['/integration'] }
    end

   Rspec::Core::RakeTask.new(:api) do |t|
      t.pattern = "spec/*/{api/v1}*/**/*_spec.rb"
    end

    Rspec::Core::RakeTask.new(:integration) do |t|
      t.pattern = "spec/integration/**/*_spec.rb"
    end
  end
```
You can continue customizing that all you want, you can run specific specs that are the most important to you.

I find those groups useful for most of my use cases, but with minor changes you can make it fit yours

### Using Rspec Tags

You can use tags for that as well, but I find that more tedious and you can forget to *tag* something.

For example:

```ruby
  it "should do some integration test", :integration => true do
   # something
  end
```