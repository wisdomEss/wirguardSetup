#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage : $0 <local_ip/mask>"
    exit 1
fi

LOCAL_IP=$1
IFACE="wg0"
DIR="/etc/wireguard"
CONF="${DIR}/${IFACE}.conf"

mkdir -p $DIR
cd $DIR

echo "---------- [ WG SETUP ] ----------"

wg genkey | tee privatekey | wg pubkey > publickey

PRIV=$(cat privatekey)
PUB=$(cat publickey)

echo "[*] Création configuration : $CONF"

cat > $CONF <<EOF
[Interface]
PrivateKey = $PRIV
Address = $LOCAL_IP
EOF

chmod 600 $CONF

echo "[*] Activation interface..."
wg-quick up $IFACE

# Extraction réseau pour la route automatique
NET=$(echo "$LOCAL_IP" | cut -d'/' -f1)
MASK=$(echo "$LOCAL_IP" | cut -d'/' -f2)

# Route auto pour permettre communication
echo "[*] Ajout route : $LOCAL_IP via $IFACE"
ip route add $LOCAL_IP dev $IFACE 2>/dev/null

echo "----------------------------------"
echo "[✓] CONFIGURATION TERMINÉE"
echo "WG Interface : $IFACE"
echo "WG IP        : $LOCAL_IP"
echo "PrivateKey   : $PRIV"
echo "PublicKey    : $PUB"
wg
echo "----------------------------------"

