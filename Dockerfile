FROM alpine:latest
RUN apk update && apk add bash jq curl
COPY dyn_dns.sh /opt/dyn_dns.sh
RUN adduser -D dyndns_user
RUN chown dyndns_user:dyndns_user /opt/dyn_dns.sh
RUN chmod 550 /opt/dyn_dns.sh
USER dyndns_user
ENTRYPOINT ["/opt/dyn_dns.sh"]