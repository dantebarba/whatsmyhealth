#!/bin/sh

set -e

# Re-write cron shortcut
case "$(echo "$CRON" | tr '[:lower:]' '[:upper:]')" in
*@YEARLY*) echo "INFO: Cron shortcut $CRON re-written to 0 0 1 1 *" && CRONS="0 0 1 1 *" ;;
*@ANNUALLY*) echo "INFO: Cron shortcut $CRON re-written to 0 0 1 1 *" && CRONS="0 0 1 1 *" ;;
*@MONTHLY*) echo "INFO: Cron shortcut $CRON re-written to 0 0 1 * *" && CRONS="0 0 1 * * " ;;
*@WEEKLY*) echo "INFO: Cron shortcut $CRON re-written to 0 0 * * 0" && CRONS="0 0 * * 0" ;;
*@DAILY*) echo "INFO: Cron shortcut $CRON re-written to 0 0 * * *" && CRONS="0 0 * * *" ;;
*@MIDNIGHT*) echo "INFO: Cron shortcut $CRON re-written to 0 0 * * *" && CRONS="0 0 * * *" ;;
*@HOURLY*) echo "INFO: Cron shortcut $CRON re-written to 0 * * * *" && CRONS="0 * * * *" ;;
*@*) echo "WARNING: Cron shortcut $CRON is not supported. Stopping." && exit 1 ;;
*) CRONS=$CRON ;;
esac

# Set time zone if passed in
if [ ! -z "$TZ" ]; then
  cp /usr/share/zoneinfo/$TZ /etc/localtime
  echo $TZ >/etc/timezone
fi

rm -f /tmp/sync.pid

# SYNC_SRC and SYNC_DEST setup
# run sync either once or in cron depending on CRON

#Create fail URL if CHECK_URL is populated but FAIL_URL is not
if [ ! -z "$CHECK_URL" ] && [ -z "$FAIL_URL" ]; then
  FAIL_URL="${CHECK_URL}/fail"
fi

if [ -z "$CRONS" ]; then
  echo "INFO: No CRON setting found. Running sync once."
  echo "INFO: Add CRON=\"0 0 * * *\" to perform sync every midnight"
  /sync.sh
else
  if [ -z "$FORCE_TEST" ]; then
    echo "INFO: Add FORCE_TEST=1 to perform a test upon boot"
  else
    /sync.sh
  fi

  # Setup logs
  echo "INFO: Log file output to $LOG_FILE"

  # Setup cron schedule
  crontab -d
  echo "$CRONS /sync.sh >> $LOG_FILE 2>&1" >/tmp/crontab.tmp
  echo "TEST_URL is: $TEST_URL"
  crontab /tmp/crontab.tmp
  rm /tmp/crontab.tmp

  # Start cron
  echo "INFO: Starting crond ..."
  touch /tmp/crond.log
  touch $LOG_FILE
  crond -b -l $LOG_LEVEL -L /tmp/crond.log
  tail -F /tmp/crond.log $LOG_FILE
fi
