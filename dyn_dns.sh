#!/bin/sh

ACCESS_TOKEN=$ACCESS_TOKEN
DOMAIN=$DOMAIN
SUBDOMAIN=$SUBDOMAIN
RECORD_ID=$RECORD_IDS

IP=$(curl -s https://checkip.amazonaws.com/)

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


if [ -z "$RECORDS_ID" ]
then
    if [ -z "$SUBDOMAIN" ]
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

for ID in "${RECORD_ID[@]}"
do
  curl \
    -fs -o /dev/null \
    -X PUT \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $ACCESS_TOKEN" \
    -d "{\"data\":\"$IP\"}" \
    "https://api.digitalocean.com/v2/domains/$DOMAIN/records/$ID"
done