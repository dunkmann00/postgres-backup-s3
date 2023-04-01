#! /bin/bash

set -eo pipefail

if [ "${S3_S3V4}" = "yes" ]; then
    aws configure set default.s3.signature_version s3v4
fi

if [ "${SCHEDULE}" = "**None**" ]; then
  echo "No schedule, running backup now..."
  /usr/src/backup.sh
else
  echo "Found schedule, adding to crontab..."

  # Dump environment variables into .env file
  env > .env
  sed -i '/^SCHEDULE=.*/d' .env # Remove SCHEDULE variable, causes problems because of the spaces

  echo -e "SHELL=/bin/bash\nBASH_ENV=/usr/src/.env\n\n${SCHEDULE} /usr/src/backup.sh > /proc/1/fd/1 2> /proc/1/fd/2\n" >> /usr/src/backup-crontab
  crontab /usr/src/backup-crontab
  echo "Starting cron..."
  exec cron -f
fi
