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

RUN apk -U add ca-certificates fuse wget dcron tzdata curl \
  && rm -rf /var/cache/apk/*

COPY entrypoint.sh /
COPY sync.sh /

VOLUME ["/logs"]

ENTRYPOINT ["/entrypoint.sh"]

CMD [""]