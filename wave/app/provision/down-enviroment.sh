#!/bin/bash

set +e  # não parar se der erro

CLIENT="client"
SERVER="server"

SWITCH_CLIENT="s1"
SWITCH_FILE="/tmp/ultimo_switch.txt"
SWITCH_SERVER=$(tr -d '\n' < "$SWITCH_FILE")

echo "[1] Removendo portas dos switches OVS..."
sudo ovs-vsctl --if-exists del-port $SWITCH_CLIENT veth-client-sw
sudo ovs-vsctl --if-exists del-port $SWITCH_SERVER veth-server-sw

echo "[2] Deletando veth interfaces..."
sudo ip link delete veth-client-sw 2>/dev/null
sudo ip link delete veth-server-sw 2>/dev/null

echo "[3] Removendo links de namespace..."
sudo rm -f /var/run/netns/$CLIENT
sudo rm -f /var/run/netns/$SERVER

echo "Ambiente de rede limpo."
