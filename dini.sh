#!/bin/bash

# Cloudflare Tunnel Setup Script for Raspberry Pi (Kali Linux)
# Make sure you have a Cloudflare account and a custom domain added to Cloudflare.

# Define Variables
TUNNEL_NAME="diniiosxyz"
DOMAIN="diniios.xyz"

# Create a new tunnel
cloudflared tunnel create $TUNNEL_NAME

# Get Tunnel ID
TUNNEL_ID=$(cat ~/.cloudflared/$TUNNEL_NAME.json | jq -r '.TunnelID')

# Create a configuration file for the tunnel
mkdir -p ~/.cloudflared
cp -R /home/dini/.cloudflared/$TUNNEL_NAME.json : /root/.cloudflared/$TUNNEL_NAME.json
cat <<EOF > ~/.cloudflared/config.yml
tunnel: $TUNNEL_ID
credentials-file: /root/.cloudflared/$TUNNEL_NAME.json

ingress:
  - hostname: $DOMAIN
    service: http://localhost:80
  - service: http_status:404
EOF

# Route traffic to the domain
cloudflared tunnel route dns $TUNNEL_NAME $DOMAIN

# Start the tunnel
cloudflared tunnel run $TUNNEL_NAME &

# Display success message
echo "\n✅ Cloudflare Tunnel is set up successfully!"
echo "🌍 Visit: https://$DOMAIN"
