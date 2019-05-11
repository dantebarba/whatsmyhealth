ARG BASE=alpine:3.9
FROM ${BASE}

LABEL maintainer="dantebarba"

ENV TEST_URL=
ENV CRON=
ENV FORCE_TEST=
ENV CHECK_URL=
ENV FAIL_URL=
ENV TZ=
ENV LOG_LEVEL=0
ENV LOG_FILE="/tmp/sync.log"

RUN apk -U add ca-certificates wget dcron tzdata curl \
  && rm -rf /var/cache/apk/*

COPY entrypoint.sh /
COPY sync.sh /

VOLUME ["/tmp"]

ENTRYPOINT ["/entrypoint.sh"]

CMD [""]