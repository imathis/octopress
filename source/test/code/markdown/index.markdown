---
layout: page
title: "Code"
date: 2011-07-30 08:45
footer: false
sidebar: false
---

``` coffeescript Some Coffee Script for you http://google.com/
    Tweets = 1

    module.exports = Tweets
```

``` coffeescript
    Tweets = 1
    foo && bar
    module.exports = Tweets
```

{% codeblock Append this to your .bashrc file. %}
echo "User .bashrc..."
for i in ~/.env/*.sh ; do
if [ -r "$i" ]; then
. $i
fi
done
unset i
{% endcodeblock %}

{% codeblock config lang:ruby %}
Bunch of ruby code
{% endcodeblock %}
