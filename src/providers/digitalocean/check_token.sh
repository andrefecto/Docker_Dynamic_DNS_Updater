function check_token(){
    local HTTP_RETURN=$(curl \
            --silent \
            -w "\n%{http_code}" \
            -X GET \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer $GLOBAL_ACCESS_TOKEN" \
            --resolve "api.digitalocean.com:443:1.1.1.1" \
            "https://api.digitalocean.com/v2/domains");

    local HTTP_RESPONSE_CODE=$(echo "$HTTP_RETURN" | { read body; read code; echo "$code";});
    local HTTP_RESPONSE_BODY=$(echo "$HTTP_RETURN" | { read body; read code; echo "$body";});

    case $HTTP_RESPONSE_CODE in
        200)
            echo "NOTICE | check_token | Access token provided was successful accessing https://api.digitalocean.com/v2/domains">/dev/stdout;
            return 0;
        ;;
        *)
            echo "ERROR | check_token | Fatal: The access token provided didn't return HTTP 200 when accessing https://api.digitalocean.com/v2/domains .The return code was $HTTP_RESPONSE_CODE. The next message has the error.">/dev/stdout;
            echo "ERROR | check_token | Fatal: $HTTP_RESPONSE_BODY">/dev/stdout;
            exit 1;
        ;;
    esac;

}