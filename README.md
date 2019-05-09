# What's my health?

A simple docker container to make healthchecks. Based on healthchecks.io

## Usage

- Run it!

`docker run -it --rm -e  CRON="* * * * *" -e CHECK_URL="http://healthchecks.io/myurl" -e TZ="America/Argentina/Buenos_Aires" -e TEST_URL="https://httpstat.us/200" dantebarba/whatsmyhealth:latest`

## Docker compose example

## Parameters

```
- TEST_URL: Url to be checked using curl. Expects HTTP 200. It will fail if status code is different than 200.
- OUTPUT_LOG: Output log name.
- ROTATE_LOG: Log rotation by date.
- CRON: The cron expression. Works with cron shortcuts to (@daily, @weekly, @monthly)
- FORCE_TEST: If set to 1, it forces a test upon start
- CHECK_URL: The healthchecks.io url.
- FAIL_URL: Allows to define a custom /fail url. Uses $CHECK_URL/fail by default.
- TZ: Timezone for cronjobs. For example America/Argentina/Buenos_Aires
```






