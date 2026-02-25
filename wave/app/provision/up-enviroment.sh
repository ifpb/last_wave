#!/bin/bash

set -e

CLIENT="client"
SERVER="server"

CLIENT_IP="$1/24"
SERVER_IP="$2/24"

SWITCH_CLIENT="s1"

SWITCH_FILE="/tmp/ultimo_switch.txt"
SWITCH_SERVER=$(tr -d '\n' < "$SWITCH_FILE")

echo "[1] Pegando PIDs..."
CLIENT_PID=$(docker inspect -f '{{.State.Pid}}' $CLIENT)
SERVER_PID=$(docker inspect -f '{{.State.Pid}}' $SERVER)

sudo mkdir -p /var/run/netns
sudo ln -sf /proc/$CLIENT_PID/ns/net /var/run/netns/$CLIENT
sudo ln -sf /proc/$SERVER_PID/ns/net /var/run/netns/$SERVER

echo "[2] Criando veth pairs..."
sudo ip link delete veth-client-sw 2>/dev/null || true
sudo ip link delete veth-server-sw 2>/dev/null || true

sudo ip link add veth-client type veth peer name veth-client-sw
sudo ip link add veth-server type veth peer name veth-server-sw

echo "[3] Movendo uma ponta para os containers..."
sudo ip link set veth-client netns $CLIENT
sudo ip link set veth-server netns $SERVER

echo "[4] Conectando ao Mininet switches..."
sudo ovs-vsctl add-port $SWITCH_CLIENT veth-client-sw
sudo ovs-vsctl add-port $SWITCH_SERVER veth-server-sw

echo "[5] Subindo interfaces externas..."
sudo ip link set veth-client-sw up
sudo ip link set veth-server-sw up

echo "[6] Configurando IPs dentro dos containers..."

sudo ip netns exec $CLIENT ip link set lo up
sudo ip netns exec $CLIENT ip addr add $CLIENT_IP dev veth-client
sudo ip netns exec $CLIENT ip link set veth-client up

sudo ip netns exec $SERVER ip link set lo up
sudo ip netns exec $SERVER ip addr add $SERVER_IP dev veth-server
sudo ip netns exec $SERVER ip link set veth-server up
