--- 
layout: post
author: Mark
comments: "false"
title: Using SSHFS, MacFUSE, and Macfusion to Access Remote Filesystems
date: 2009-11-6
categories: life
---
## SSHFS
sshfs is a secure file system client that allows you to access and manipulate files on remote systems where that would normally be available via SFTP. sshfs is dependent upon FUSE or Filesystem in Userspace. FUSE is available for Linux, FreeBSD, NetBSD (as PUFFS), OpenSolaris, and Mac OS X (as MacFUSE). It was officially merged into the mainstream Linux kernel tree in kernel version 2.6.14.  h1.
## The Pieces of the Puzzle
You will need to install three applications / frameworks:
<ol>
	<li><a title="MacFUSE" href="http://code.google.com/p/macfuse" target="_blank">MacFuse</a></li>
	<li><a title="Macfusion" href="http://www.macfusionapp.org" target="_blank">Macfusion</a></li>
	<li><a title="sshfs" href="http://code.google.com/p/macfuse/wiki/MACFUSE_FS_SSHFS" target="_blank">sshfs</a> (to update the pre-installed version that comes with Macfusion)</li>
</ol>
## Installing MacFuse
MacFuse is an OS X implementation of the <a title="Filesystem in Userspace (Wikipedia)" href="http://en.wikipedia.org/wiki/Filesystem_in_Userspace" target="_blank">Filesystem in Userspace</a> (FUSE) framework. FUSE provides an API to write a virtual file system. Variations of the virtual file system include:
<ul>
	<li>PicasawebFS, for manipulation images in a Picasa account like they were stored on your local machine</li>
	<li>RSSFS, which allows you to mount an RSS feed as a filesystem and access each entry as an individual file</li>
	<li>SSHFS, or the Secure Shell Filesystem, which allows you to mount a remote computer directory through a secure shell (SSH) login.</li>
</ul>
<strong>Download and install MacFuse from Google Code:</strong> <a title="MacFUSE" href="http://code.google.com/p/macfuse" target="_blank">http://code.google.com/p/macfuse</a>

At present the preference pane that MacFuse installs is 32-bit, so your System Preferences will restart in 32-bit mode when you select the MacFuse pane. The only option it exposes is a check for updates.
## Installing Macfusion
Macfusion is an open source SSHFS mounting application for Mac OS X.

<strong>Download and install from:</strong> <a title="Macfusion" href="http://www.macfusionapp.org" target="_blank">http://www.macfusionapp.org </a>
### Setting up an SSHFS file system
Once Macfusion is installed, start the application and click on the plus icon in the bottom left of the main window and choose SSHFS.

