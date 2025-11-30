## WireGuard Host-to-Host – Scripts d’automatisation

Ce dépôt contient trois scripts Bash permettant de configurer rapidement une connexion WireGuard host-to-host sur Linux.
Ils permettent de nettoyer une ancienne configuration, créer une nouvelle interface et ajouter un peer distant.

Contenu du projet:

wg-clean.sh   # Nettoyage complet d’une ancienne configuration WireGuard

wg-setup.sh   # Création et activation d’une configuration locale

wg-peer.sh    # Ajout d’un peer distant


Pour rendre les scripts exécutables :

chmod +x wg-clean.sh wg-setup.sh wg-peer.sh

### 1. wg-clean.sh — Nettoyage complet

Ce script supprime toute configuration précédente :

Arrêt de l’interface wg0

Suppression de l’interface virtuelle

Suppression du fichier /etc/wireguard/wg0.conf

## Utilisation:

sudo ./wg-clean.sh

Utilité

Repartir sur une configuration propre

### Réinitialiser WireGuard


Régénérer de nouvelles clés sans conflit


# 2. wg-setup.sh — Création de la configuration locale

## Ce script :


Génère la clé privée et la clé publique


Crée /etc/wireguard/wg0.conf


Active l’interface wg0 via wg-quick up


Ajoute automatiquement la route locale associée


### Utilisation

sudo ./wg-setup.sh <local_ip/mask>


### Exemple

sudo ./wg-setup.sh 10.10.10.1/24


## Résultat


Interface wg0 active


Clé privée et clé publique créées


Configuration initiale prête pour ajouter des peers


## 3. wg-peer.sh — Ajout d’un peer distant
   

Ce script ajoute un peer dans la configuration WireGuard :


Ajout d’une section [Peer] au fichier /etc/wireguard/wg0.conf


Application immédiate via wg set


Ajout de la route correspondante


## Utilisation

sudo ./wg-peer.sh <peer_pubkey> <peer_ip/mask> <endpoint:port>


## Exemple

sudo ./wg-peer.sh \
"qwertyuiop1234567890=" \
"10.10.10.2/32" \
"203.0.113.15:51820"


## Paramètres

## Paramètre	Description

<peer_pubkey>	Clé publique du peer distant

<peer_ip/mask>	Adresse WireGuard du peer (ex: 10.10.10.2/32)

<endpoint:port>	Adresse publique + port WireGuard du peer

Exemple complet : Host A ↔ Host B

## Host A

sudo ./wg-clean.sh

sudo ./wg-setup.sh 10.10.10.1/32

sudo ./wg-peer.sh <pubkey_B> 10.10.10.2/32 <ip_publique_B:51820>


## Host B

sudo ./wg-clean.sh

sudo ./wg-setup.sh 10.10.10.2/32

sudo ./wg-peer.sh <pubkey_A> 10.10.10.1/32 <ip_publique_A:51820>


## Test de connectivité

ping 10.10.10.2   # depuis A

ping 10.10.10.1   # depuis B
