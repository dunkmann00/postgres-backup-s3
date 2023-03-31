#! /bin/bash

set -eo pipefail

if [ "${S3_S3V4}" = "yes" ]; then
    aws configure set default.s3.signature_version s3v4
fi

if [ "${SCHEDULE}" = "**None**" ]; then
  /usr/src/backup.sh
else
  echo -e "${SCHEDULE} /usr/src/backup.sh > /proc/1/fd/1 2> /proc/1/fd/2\n" > /usr/src/backup-crontab
  crontab /usr/src/backup-crontab
  exec cron -f
fi