<img class="aligncenter size-full wp-image-2161" title="Macfusion_sshfs" src="http://zanshin.net/wp-content/uploads/2009/11/Macfusion_sshfs.png" alt="Macfusion_sshfs" width="513" height="202" />
### Set SSHFS mount parameters
Under the <strong>SSH</strong> tab:
<ul>
	<li><strong>Host:</strong> The _hostname_ of the server that you SSH to.</li>
	<li><strong>User name:</strong> Your SSH username.</li>
	<li><strong>Password:</strong> Your SSH password. (At present I don't know how to enable this via SSH Keys.)</li>
	<li><strong>Path:</strong> This can be left blank.</li>
</ul>
<img class="aligncenter size-full wp-image-2162" title="Macfusion_ssh_tab" src="http://zanshin.net/wp-content/uploads/2009/11/Macfusion_ssh_tab.png" alt="Macfusion_ssh_tab" width="499" height="321" />

Under the <strong>SSH Advanced</strong> tab:
<ul>
	<li><strong>Port:</strong> The default SSH port is 22 unless the server uses a different one.</li>
	<li><strong>Follow Symbolic Links:</strong> Leave this checked</li>
</ul>
<img class="aligncenter size-full wp-image-2163" title="Macfusion_ssh_advanced_tab" src="http://zanshin.net/wp-content/uploads/2009/11/Macfusion_ssh_advanced_tab.png" alt="Macfusion_ssh_advanced_tab" width="494" height="326" />

Under the <strong>Macfusion</strong> tab:
<ul>
	<li><strong>Mount Point and Volume Name:</strong> Can be left blank.</li>
	<li><strong>Ignore Apple Double Files:</strong> You must uncheck this if you plan to <em>open/edit/save</em> files on the mounted volume. While allowing for remote editing of files is a powerful feature there is a downside. Mac OS X will place .DS_Store and ._* (Apple double) files on the server. OS X utilizes these hidden files for enhanced filesystem features and extended attributes in non-OS X filesystems. Since they start with a dot (.) these files should be invisible on the remote system. You may leave this option checked if you only plan to <em>copy/move/delete</em> files (it will also increase speed).</li>
	<li><strong>Enable Negative VNode Cache:</strong> This is an optimization to increase speed and should generally be left checked, <strong>unless</strong> files can appear on the mounted volume from the server side of the connection. For example, if multiple users are using your mounted disk space leave this unchecked.</li>
</ul>
<img class="aligncenter size-full wp-image-2164" title="Macfusion_macfusion_tab" src="http://zanshin.net/wp-content/uploads/2009/11/Macfusion_macfusion_tab.png" alt="Macfusion_macfusion_tab" width="494" height="391" />
## Mounting the Remote filesystem
You are now ready to mount the SSHFS on your desktop. Click on the mount button and if the SSH settings are correct you should have a green disk icon mounted on the desktop. (Note, you may need to visit the Finder preferences to make sure that you are allowing *Connected Servers* to be displayed.)  You should now be able to access the remote files as if they were on an external disk attached to your system. You can copy, move, rename, and delete files. Remember, that in order to edit files you must <strong>uncheck </strong>the <em>Ignore Apple Double Files</em> option. This can only be done with the remote filesystem is unmounted.
### sshnodelay.so Error
If the mount operation fails, click the gear icon in the Macfusion main window and select the Log option (or use Cmd-L with Macfusion as the active application). If you see the following error message:

<p style="text-align: center;"><img class="aligncenter size-full wp-image-2165" title="Macfusion_log_viewer" src="http://zanshin.net/wp-content/uploads/2009/11/Macfusion_log_viewer.png" alt="Macfusion_log_viewer" width="452" height="274" /></p>

Then you need to rename or remove that library. Navigate to the <strong>/Applications/Macfusion.app/Contents/Plugins/sshfs.mfplugin/Contents/Resources</strong> directory and rename (e.g., sshnodelay.orig) or remove the sshnodelay.so file.
<p style="text-align: center;"><img class="aligncenter size-full wp-image-2166" title="Macfusion_rename_sshnodelay" src="http://zanshin.net/wp-content/uploads/2009/11/Macfusion_rename_sshnodelay.png" alt="Macfusion_rename_sshnodelay" width="577" height="136" /></p>

## Update SSHFS
Now that you have a working connection it is time to verify the version of sshfs included with Macfusion, and update it if necessary.   Using the Terminal, navigate to:

The copy of sshfs that Macfusion uses is located in this directory. Run the command:

to verify the installed version. As of this writing the current available version of sshfs was 2.2, if the displayed version is anything less than that, you will see a performance increase by updating.

<strong>Download SSHFS from: </strong><a title="sshfs download" href="http://code.google.com/p/macfuse/wiki/MACFUSE_FS_SSHFS" target="_blank">http://code.google.com/p/macfuse/wiki/MACFUSE_FS_SSHFS </a>

For Mac OS X 10.6 you want to get the <strong>sshfs-static-leopard.gz</strong> file. Uncompress the gzip archive. Inside the resulting sshfs-binaries folder will be an application called <em>sshfs-static-leopard</em>.  In Terminal rename the original sshfs-static application (assuming you are still in the /Applications/Macfusion/Contents/Plugins/sshfs.mfplugin/Contents/Resources directory):

And then copy the new version into place:

This should result in a significant performance increase.
## Preventing .DS_Store files over Network Connections
You can prevent .DS_Store files from being created on the mounted filesystem by executing the following command in Terminal:

This will affect interactions with SMB/CIFS, AFP, NFS, and WebDav servers.  You will need to restart the computer or log out and back in to your user account for this change to take effect.
