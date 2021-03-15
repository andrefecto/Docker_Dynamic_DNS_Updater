function set_subdomain_id(){

    local FETCHED_DATA=$(curl \
        --silent \
        -X GET \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $GLOBAL_ACCESS_TOKEN" \
        --resolve "api.digitalocean.com:443:1.1.1.1" \
        "https://api.digitalocean.com/v2/domains/$GLOBAL_TLD/records?name=$GLOBAL_DOMAIN");

    local FETCHED_TOTAL=$(jq -r '.meta.total' <<< ${FETCHED_DATA});

    local FETCHED_ID=$(jq '.domain_records[].id' <<< ${FETCHED_DATA});

    if [[ $FETCHED_TOTAL == 0 ]]; then
        echo "ERROR | set_subdomain_id | Fatal: the domain provided, $GLOBAL_DOMAIN doesn't exist in DigitalOcean records. Check your domain and access token and try again. The command that was run is in the next message if you want to try.">/dev/stdout;
        echo "ERROR | set_subdomain_id | curl -s -X GET -H \"Content-Type: application/json\" -H \"Authorization: Bearer $GLOBAL_ACCESS_TOKEN\" \"https://api.digitalocean.com/v2/domains/$GLOBAL_TLD/records?name=$GLOBAL_DOMAIN\"">/dev/stdout;
        echo "ERROR | set_subdomain_id | Container exiting">/dev/stdout;
        exit 1;
    fi;

    if [[ -z "$FETCHED_ID" ]]; then
        echo "ERROR | set_subdomain_id | Fatal: the ID was not able to be extracted from the cURL return. Some debug information will follow.">/dev/stdout;
        echo "ERROR | set_subdomain_id | CURL COMMAND: curl -s -X GET -H \"Content-Type: application/json\" -H \"Authorization: Bearer $GLOBAL_ACCESS_TOKEN\" \"https://api.digitalocean.com/v2/domains/$GLOBAL_TLD/records?name=$GLOBAL_DOMAIN\"">/dev/stdout;
        echo "ERROR | set_subdomain_id | FETCHED DATA: $FETCHED_DATA">/dev/stdout;
        echo "ERROR | set_subdomain_id | Please open a Github issue with this data (scrub your private information) because it means something is wrong with this function.">/dev/stdout;
        echo "ERROR | set_subdomain_id | Container exiting">/dev/stdout;
        exit 1;
    elif [[ ! -z "$FETCHED_ID" ]]; then
        echo "INFO | set_subdomain_id | Domain ID was found. Saving local $FETCHED_ID into global GLOBAL_DOMAIN_RECORD_ID for future use.">/dev/stdout;
        GLOBAL_DOMAIN_RECORD_ID=$FETCHED_ID
        return 0;
    fi;
}