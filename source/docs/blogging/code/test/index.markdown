---
layout: page
title: Syntax Highlighting Test
footer: false
sidebar: false
---

{% include_code javascripts/test.js %}

``` html
    <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
    <html><head>
    <title>A Tiny Page</title>
    <style type="text/css">
    <!--
          p { font-size:15pt; color:#000 }
        -->
    </style></head><!-- real comment -->
    <body bgcolor="#FFFFFF" text="#000000" link="#0000CC">
    <script language="javascript" type="text/javascript">
          function changeHeight(h) {
            var tds = document.getElementsByTagName("td");
            for(var i = 0; i < tds.length; i++) {
              tds[i].setAttribute("height", h + "px");
          }}
    </script>
    <h1>abc</h1>
    <h2>def</h2>
    <p>Testing page</p>
    </body></html>
```

{% gist 996818 %}

{% codeblock Testing PHP (syntax_test.php) %}
<?php
require_once($GLOBALS['g_campsiteDir']. "/$ADMIN_DIR/country/common.php");
require_once($GLOBALS['g_campsiteDir']. "/classes/SimplePager.php");
camp_load_translation_strings("api");

$f_country_language_selected = camp_session_get('f_language_selected', '');
$f_country_offset = camp_session_get('f_country_offset', 0);
if (empty($f_country_language_selected)) {
	$f_country_language_selected = null;
}
$ItemsPerPage = 20;
$languages = Language::GetLanguages(null, null, null, array(), array(), true);
$numCountries = Country::GetNumCountries($f_country_language_selected);

$pager = new SimplePager($numCountries, $ItemsPerPage, "index.php?");

$crumbs = array();
$crumbs[] = array(getGS("Configure"), "");
$crumbs[] = array(getGS("Countries"), "");
echo camp_html_breadcrumbs($crumbs);

?>

<?php  if ($g_user->hasPermission("ManageCountries")) { ?>
<table BORDER="0" CELLSPACING="0" CELLPADDING="1">
    <tr>
        <td><a href="add.php"><?php putGS("Add new"); ?></a></td>
    </tr>
</table>
{% endcodeblock %}

{% codeblock Testing Objective C (Cocoa1AppDelegate.m) %}

#import "Cocoa1AppDelegate.h"

@implementation Cocoa1AppDelegate

@synthesize window,siteUrl,pageContents;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    model = [[Cocoa1Model alloc] init];
}

- (IBAction)getSiteContents:(id)sender {
    [model setPageUrl:[siteUrl stringValue]];
    NSString* reply = [model getUrlAsString];
    NSLog(@"pageSrc: %@", reply);
    [pageContents setString:reply];
    [[[pageContents textStorage] mutableString] appendString:reply];
}

@end
{% endcodeblock %}


{% codeblock Testing Haskel (syntax_test.hs) %}
{-# LANGUAGE OverloadedStrings #-}
module Main where

--import Prelude hiding (id)
--import Control.Category (id)
import Control.Arrow ((>>>), (***), arr)
import Control.Monad (forM_)
-- import Data.Monoid (mempty, mconcat)

-- import System.FilePath

import Hakyll


main :: IO ()
main = hakyll $ do

    route   "css/*" $ setExtension "css"
    compile "css/*" $ byExtension (error "Not a (S)CSS file")
        [ (".css",  compressCssCompiler)
        , (".scss", sass)
        ]

    route   "js/**" idRoute
    compile "js/**" copyFileCompiler

    route   "img/*" idRoute
    compile "img/*" copyFileCompiler

    compile "templates/*" templateCompiler

    forM_ ["test.md", "index.md"] $ \page -> do
        route   page $ setExtension "html"
        compile page $ pageCompiler
            >>> applyTemplateCompiler "templates/default.html"
            >>> relativizeUrlsCompiler

sass :: Compiler Resource String
sass = getResourceString >>> unixFilter "sass" ["-s", "--scss"]
                         >>> arr compressCss

{% endcodeblock %}

{% codeblock Testing Bash (syntax_test.sh) %}
#!/bin/bash

cd $ROOT_DIR
DOT_FILES="lastpass weechat ssh Xauthority"
for dotfile in $DOT_FILES; do conform_link "$DATA_DIR/$dotfile" ".$dotfile"; done

# TODO: refactor with suffix variables (or common cron values)

case "$PLATFORM" in
	linux)
        #conform_link "$CONF_DIR/shell/zshenv" ".zshenv"
        crontab -l > $ROOT_DIR/tmp/crontab-conflict-arch
        cd $ROOT_DIR/$CONF_DIR/cron
        if [[ "$(diff ~/tmp/crontab-conflict-arch crontab-current-arch)" == ""
            ]];
            then # no difference with current backup
                logger "$LOG_PREFIX: crontab live settings match stored "\
                    "settings; no restore required"
                rm ~/tmp/crontab-conflict-arch
            else # current crontab settings in file do not match live settings
                crontab $ROOT_DIR/$CONF_DIR/cron/crontab-current-arch
                logger "$LOG_PREFIX: crontab stored settings conflict with "\
                    "live settings; stored settings restored. "\
                    "Previous settings recorded in ~/tmp/crontab-conflict-arch."
        fi
    ;;

