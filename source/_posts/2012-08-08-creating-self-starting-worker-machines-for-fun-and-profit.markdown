---
layout: post
title: "Creating self starting worker machines for fun and profit"
date: 2012-08-08 13:49
comments: true
categories: Ruby, Ruby on Rails, Open Source
---

Lately, I needed to create worker machines (Machines that have Resque workers on them).

Usually, the process is very manual and tedious, you need to deploy the code to each machine (on code change), you need to start/stop/restart the workers and more.

Since I needed A LOT of workers, I really wanted to make the process automatic.

I wanted the machine to be in charge of everything it needs.

Meaning

* Pull latest git code
* Copy file to the `current` directory
* Startup god (which will start the Resque processes)

I wanted the machine to be in charge of all this when it boots up, so in case I need to update the code or something, all I need is to reboot the machines and that's it.

Also, scaling up the process is super easy, all I need is to add more machines.

The logic behind it was also being able to use spot-instances on Amazon, which are much cheaper.

So, as always, I thought I would document the process and open source it.

## Challenges

What are the challenges we are looking at, when we want to do something like that.

1. Awareness of RVM, Ruby version
2. Awareness of Bundler and Gem versions.

Those are things we need to consider.

## Breaking down the process into pseudo code.

So, let's break down the process into pseudo code

```
Go to the temp folder
git pull from origin + branch you want
Copy all files from temp folder to current folder
Go To current folder, bundle install
Start God
```

## RVM Wrappers

For the last 2 parts of the process, if you try to do just `bundle install --deployment` for example, the script will fail, it does not know what bundle is, it resolves to the default Ruby installed on the machine at this point.

Since want the last 2 processes to go through RVM, we need to create a wrapper script.

### Creating RVM Wrappers

You can create RVM wrappers like this:

```
rvm wrapper {ruby_version@gemset} {prefix} {executable}
```

For example

```
rvm wrapper 1.9.2 bootup god
```

This will generate this file: (called `bootup_god`)

```bash
#!/usr/bin/env bash

if [[ -s "/usr/local/rvm/environments/ruby-1.9.2-p290" ]]
then
  source "/usr/local/rvm/environments/ruby-1.9.2-p290"
  exec god "$@"
else
  echo "ERROR: Missing RVM environment file: '/usr/local/rvm/environments/ruby-1.9.2-p290'" >&2
  exit 1
fi
```

I did the same for bundle which generated this file: (called `bootup_bundle`)

```bash
#!/usr/bin/env bash

if [[ -s "/usr/local/rvm/environments/ruby-1.9.2-p290" ]]
then
  source "/usr/local/rvm/environments/ruby-1.9.2-p290"
  exec bundle "$@"
else
  echo "ERROR: Missing RVM environment file: '/usr/local/rvm/environments/ruby-1.9.2-p290'" >&2
  exit 1
fi
```

The files are created in `vim /usr/local/rvm/bin/`.

Now that we have the wrappers, we made sure the boot up process will be aware of RVM and we can continue.

## RC files

If you want something to run when the machine starts you need to get to know the `rc` files.

Usually, those files are located in `/etc/` folder (may vary of course)

The files are loaded and executed in a specific order

```
rc
rc{numer}
rc.local
```

If you want something to run when ALL the rest of the machine bootup process ran, you put it at the end of the rc.local file.

One gotcha here is that the file *must* end with `exit 0`, or your script will not run at all, and good luck finding out why :P

I put this line at the end, right before the `exit 0`

```
sh /root/start_workers.sh
```

## Finalize

Now that I have the wrappers, I have the line in rc.local I can finalize the process with creating the shell script.

This is what the script looks for me

```bash
cd {temp_folder}
git pull origin {branch_name}
cd ..
cp -apRv {source_folder}/* {destination_folder} --reply=yes
echo "Running bundle install"
cd /root/c && /usr/local/rvm/bin/bootup_bundle install --path /mnt/data-store/html/gogobot/shared/bundle --deployment --without development test
echo "Starting RVM"
/usr/local/rvm/bin/bootup_god -c /root/c/god/resque_extra_workers.god
```

The god file to start the workers is standard.

```ruby
rails_env   = ENV['RAILS_ENV']  || "production"
rails_root  = ENV['RAILS_ROOT'] || "/mnt/data-store/html/gogobot/current"
WORKER_TIMEOUT = 60 * 10 # 10 minutes

# Stale workers
Thread.new do
  loop do
    begin
      `ps -e -o pid,command | grep [r]esque`.split("\n").each do |line|
        parts   = line.split(' ')
        next if parts[-2] != "at"
        started = parts[-1].to_i
        elapsed = Time.now - Time.at(started)

        if elapsed >= WORKER_TIMEOUT
          ::Process.kill('USR1', parts[0].to_i)
        end
      end
    rescue
      # don't die because of stupid exceptions
      nil
    end
    sleep 30
  end
end

queue_name = "graph_checkins_import"
num_workers = 10

# FB wall posts
num_workers.times do |num|
  God.watch do |w|
    w.dir      = "#{rails_root}"
    w.name     = "resque-#{num}-#{queue_name}"
    w.group    = "resque"
    w.interval = 2.minutes
    w.env      = {"QUEUE"=>"#{queue_name}", "RAILS_ENV"=>rails_env, "PIDFILE" => "#{rails_root}/tmp/resque_#{queue_name}_#{w}.pid"}
    w.pid_file = "#{rails_root}/tmp/resque_#{queue_name}_#{w}.pid"
    w.start    = "cd #{rails_root}/ && bundle exec rake environment resque:work QUEUE=#{queue_name} RAILS_ENV=#{rails_env}"
    w.log      = "#{rails_root}/log/resque_god.log"

    w.uid = 'root'
    w.gid = 'root'

    # restart if memory gets too high
    w.transition(:up, :restart) do |on|
      on.condition(:memory_usage) do |c|
        c.above = 350.megabytes
        c.times = 2
      end
    end

    # determine the state on startup
    w.transition(:init, { true => :up, false => :start }) do |on|
      on.condition(:process_running) do |c|
        c.running = true
      end
    end

    # determine when process has finished starting
    w.transition([:start, :restart], :up) do |on|
      on.condition(:process_running) do |c|
        c.running = true
        c.interval = 5.seconds
      end

      # failsafe
      on.condition(:tries) do |c|
        c.times = 5
        c.transition = :start
        c.interval = 5.seconds
      end
    end

    # start if process is not running
    w.transition(:up, :start) do |on|
      on.condition(:process_running) do |c|
        c.running = false
      end
    end
  end
end
```

## Profit

Now, it's a completely automatic process, all you need is to run as many machines as you need, once the machine is booted up, it will deploy code to itself, copy files, install gems and run workers.

If you want to restart the process, add machines or anything else, you can do it with the click of a button in the AWS UI.

## Comments? Questions?

Please feel free