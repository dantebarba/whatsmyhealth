ARG BASE=alpine:3.9
FROM ${BASE}

LABEL maintainer="dantebarba"

ENV TEST_URL=
ENV OUTPUT_LOG=
ENV ROTATE_LOG=
ENV CRON=
ENV FORCE_TEST=
ENV CHECK_URL=
ENV FAIL_URL=
ENV TZ=
ENV LOG_LEVEL=0

RUN apk -U add ca-certificates wget dcron tzdata curl \
  && rm -rf /var/cache/apk/*

COPY entrypoint.sh /
COPY sync.sh /

VOLUME ["/tmp"]

ENTRYPOINT ["/entrypoint.sh"]

CMD [""]