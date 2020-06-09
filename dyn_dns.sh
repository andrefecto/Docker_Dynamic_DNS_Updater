#!/bin/bash

while true; do

    PRIV_ACCESS_TOKEN=$ACCESS_TOKEN
    PRIV_DOMAIN=$DOMAIN
    PRIV_SUBDOMAIN=$SUBDOMAIN
    PRIV_RECORD_ID=$RECORD_ID

    IP=$(curl -s https://checkip.amazonaws.com/)


    if [ -z "$PRIV_ACCESS_TOKEN" ]
    then
        echo "You must fill in the ACCESS_TOKEN. Please fill this in and restart the container">/dev/stderr;
        exit 1;
    else
        echo "access token exists, moving on.">/dev/stdout
    fi

    if [ -z "$PRIV_DOMAIN" ]
    then
        echo "You must fill in the DOMAIN. Please fill this in and restart the container">/dev/stderr;
        exit 1;
    else
        echo "domain exists, moving on.">/dev/stdout
    fi

    if [ -z "$PRIV_RECORD_ID" ]
    then
        if [ -z "$PRIV_SUBDOMAIN" ]
        then
            echo "SUBDOMAIN to update and RECORD_ID is empty. Please set them as env variables and restart the container.">/dev/stderr;
            exit 1;
        else
            PRIV_RECORD_ID=$(curl  \
                -X GET \
                -H "Content-Type: application/json" \
                -H "Authorization: Bearer $PRIV_ACCESS_TOKEN" \
                "https://api.digitalocean.com/v2/domains/$PRIV_DOMAIN/records" \
                | jq '.domain_records[] | select(.name | contains("'$PRIV_SUBDOMAIN'")) | .id');
            echo "domain id is $PRIV_RECORD_ID moving on">/dev/stdout;
        fi
    else
        echo "ID is $PRIV_RECORD_ID">/dev/stdout
        echo "ID is filled in, moving on">/dev/stdout
    fi

      HTTP_STATUS=$(curl \
        --write-out %{http_code} \
        --silent \
        --output /dev/null \
        -X PUT \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $PRIV_ACCESS_TOKEN" \
        -d "{\"data\":\"$IP\"}" \
        "https://api.digitalocean.com/v2/domains/$PRIV_DOMAIN/records/$PRIV_RECORD_ID");

        if [ $HTTP_STATUS == 200 ]
        then
            echo "HTTP returned status 200, meaning the update worked.">/dev/stdout;
            echo "Sleeping for 12 hours.">/dev/stdout;
        else
            echo "HTTP returned status other than 200, meaning something went wrong. Check your variables using something like PostMan and try again.">dev/stderr;
            echo "Now exiting....">dev/stderr;
            exit 1;
        fi

    sleep 12h

done