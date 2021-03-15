function update_domain(){

    local HTTP_STATUS=$(curl \
    --silent \
    --write-out "\n%{http_code}" \
    -X PUT \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $GLOBAL_ACCESS_TOKEN" \
    -d "{\"data\":\"$GLOBAL_IP\"}" \
    --resolve "api.digitalocean.com:443:1.1.1.1" \
    "https://api.digitalocean.com/v2/domains/$GLOBAL_TLD/records/$GLOBAL_DOMAIN_RECORD_ID");

    local HTTP_RESPONSE_CODE=$(echo "$HTTP_STATUS" | { read body; read code; echo "$code";});
    local HTTP_RESPONSE_BODY=$(echo "$HTTP_STATUS" | { read body; read code; echo "$body";});

    if [[ $HTTP_RESPONSE_CODE == 200 ]]; then
        echo "INFO | update_domain | HTTP returned status 200, meaning the update worked.">/dev/stdout;
        echo "INFO | update_domain | Response was: $HTTP_RESPONSE_BODY">/dev/stdout;
    else
        echo "ERROR | update_domain | HTTP returned status other than 200, meaning something went wrong.">/dev/stdout;
        echo "ERROR | update_domain | Return code was $HTTP_RESPONSE_CODE">/dev/stdout;
        echo "ERROR | update_domain | Response was: $HTTP_RESPONSE_BODY">/dev/stdout;
        echo "ERROR | update_domain | The curl command was: 'curl --write-out \"\n%{http_code}\" --silent -X PUT -H \"Content-Type: application/json\" -H \"Authorization: Bearer $GLOBAL_ACCESS_TOKEN\" --resolve \"api.digitalocean.com:443:1.1.1.1\" -d \"{\"data\":\"$GLOBAL_IP\"}\" \"https://api.digitalocean.com/v2/domains/$GLOBAL_TLD/records/$GLOBAL_DOMAIN_RECORD_ID\"">/dev/stdout;
        echo "ERROR | update_domain | Now exiting...">/dev/stdout;
        exit 1;
    fi

}