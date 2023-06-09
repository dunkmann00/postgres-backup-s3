FROM debian:11-slim
LABEL maintainer="George Waters <gwatersdev@gmail.com>"

RUN apt-get -y update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    gnupg lsb-release wget cron awscli

# Add the PostgreSQL Apt Repository
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' && \
    mkdir -p /etc/apt/keyrings/ && \
    wget --quiet -O- https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
    gpg -o /etc/apt/keyrings/postgres.gpg --dearmor && \
    echo "deb [ signed-by=/etc/apt/keyrings/postgres.gpg ] http://apt.postgresql.org/pub/repos/apt/ bullseye-pgdg main 15" | \
    tee /etc/apt/sources.list.d/pgdg.list

RUN apt-get -y update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    postgresql-client-15

ENV POSTGRES_DATABASE **None**
ENV POSTGRES_BACKUP_ALL **None**
ENV POSTGRES_HOST **None**
ENV POSTGRES_PORT 5432
ENV POSTGRES_USER **None**
ENV POSTGRES_PASSWORD **None**
ENV POSTGRES_EXTRA_OPTS ''
ENV S3_ACCESS_KEY_ID **None**
ENV S3_SECRET_ACCESS_KEY **None**
ENV S3_BUCKET **None**
ENV S3_REGION us-west-1
ENV S3_PATH 'backup'
ENV S3_ENDPOINT **None**
ENV S3_S3V4 no
ENV SCHEDULE **None**
ENV ENCRYPTION_PASSWORD **None**

RUN mkdir -p /usr/src
WORKDIR /usr/src

COPY run.sh /usr/src/run.sh
COPY backup.sh /usr/src/backup.sh

CMD ["/usr/src/run.sh"]
