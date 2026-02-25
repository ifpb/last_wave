#!/bin/bash

echo "192.168.0.11 server" | sudo tee -a /etc/hosts

STATUS_FILE="/home/vlc/logs/ready.txt"

sleep 2


echo "container ready" > "$STATUS_FILE"

tail -f /dev/null