{% endcodeblock %}

{% codeblock Testing Python (syntax_test.py) %}
# test python (sample from offlineimap)

class ExitNotifyThread(Thread):
    """This class is designed to alert a "monitor" to the fact that a thread has
    exited and to provide for the ability for it to find out why."""
    def run(self):
        global exitthreads, profiledir
        self.threadid = thread.get_ident()
        try:
            if not profiledir:          # normal case
                Thread.run(self)
            else:
                try:
                    import cProfile as profile
                except ImportError:
                    import profile
                prof = profile.Profile()
                try:
                    prof = prof.runctx("Thread.run(self)", globals(), locals())
                except SystemExit:
                    pass
                prof.dump_stats( \
                            profiledir + "/" + str(self.threadid) + "_" + \
                            self.getName() + ".prof")
        except:
            self.setExitCause('EXCEPTION')
            if sys:
                self.setExitException(sys.exc_info()[1])
                tb = traceback.format_exc()
                self.setExitStackTrace(tb)
        else:
            self.setExitCause('NORMAL')
        if not hasattr(self, 'exitmessage'):
            self.setExitMessage(None)

        if exitthreads:
            exitthreads.put(self, True)

    def setExitCause(self, cause):
        self.exitcause = cause
    def getExitCause(self):
        """Returns the cause of the exit, one of:
        'EXCEPTION' -- the thread aborted because of an exception
        'NORMAL' -- normal termination."""
        return self.exitcause
    def setExitException(self, exc):
        self.exitexception = exc
    def getExitException(self):
        """If getExitCause() is 'EXCEPTION', holds the value from
        sys.exc_info()[1] for this exception."""
        return self.exitexception
    def setExitStackTrace(self, st):
        self.exitstacktrace = st
    def getExitStackTrace(self):
        """If getExitCause() is 'EXCEPTION', returns a string representing
        the stack trace for this exception."""
        return self.exitstacktrace
    def setExitMessage(self, msg):
        """Sets the exit message to be fetched by a subsequent call to
        getExitMessage.  This message may be any object or type except
        None."""
        self.exitmessage = msg
    def getExitMessage(self):
        """For any exit cause, returns the message previously set by
        a call to setExitMessage(), or None if there was no such message
        set."""
        return self.exitmessage

{% endcodeblock %}

{% codeblock Testing Perl (syntax_test.pl) %}
#!perl -w

# Time-stamp: <2002/04/06, 13:12:13 (EST), maverick, csvformat.pl>
# Two pass CSV file to table formatter

$delim = $#ARGV >= 1 ? $ARGV[1] : ',';
print STDERR "Split pattern: $delim\n";

# first pass
open F, "<$ARGV[0]" or die;
while(<F>)
{
  chomp;
  $i = 0;
  map { $max[$_->[1]] = $_->[0] if $_->[0] > ($max[$_->[1]] || 0) }
    (map {[length $_, $i++]} split($delim));
}
close F;

print STDERR 'Field width:   ', join(', ', @max), "\n";
print STDERR join(' ', map {'-' x $_} @max);

# second pass
open F, "<$ARGV[0]" or die;
while(<F>)
  {
  chomp;
  $i = 0;
  map { printf("%-$max[$_->[1]]s ", $_->[0]) }
    (map {[$_, $i++]} split($delim));
  print "\n";
}
close F;

{% endcodeblock %}

{% codeblock Test Java (syntax_test.java) %}
import java.util.Map;
import java.util.TreeSet;

public class GetEnv {
  /**
   * let's test generics
   * @param args the command line arguments
   */
  public static void main(String[] args) {
    // get a map of environment variables
    Map<String, String> env = System.getenv();
    // build a sorted set out of the keys and iterate
    for(String k: new TreeSet<String>(env.keySet())) {
      System.out.printf("%s = %s\n", k, env.get(k));
    }
  }    }
{% endcodeblock %}

{% codeblock Test C (syntax_test.c) %}
#define UNICODE
#include <windows.h>

int main(int argc, char **argv) {
  int speed = 0, speed1 = 0, speed2 = 0; // 1-20
  printf("Set Mouse Speed by Maverick\n");

  SystemParametersInfo(SPI_GETMOUSESPEED, 0, &speed, 0);
  printf("Current speed: %2d\n", speed);

  if (argc == 1) return 0;
  if (argc >= 2) sscanf(argv[1], "%d", &speed1);
  if (argc >= 3) sscanf(argv[2], "%d", &speed2);

  if (argc == 2) // set speed to first value
    speed = speed1;
  else if (speed == speed1 || speed == speed2) // alternate
    speed = speed1 + speed2 - speed;
  else
    speed = speed1;  // start with first value

  SystemParametersInfo(SPI_SETMOUSESPEED, 0,  speed, 0);
  SystemParametersInfo(SPI_GETMOUSESPEED, 0, &speed, 0);
  printf("New speed:     %2d\n", speed);
  return 0;
}

{% endcodeblock %}
