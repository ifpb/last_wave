#!/bin/bash

set +e  

CLIENT="client"
SERVER="server"

SWITCH_CLIENT="s1"
SWITCH_FILE="/tmp/last_switch.txt"
SWITCH_SERVER=$(tr -d '\n' < "$SWITCH_FILE")

# Delete ports of switchs
sudo ovs-vsctl --if-exists del-port $SWITCH_CLIENT veth-client-sw
sudo ovs-vsctl --if-exists del-port $SWITCH_SERVER veth-server-sw


sudo ip link delete client 2>/dev/null
sudo ip link delete server 2>/dev/null

# Delete links de namespace
sudo rm -f /var/run/netns/$CLIENT
sudo rm -f /var/run/netns/$SERVER

