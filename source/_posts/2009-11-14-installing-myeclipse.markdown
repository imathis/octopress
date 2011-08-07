--- 
layout: post
comments: "false"
title: Installing MyEclipse
date: "2009-11-14"
link: "false"
categories: life
---
MyEclipse, from Genuitec, is a popular set of plugins for the Eclipse platform. For several years I used it on my own as my primary Java development tool, and now I have an opportunity to use it in my work for the University. What follows is how I installed it for use on Mac OS X 10.6 (Snow Leopard).

Upon downloading the "All in One" installer, which includes Eclipse 3.4.2 and a Java Runtime Environment (JRE) and running it, I was unhappy to discover that not only could I not specify where the install would occur, but that it installed the majority of itself in the root Library directory (<strong>/Library</strong>).

I ran the full install with the default settings and ended up with a "Genuitec" directory in <strong>/Library</strong> that contained both some common files and the MyEclipse 7.5 installation. The root Applications directory, <strong>/Applications</strong>, contained a MyEclipse folder with an alias to the <strong>/Library/Genuitec/MyEclipse 7.5</strong> folder, and an uninstall application.

Out of curiosity I ran the uninstall and it completely removed MyEclipse, the Genuitec directory was gone from <strong>/Library</strong>, and the MyEclipse directory was gone from <strong>/Applications</strong>.

Re-running the installer a second time I changed the default locations to my Applications directory, inside my Home folder, or <strong>~/Applications</strong>. And I successfully copied the MyEclipse folder from the root applications folder (<strong>/Applications</strong>) to my personal one (<strong>~/Applications</strong>).

Here's how I did it.
## Step 1: Start the MyEclipse installer from the download
<img class="aligncenter size-full wp-image-2177" title="myEclipseWelcome" src="http://zanshin.net/wp-content/uploads/2009/11/myEclipseWelcome.png" alt="myEclipseWelcome" width="525" height="389" />

Click on "Next" to start the installer.
## Step 2: Accept the License Agreements
<img class="aligncenter size-full wp-image-2178" title="myEclipseAccept" src="http://zanshin.net/wp-content/uploads/2009/11/myEclipseAccept.png" alt="myEclipseAccept" width="525" height="465" />

After reviewing and accepting the license agreements, click "Next" to continue.
## Step 3: Change the Default Locations
<img class="aligncenter size-full wp-image-2179" title="myEclipseDefaultLocations" src="http://zanshin.net/wp-content/uploads/2009/11/myEclipseDefaultLocations.png" alt="myEclipseDefaultLocations" width="525" height="465" />

I chose not to accept the default "Install" and "Common software" locations. Click the "Configure" button and enter in the locations you want. In my case I entered <strong>/Users/mark/Applications/Genuitec</strong>.

<img class="aligncenter size-full wp-image-2180" title="myEclipseNewLocations" src="http://zanshin.net/wp-content/uploads/2009/11/myEclipseNewLocations.png" alt="myEclipseNewLocations" width="525" height="465" />

After setting the locations, click "Next to continue.
## Step 4: Install
<img class="aligncenter size-full wp-image-2181" title="myEclipseInstall" src="http://zanshin.net/wp-content/uploads/2009/11/myEclipseInstall.png" alt="myEclipseInstall" width="525" height="465" />

With the locations set to your preferences, click "Install" to complete the process.
## Step 5: Dismiss the Application's First Run
Once the install is complete, MyEclipse will automatically start. Dismiss the "Workspace Launcher" dialog so that you can finish moving installed files where you want them.

<img class="aligncenter size-full wp-image-2182" title="myEclipseWorkspace" src="http://zanshin.net/wp-content/uploads/2009/11/myEclipseWorkspace.png" alt="myEclipseWorkspace" width="587" height="244" />

Click "Cancel" to dismiss the launcher.
## Step 6: Move the "MyEclipse" directory
When I can, I've been installing software into my personal Applications directory. There's no technical reason for this choice, it's a personal thing: I want to segregate (as much as I can) applications I've installed from those that came with the machine.

In my case I located the "MyEclipse" folder in the <strong>/Applications</strong> directory and dragged it to the Applications directory in my home folder, or <strong>~/Applications</strong>. This isn't necessary as MyEclipse will work perfectly from <strong>/Applications</strong>.

Now you are ready to start MyEclipse by double-click its icon in the MyEclipse folder.
## One final note
Running the provided MyEclipse uninstaller won't completely remove the software if you move it as I have done. The "Genuitec" folder and the "MyEclipse" folder will remain in their new locations. I suspect the install process doesn't leave a breadcrumb trail for the uninstaller to follow. If you uninstall MyEclipse after installing it in a custom location, you'll have to remove those folders by hand.
