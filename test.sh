#!/bin/bash
# echo "Records ID is $RECORD_IDS";
# echo "Domain is: $DOMAIN";
# echo "ACCESS_TOKEN is $ACCESS_TOKEN";
if [ -z "$ACCESS_TOKEN" ]
then
    echo "You must fill in the ACCESS_TOKEN. Please fill this in and restart the container">/dev/stderr;
    exit 1;
else
    echo "access token exists, moving on."
fi

if [ -z "$DOMAIN" ]
then
    echo "You must fill in the DOMAIN. Please fill this in and restart the container">/dev/stderr;
    exit 1;
else
    echo "domain exists, moving on."
fi


if [ -z "$RECORDS_IDS" ]
then
    if [ -z "$RECORD_NAME" ]
    then
        echo "Record_NAME to update and RECORD_IDS is empty. Please set them as env variables and restart the container.">/dev/stderr
    else
         RECORD_IDS=$(curl  \
            -X GET \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer $ACCESS_TOKEN" \
            "https://api.digitalocean.com/v2/domains/$DOMAIN/records" \
            | jq '.domain_records[] | select(.name | contains("'$SUBDOMAIN'")) | .id');
         echo "domain id is $domain_id"
    fi
else
      echo "ID is filled in, moving on";
fi