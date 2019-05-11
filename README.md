# What's my health? [![Build Status](https://travis-ci.org/dantebarba/whatsmyhealth.svg?branch=master)](https://travis-ci.org/dantebarba/whatsmyhealth)

**Whatsmyhealth** is a Docker image to perform a healthcheck over a HTTP service based on a cron schedule, with [healthchecks.io](https://healthchecks.io) monitoring.

If no service is specified, the script will send an OK ping to the provided url. 

The idea came from the need to monitor the connection of my NAS, and integrate an alert system like healthchecks.io, which provides different connections to different providers (Email, Telegram, Slack...)

It is based on and inspired by **Brian J. Cardiff project @ https://github.com/bcardiff/docker-rclone**

## Usage

### Docker example

```bash
docker run -it --rm -e  CRON="* * * * *" -e CHECK_URL="http://healthchecks.io/myurl" -e TZ="America/Argentina/Buenos_Aires" -e TEST_URL="https://httpstat.us/200" dantebarba/whatsmyhealth:latest
```

### Docker compose example

```yml
version: '2'

services:
  nas-health-status:
    image: dantebarba/whatsmyhealth
    container_name: nas-health-status
    environment:
      CHECK_URL: https://hc-ping.com/myurl
      TEST_URL: http://httpstat.us/200
      TZ: 'America/Argentina/Buenos_Aires'
      CRON: '* * * * *'
```

### Options

A few environment variables allow you to customize the behavior:

- `TEST_URL`: url to be checked using curl. Expects `HTTP 200`. It will fail if status code is different than `200`.
* `OUTPUT_LOG`: set variable to output log file to /logs
* `ROTATE_LOG`: set variable to delete logs older than specified days from /logs
* `CRON`: crontab schedule `0 0 * * *` to perform sync every midnight. Also supprorts cron shortcuts: `@yearly` `@monthly` `@weekly` 
- `FORCE_TEST`: forces test upon start. Defaults to `0`.
- `CHECK_URL`: the healthchecks.io url.
- `FAIL_URL`: allows to define a custom /fail url. Uses `$CHECK_URL/fail` by default.
- `TZ`: set the [timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) to use for the cron and log `America/Argentina/Buenos_Aires`
- `LOG_LEVEL`: set the log-level of crond. Defaults to 0. 

  Log levels available:

  ```bash
  -l emerg or panic  LOG_EMERG   0   [* system is unusable *]
  -l alert           LOG_ALERT   1   [* action must be taken immediately *]
  -l crit            LOG_CRIT    2   [* critical conditions *]
  -l error or err    LOG_ERR     3   [* error conditions *]
  -l warn or warning LOG_WARNING 4   [* warning conditions *]
  -l notice          LOG_NOTICE  5   [* normal but significant condition *] the default
  -l info            LOG_INFO    6   [* informational *]
  -l debug           LOG_DEBUG   7   [* debug-level messages *] same as -d option 
  ```









