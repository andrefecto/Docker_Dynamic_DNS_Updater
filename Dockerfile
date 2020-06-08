FROM ubuntu:20.04
RUN apt-get update && apt-get install -y cron jq curl
# Remove VIM before final push
RUN apt-get install -y vim
COPY dyn_dns.sh /opt/dyn_dns.sh
COPY test.sh /opt/test.sh
RUN chmod +x /opt/dyn_dns.sh
RUN chmod +x /opt/test.sh
ENTRYPOINT ["tail", "-f", "/dev/null"]