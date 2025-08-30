#!/usr/bin/with-contenv bashio

CONFIG="/etc/ddclient/ddclient.conf"
KEYFILE=/etc/ddclient/nsupdate.key

DDCLIENT_CONFIG=$(bashio::config 'config')

# Process each JSON object in the config
echo "$DDCLIENT_CONFIG" | while IFS= read -r line; do
    # Skip empty lines
    [ -z "$line" ] && continue
    
    # Parse the JSON and create config section
    zone=$(echo "$line" | jq -r '.zone')
    server=$(echo "$line" | jq -r '.server')
    hostnames=$(echo "$line" | jq -r '.hostnames')
    hmac_key=$(echo "$line" | jq -r '.hmac_key')

    echo $hmac_key >"${KEYFILE}"
    
    # Append configuration section for this entry
    cat >> "$CONFIG" << EOL
protocol=nsupdate
server=${server}
password=${KEYFILE}
zone=${zone}
${hostnames}
EOL
done

# Start ddclient
ddclient -foreground -verbose -debug
