#!/bin/bash

IFACE="wg0"
CONF="/etc/wireguard/${IFACE}.conf"

if [ $# -ne 3 ]; then
    echo "Usage : $0 <peer_pubkey> <peer_ip/mask> <endpoint:port>"
    exit 1
fi

PEER_KEY=$1
PEER_IP=$2
PEER_ENDPOINT=$3

echo "---------- [ WG PEER ADD ] ----------"

# Write to config file
cat >> $CONF <<EOF

[Peer]
PublicKey = $PEER_KEY
AllowedIPs = $PEER_IP
Endpoint = $PEER_ENDPOINT
PersistentKeepalive = 25
EOF

# Apply live config
wg set $IFACE peer $PEER_KEY \
   allowed-ips $PEER_IP \
   endpoint $PEER_ENDPOINT \
   persistent-keepalive 25

echo "[*] Ajout route : $PEER_IP via $IFACE"
ip route add $PEER_IP dev $IFACE 2>/dev/null

echo "[✓] Peer ajouté"
echo "----------------------------------"
wg
echo "----------------------------------"

