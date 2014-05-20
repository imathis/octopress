#!/bin/bash

LIFECYCLE_CONFIG='http://util.cwebber.net/15_day_expire.json'
SNS_ARN='arn:aws:sns:us-east-1:020417111620:cwebber-net-stage'

if [ "${CI_BRANCH}" != "master" ]; then

  echo "Deploying ${CI_BRANCH}.cwebber.net"

  # Note to self: When you burn yourself because you are not dealing with www
  # and underscores, remember... you did it to yourself

  pip install awscli
  aws s3 mb s3://${CI_BRANCH}.cwebber.net
  aws s3 rm s3://${CI_BRANCH}.cwebber.net --recursive
  aws s3 sync public s3://${CI_BRANCH}.cwebber.net --acl public-read
  aws s3api put-bucket-lifecycle --bucket ${CI_BRANCH}.cwebber.net --lifecycle-configuration $LIFECYCLE_CONFIG
  aws s3 website s3://${CI_BRANCH}.cwebber.net --index-document index.html
  aws sns publish --topic-arn $SNS_ARN --subject '[cwebber.net] Staging Deploy' \
    --message "Deploy of branch $CI_BRANCH can be viewed at http://${CI_BRANCH}.cwebber.net.s3-website-us-east-1.amazonaws.com/"

fi
