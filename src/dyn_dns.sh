#!/bin/bash

####################
# Global variables #
####################
# GLOBAL_DOMAIN_RECORD_ID
#   Set in: check_subdomain_id
#   Type: Integer
#   Why: So that we reference the same domain everytime
#
# GLOBAL_DOMAIN_PROVIDER
#   Set in: Runtime (ENV Var) from DOMAIN_PROVIDER in Docker
#   Type: String
#   Why: We need to know if it's DigitalOcean, AWS, CloudFlare, etc.
#
# GLOBAL_DOMAIN
#   Set in: Runtime (ENV Var) from DOMAIN in Docker
#   Type: String
#   Why: Domain we want to update
#   Notes: is the whole domain, like test.andrefecto.me
#
# GLOBAL_TLD
#   Set in: dyn_dns.sh
#   Type: String
#   Why: splits the subdomain from the tld
#
# GLOBAL_ACCESS_TOKEN
#   Set in: Runtime (ENV Var) from ACCESS_TOKEN in Docker
#   Type: String
#   Why: Needed so we can access the API for updating the IP of this server/domain combo
#
# GLOBAL_IP
#   Set in: dyn_dns.sh
#   Type: Integer, cast to string
#   Why: This is the IP of the server the container is running on
#
# GLOBAL_SLEEP
#   Set in: Runtime (ENV Var) from SLEEP_DURATION in Docker
#   Type: String
#   Why: So we can control how long the script will sleep for
#
# GLOBAL_SCRIPT_ROOT
#   Set in: dyn_dns.sh
#   Type: String
#   Why: So we can call scripts properly
#   Notes: All calls to scripts need to be fully qualified using this variable

# Change into this directory so that our PWD is where all our scripts are stored
    cd /opt/dyn_dns;

# Do this until we exit

GLOBAL_DOMAIN_PROVIDER="$(echo "$DOMAIN_PROVIDER" | tr '[:upper:]' '[:lower:]')";
GLOBAL_ACCESS_TOKEN="$ACCESS_TOKEN";
GLOBAL_DOMAIN="$DOMAIN";
GLOBAL_SLEEP="$SLEEP_DURATION";
GLOBAL_SCRIPT_ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd );
GLOBAL_TLD=$(echo "$GLOBAL_DOMAIN" | cut -d '.' -f 2,3);

GLOBAL_IP="$(curl -s https://checkip.amazonaws.com/)";


echo "INFO | dyn_dns | GLobal_TLD is $GLOBAL_TLD">/dev/stdout;
echo "INFO | dyn_dns | Global IP is $GLOBAL_IP">/dev/stdout;

if [[ -z "$GLOBAL_ACCESS_TOKEN" ]]; then
    echo "ERROR | dyn_dns | You must provide the ACCESS_TOKEN variable in the Docker command. Please fill this in and restart the container">/dev/stdout;
    exit 1;
else
    echo "INFO | dyn_dns | Access token, $GLOBAL_ACCESS_TOKEN provided, moving on.">/dev/stdout;
fi;

if [[ -z "$GLOBAL_DOMAIN" ]]; then
    echo "ERROR | dyn_dns | You must provide the DOMAIN variable in the Docker command. Please fill this in and restart the container">/dev/stdout;
    exit 1;
else
    echo "INFO | dyn_dns | Domain, $GLOBAL_DOMAIN provided, moving on.">/dev/stdout;
fi

if [[ -z "$GLOBAL_SLEEP" ]]; then
    echo "WARN | dyn_dns | Sleep variable, $GLOBAL_SLEEP wasn't set. Setting to default of 12 hours.">/dev/stdout;
    GLOBAL_SLEEP="12h";
else
    echo "INFO | dyn_dns | Sleep variable, $GLOBAL_SLEEP was provded, moving on.">/dev/stdout;
fi;

case $GLOBAL_DOMAIN_PROVIDER in
    "digitalocean")
        echo "INFO | dyn_dns | Domain provider is $GLOBAL_DOMAIN_PROVIDER. Running DigitalOcean scripts.">/dev/stdout;
        echo "INFO | dyn_dns | PWD is $GLOBAL_SCRIPT_ROOT">/dev/stdout;
        source $GLOBAL_SCRIPT_ROOT/providers/digitalocean/digitalocean.sh;
    ;;
    *)
        echo "ERROR | dyn_dns | The domain provider $GLOBAL_DOMAIN_PROVIDER is not valid. Valid options are, digitalocean">/dev/stdout;
        exit 1;
    ;;
esac;