#!/bin/bash

while true; do
    source $GLOBAL_SCRIPT_ROOT/providers/digitalocean/set_subdomain_id.sh;
    source $GLOBAL_SCRIPT_ROOT/providers/digitalocean/check_token.sh;
    source $GLOBAL_SCRIPT_ROOT/providers/digitalocean/update_domain.sh;

    # Check that the token works
    check_token;

    # # Since the token worked, we also should check & set the subdomain ID
    set_subdomain_id;

    # # Since the check & set sub-domain ID worked we are going to run our update
    update_domain;

    # Now sleep
    echo "INFO | digitalocean | Sleeping for $GLOBAL_SLEEP starting at $(date +%F:%T)">/dev/stdout;
    sleep $GLOBAL_SLEEP;
    echo "INFO | digitalocean | Wake time from $GLOBAL_SLEEP sleep is $(date +%F:%T)">/dev/stdout;

done;