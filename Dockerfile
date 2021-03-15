FROM alpine:latest
RUN apk update && apk add bash jq curl
ADD src /opt/dyn_dns
RUN adduser -D dyndns_user
RUN chown -R dyndns_user:dyndns_user /opt/dyn_dns && chmod 550 -R /opt/dyn_dns
USER dyndns_user
ENTRYPOINT ["/opt/dyn_dns/dyn_dns.sh"]