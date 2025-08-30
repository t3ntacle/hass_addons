#!/usr/bin/with-contenv bashio

CONFIG="/etc/ddclient/ddclient.conf"
KEYPATH=/etc/ddclient/

DDCLIENT_CONFIG=$(bashio::config 'config')

# Process each JSON object in the config
echo "$DDCLIENT_CONFIG" | while IFS= read -r line; do
    # Skip empty lines
    [ -z "$line" ] && continue
    
    # Parse the JSON and create config section
    zone=$(echo "$line" | jq -r '.zone')
    server=$(echo "$line" | jq -r '.server')
    hostnames=$(echo "$line" | jq -r '.hostnames')
    hmac_key="$(echo "$line" | jq -r '.hmac_key')"
    hmac_private="$(echo "$line" | jq -r '.hmac_provate')"
    key_name=$(echo "$line" | jq -r '.key_name')

    echo "$hmac_private" >"$KEYPATH/${key_name}.private"
    echo "$hmac_key" >"$KEYPATH/${key_name}.key"
    
    # Append configuration section for this entry
    cat >> "$CONFIG" << EOL
protocol=nsupdate
server=${server}
password=$KEYPATH/${key_name}
zone=${zone}
${hostnames}
EOL
done

# Start ddclient
ddclient -foreground -verbose -debug
