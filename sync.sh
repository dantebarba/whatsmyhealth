#!/bin/sh

set -e

echo "INFO: Starting sync.sh pid $$ $(date)"

# Delete logs by user request
if [ ! -z "${ROTATE_LOG##*[!0-9]*}" ]
then
  echo "INFO: Removing logs older than $ROTATE_LOG day(s)..."
  find /logs/*.txt -mtime +$ROTATE_LOG -type f -delete
fi


echo $$ > /tmp/sync.pid

export TEST_CODE=200
    if [ ! -z "$TEST_URL" ] 
    then
      TEST_CODE=-1
      if [ ! -z "$OUTPUT_LOG" ]
      then
        d=$(date +%Y_%m_%d-%H_%M_%S)
        LOG_FILE="/logs/$d.txt"
        echo "INFO: Log file output to $LOG_FILE"
        echo "INFO: Doing ping"
        TEST_CODE=$(curl -o /dev/null -s -w "%{http_code}\n" $TEST_URL 2>&1 | tee $LOGFILE)
        
      else
        echo "INFO: Doing ping"
        TEST_CODE=$(curl -o /dev/null -s -w "%{http_code}\n" $TEST_URL)
        
      fi
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
