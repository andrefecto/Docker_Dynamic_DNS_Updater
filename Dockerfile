FROM alpine:latest
RUN apk update && apk add bash jq curl
COPY dyn_dns.sh /opt/dyn_dns.sh
RUN chmod +x /opt/dyn_dns.sh
ENTRYPOINT ["/opt/dyn_dns.sh"]