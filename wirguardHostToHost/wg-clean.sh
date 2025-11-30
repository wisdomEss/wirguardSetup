#!/bin/bash
# Nettoyage complet WireGuard

IFACE="wg0"
CONF="/etc/wireguard/${IFACE}.conf"

echo "---------- [ WG CLEAN ] ----------"

echo "[*] Arrêt de l'interface ${IFACE} si active..."
wg-quick down $IFACE 2>/dev/null && echo "[OK] Interface arrêtée"

echo "[*] Suppression de l'interface virtuelle..."
ip link delete dev $IFACE 2>/dev/null && echo "[OK] Interface supprimée"

if [ -f "$CONF" ]; then
    echo "[*] Suppression fichier de configuration : $CONF"
    rm -f "$CONF"
    echo "[OK] Fichier supprimé"
else
    echo "[-] Aucun fichier wg0.conf trouvé."
fi

echo "[/] Nettoyage terminé."
echo "----------------------------------"
