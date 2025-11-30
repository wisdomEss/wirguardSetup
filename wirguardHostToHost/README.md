# WireGuard Host-to-Host — Scripts d’automatisation

Ce dépôt fournit trois scripts Bash pour configurer rapidement une connexion WireGuard host-to-host sur Linux :
- wg-clean.sh : supprime une configuration WireGuard existante.
- wg-setup.sh : génère une clé, crée la configuration locale et active l'interface.
- wg-peer.sh : ajoute un peer distant et applique la configuration en live.

Table des matières
- Prérequis
- Installation
- Description des scripts
  - wg-clean.sh
  - wg-setup.sh
  - wg-peer.sh
- Exemples
- Tests & dépannage
- Remarques de sécurité

Prérequis
- Linux avec WireGuard installé (wg, wg-quick).
- Droits root pour écrire /etc/wireguard et manipuler les interfaces réseau.
- Port UDP ouvert si les pairs sont derrière des pare-feux/NAT.

Installation
1. Copier les scripts dans un répertoire sur la machine.
2. Rendre exécutables :
   sudo chmod +x wg-clean.sh wg-setup.sh wg-peer.sh

Emplacement de configuration
- Fichier principal : /etc/wireguard/wg0.conf
- Interface utilisée : wg0

Description des scripts

wg-clean.sh — Nettoyage complet
- Objectif : supprimer une ancienne configuration WireGuard pour repartir proprement.
- Actions :
  - Arrêt de l’interface (wg-quick down wg0)
  - Suppression de l’interface si nécessaire
  - Suppression du fichier /etc/wireguard/wg0.conf
- Usage :
  sudo ./wg-clean.sh

wg-setup.sh — Création et activation d’une configuration locale
- Objectif : générer les clés, créer la configuration locale et activer wg0.
- Actions :
  - Génération d’une paire de clés (privée/publique)
  - Création de /etc/wireguard/wg0.conf avec la clé privée et l’adresse locale
  - Activation via wg-quick up wg0
  - Ajout de la route locale si nécessaire
- Usage :
  sudo ./wg-setup.sh <local_ip/mask>
- Exemple :
  sudo ./wg-setup.sh 10.10.10.1/24

wg-peer.sh — Ajout d’un peer distant
- Objectif : ajouter un peer dans la configuration et appliquer immédiatement les changements.
- Actions :
  - Ajout d’une section [Peer] dans /etc/wireguard/wg0.conf
  - Application via wg set pour ajouter le peer sans redémarrer l’interface
  - Ajout d’une route pour la plage du peer si nécessaire
- Usage :
  sudo ./wg-peer.sh <peer_pubkey> <peer_ip/mask> <endpoint:port>
- Exemple :
  sudo ./wg-peer.sh "qwertyuiop1234567890=" "10.10.10.2/32" "203.0.113.15:51820"

Exemples complets (Host A ↔ Host B)
Host A:
  sudo ./wg-clean.sh
  sudo ./wg-setup.sh 10.10.10.1/32
  sudo ./wg-peer.sh <pubkey_B> 10.10.10.2/32 <ip_publique_B:51820>

Host B:
  sudo ./wg-clean.sh
  sudo ./wg-setup.sh 10.10.10.2/32
  sudo ./wg-peer.sh <pubkey_A> 10.10.10.1/32 <ip_publique_A:51820>

Tester la connectivité
- Depuis A : ping 10.10.10.2
- Depuis B : ping 10.10.10.1
- Vérifier l’état : sudo wg show

Dépannage rapide
- Pas de route : vérifier ip route et la configuration du fichier wg0.conf.
- Peer non joignable : vérifier endpoint/port, pare-feu et NAT.
- Permissions : exécuter les scripts en root.

Remarques de sécurité
- Protéger la clé privée (chmod 600 /etc/wireguard/wg0.conf ou fichier de clé séparé).
- Ne pas exposer la clé privée.
- Utiliser des adresses et ports appropriés et restreindre l’accès au besoin.


