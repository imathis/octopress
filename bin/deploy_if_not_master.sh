#!/bin/bash

LIFECYCLE_CONFIG='http://util.cwebber.net/15_day_expire.json'

if [[ "${CI_BRANCH}" -ne "master" ]]; then

  # Note to self: When you burn yourself because you are not dealing with www
  # and underscores, remember... you did it to yourself

  pip install awscli
  aws s3 rm s3://${CI_BRANCH}.cwebber.net --recursive
  aws s3 sync public s3://${CI_BRANCH}.cwebber.net --acl public-read
  aws s3api put-bucket-lifecycle --bucket ${CI_BRANCH}.cwebber.net --lifecycle-configuration $LIFECYCLE_CONFIG

fi

