--- 
layout: post
author: Mark
comments: "false"
title: Installing Tchibo Internet Stick on Mac OS X
date: 2010-5-28
categories: life
---
In order to enable Internet access while we are in Germany without having to rely upon Internet cafés or access to (usually per-per-use) WiFi, Sibylle and I invested 50 € in a Tchibo Internet Stick. Tchibo is nominally a coffee company, selling fresh ground beans and other coffee related items. However they also sell some small electronics including a USB based mobile modem.

Sibylle purchased the device in March when she was in Germany and successfully used it for a week to access the Internet. The only glitch she experienced was the registration process. Unless you follow the included instructions carefully and register your device within the first 24-hours of use, the time you purchased reverts to a by-the-hour billing plan. This meant that she used up  20 € in a day. By completing the registration that same 20 € pays for one month of "flat rate" service. Sibylle was able to speak to a helpful service representative at Tchibo and convert the plan from hourly to the flat rate plan so the 20 € wasn't lost. More on Tchibo's service representatives in a minute.

On our current trip we both are here with a total of three Internet capable devices: my MacBook Pro, her HP laptop, and her iPod Touch. Our planning was to connect one of the laptops to the Internet via the Tchibo and share that connection for the other two. Our first stop in Stuttgart after arriving with the Tchibo store at the Stadtmitte stop on the S-Bahn. For 20 € we bought a new month's worth of service. At a nearby Starbucks we plugged in and added the new time only to gain no access. Tired and frustrated we packed up and made our way to Leutenbach where we tried again. This time everything worked. Our guess is that adding additional time takes a while to register and trickle down to the account.

I was unsuccessful in sharing the connection from her Vista machine. The various sites I looked at had detailed instructions that never quite lined up with the dialogs I was seeing. Abandoning that idea I next tried to use the Tchibo on my MacBook Pro. While the device mounted and showed a package, I wasn't able to run the package successfully. After a night's sleep we called the service number to ask for help.

In the United States we are used to hearing the phrase "this call may be recorded for quality assurance purposes" and consequently don't really stop to think about what that means. While I don't speak Germany, Sibylle assures me that no such phrase is uttered when you call Tchibo. I lost track of how many times I called, perhaps 8? 10? Several calls I ended in frustration as the person I reached spoke no English as wasn't willing to transfer me to someone else. One suggested in very broken English that I needed to call the hotline, which is how I ended up talking to him in the first place.

Two of the calls resulted in English speakers, and between them I managed to figure out how to get things working.
## Step One: Get the Installer
The Tchibo Internet Stick, or Surf Stick, is really from O2, so searching the Internet for "Tchibo" and Mac OS X don't really help. Tchibo has no drivers or installers on their site either. You have to go to the O2 site to find the installer necessary. Here's the page where I got the installer for Mac OS X 10.6:

<a title="O2 Surf Stick Installers" href="http://portal.o2online.de/nw/support/downloads/software/surfsticks/loopsurfstick/loop-surfstick.html" target="_blank">http://portal.o2online.de/nw/support/downloads/software/surfsticks/loopsurfstick/loop-surfstick.html</a>
## Step Two: Run the Installer
Once the download competes and has been unzipped, you need to attach the Tchibo USB device to the Mac before running the installer - it contains the package the installer actually installs. With the USB plugged in run the installer and follow the prompts. My installer included an English language PDF complete with screen shots showing the installation process. When it asks for the package to install, point to the "Mobil Provider" file on the USB device.

After the install completes you will see two new devices added to System Preferences under the Network preference pane.
## Step Three: Configure and Run
Select the HUAWEI Modem listed on the Network preference pane and set the phone number to be "*99#" (without the quotes). That's star-nine-nine-hash. Leave the account name and password blank.

Next go to your Applications folder and run the "Mobil Partner" application located in the "Mobil Partner" folder. This application will ask for your PIN number, which should be on the plastic card where you punched out the SIM installed in the USB stick.

I was told that the APN or access point name was "webmobil1" (no quotes) but I was never asked for that nor did I have to enter it anywhere. I suspect that since our Tchibo was originally installed and configured on a Windows machine that the SIM already knew the access point information.
## Step Four: Share and Enjoy
Once the Tchibo Mobil Partner application is running you should be online. If you check the "show modem status in menu bar" option on the HUAWEI configure in System Preferences, you'll be able to see your connection time at a glance.

From the Sharing preference pane you can opt to share your connection via Ethernet or Wifi. I was able to share our connection via Wifi and everything worked on both computers. It's not the fasted connection in the world, but it is enough for email and web browsing.
