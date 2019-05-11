#!/bin/sh

set -e

echo "INFO: Starting sync.sh pid $$ $(date)"

# Delete logs by user request
if [ ! -z "${ROTATE_LOG##*[!0-9]*}" ]
then
  echo "INFO: Removing logs older than $ROTATE_LOG day(s)..."
  find /tmp/*.log -mtime +$ROTATE_LOG -type f -delete
fi


echo $$ > /tmp/sync.pid

export TEST_CODE=200
    if [ ! -z "$TEST_URL" ] 
    then
      TEST_CODE=-1
      TEST_CODE=$(curl -o /dev/null -s -w "%{http_code}\n" $TEST_URL)
      echo "INFO: Test output: $TEST_CODE"
    fi
    if [ -z "$CHECK_URL" ]
    then
      echo "INFO: Define CHECK_URL with https://healthchecks.io to monitor health"
    else
      if [ "$TEST_CODE" == 200 ]
      then
        wget $CHECK_URL -O /dev/null
      else
        wget $FAIL_URL -O /dev/null
      fi
    fi

rm -f /tmp/sync.pid
