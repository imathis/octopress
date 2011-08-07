--- 
layout: post
comments: "false"
title: Installing PostgreSQL on Mac 10.6 (Snow Leopard)
date: 2009-9-7
link: "false"
categories: life
---
These steps will install PostgreSQL in /usr/local.
<ol>
	<li>Download source from <a title="PostgreSQL source" href="http://www.postgresql.org/ftp/source/">http://www.postgresql.org/ftp/source/</a></li>
	<li>Unpack it somewhere convenient and change to that directory.</li>
	<li>Configure using the default installation location (/usr/local/pgsql) and a minimal set of options.</li>

	<li>Run make</li>

	<li>And finally, make install. For /usr/local installation this will need sudo.

</li>
</ol>
PostgreSQL should now be installed in /usr/local/pgsql.
## Post Installation steps
<ol>
	<li>Add the PostgreSQL bin directory to Path and export by adding the following to your .bash_profile or .profile:

</li>
	<li>Create a directory to hold the database installation.</li>

	<li>Create a postgres user and a postgres group. Change ownership of the pgsql directory to postgres. PostgreSQL cannot be access by root (a security measure, one assumes). (Snow Leopard (10.6) eliminates the netinfo tool, so you get to build the group on the command line.)
First find an unused User ID. The following command shows IDs already in use.

Next find an unused Group ID, again the following command shows IDs already in use.
<pre>$ dscl . -list /Groups PrimaryGroupID | awk '{print $2}' | sort -n</pre>
</li>
	<li>On the my system 103 was available in both lists, the rest of these directions assume you are using the same number. The following commands create the group and the user and set the user’s home directory to the pgsql folder.</li>

I was forced to visit the Accounts preference pane in System Preferences to reset the password for the postgres account. For reasons I don't understand setting it via the dscl command failed.
	<li>Finally, give the postgres user ownership of the /usr/local/pgsql directory:</li>

	<li>Now you can switch users to the postgres account and run the initdb command to create a database installation. The command is:

The output should look something like:</li>

	<li>Now you can start up the database server. I prefer the second of the two command examples shown at the end of the initialization step above:</li>

As it starts the database server in the background, thus freeing up your console for other uses.

To stop a server running in the background you can type:

	<li>Now you can create a database. Make sure you are operating as the *postgres* user, and issue the _createdb_ command.</li>

	<li>Connect to the database, and start experimenting with SQL commands.</li>

</ol>
## Miscellaneous
The best graphical user interface I've found for administering PostgreSQL is <a title="pgAdmin" href="http://www.pgadmin.org/" target="_blank">pgAdmin</a>. You can <a title="pgAdmin download" href="http://www.pgadmin.org/download/macosx.php" target="_blank">download it here</a>.

The postgres user account will appear in the fast user switching (FUS) list and as an account on the login screen. To hide the account on the login screen run the following command:
<ol>

</ol>
While this will hide postgres from the login window it will not hide it from the FUS list. Additionally, the list of accounts on the login window will have an "Other..." entry which will allow you to access the hidden account.

To unhide all accounts:
<ol>

</ol>
