#!/usr/bin/with-contenv bashio

CONFIG="/etc/ddclient/ddclient.conf"

DDCLIENT_CONFIG=$(bashio::config 'config')

# Process each JSON object in the config
echo "$DDCLIENT_CONFIG" | while IFS= read -r line; do
    # Skip empty lines
    [ -z "$line" ] && continue
    
    # Parse the JSON and create config section
    zone=$(echo "$line" | jq -r '.zone')
    config=$(echo "$line" | jq -r '.config')
    hostnames=$(echo "$line" | jq -r '.hostnames')
    
    # Append configuration section for this entry
    cat >> "$CONFIG" << EOL
protocol=${protocol}
${config}
${hostnames}
EOL
done

# Start ddclient
ddclient -foreground -verbose -debug
