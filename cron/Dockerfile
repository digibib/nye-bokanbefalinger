FROM alpine:3.6

RUN apk add --update --no-cache \
	ca-certificates \
	curl

COPY flush-cache.sh /flush-cache.sh
COPY crontab /var/spool/cron/crontabs/root

CMD crond -f
