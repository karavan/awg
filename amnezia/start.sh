#!/usr/bin/env bash

# This scripts copied from Amnezia client to Docker container to /opt/amnezia and launched every time container starts

echo "Container startup"
export IFACE=${IFACE:-awg0}
echo "Used interface: ${IFACE}"

# kill daemons in case of restart
#ip link show ${IFACE} &>/dev/null && wg-quick down /opt/amnezia/awg/${IFACE}.conf
sudo ip link delete ${IFACE} &>/dev/null

# Initialization. Create confs if is absent.
/opt/amnezia/init.sh

# start daemons if configured
if [ -f /opt/amnezia/awg/${IFACE}.conf ]; then (wg-quick up /opt/amnezia/awg/${IFACE}.conf); fi

tail -f /dev/null
