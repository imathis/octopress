#!/bin/bash

# I don't know how better to specify "the root of this project"
PLUGIN_PRODUCTION_CODE_ROOT="."
# Avoid running @future specs (marked with :future => true)
bundle exec rspec -I $PLUGIN_PRODUCTION_CODE_ROOT -t ~future spec
