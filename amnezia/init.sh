#!/usr/bin/env bash

random_range() {
  MIN=$1
  MAX=$2
  MIN=${MIN:-4}
  MAX=${MAX:-12}
  RESULT=$((MIN + RANDOM % (MAX - MIN + 1)))
  echo ${RESULT}
}

# Creating a configuration if none exists
# Refer to permissible values of parameters in
# https://github.com/amnezia-vpn/amneziawg-linux-kernel-module?tab=readme-ov-file#configuration

if [ ! -f /opt/amnezia/awg/${IFACE}.conf ]; then
  PORT=${PORT:-51820}
  VPN_NETWORK=${VPN_NETWORK:-"10.32.0.0/24"}
  export $(ipcalc --prefix --minaddr ${NETWORK})
  IP_SRV=${MINADDR}/${PREFIX}
  PRIV_KEY=${PRIV_KEY:-$(wg genkey)}
  Jc=$(random_range)
  Jmin=$(random_range 12 64)
  Jmax=$(random_range ${Jmin} 256)
  S1=$(random_range 15 48)
  S2=$(random_range $(( S1 + 57 )) 150)
  H1=$(random_range 1024 1048576)
  H2=$(random_range 1024 1048576)
  H3=$(random_range 1024 1048576)
  H4=$(random_range 1024 1048576)

  echo "[Interface]
    PrivateKey = ${PRIV_KEY}
    Address = ${IP_SRV}
    ListenPort = ${PORT}
    Jc = ${Jc}
    Jmin = ${Jmin}
    Jmax = ${Jmax}
    S1 = ${S1}
    S2 = ${S2}
    H1 = ${H1}
    H2 = ${H2}
    H3 = ${H3}
    H4 = ${H4}
  " | sed -e 's/^\s\+//g' > /opt/amnezia/awg/${IFACE}.conf

  echo "[Interface]
    PrivateKey = <PRIV_KEY>
    Endpoint = ${ADDR_SRV}:${PORT}
    AllowedIPs = ${VPN_ROUTES:-"0.0.0.0/0"}
    PersistentKeepalive = 30
    Address = <IP>
    Jc = ${Jc}
    Jmin = ${Jmin}
    Jmax = ${Jmax}
    S1 = ${S1}
    S2 = ${S2}
    H1 = ${H1}
    H2 = ${H2}
    H3 = ${H3}
    H4 = ${H4}
  " | sed -e 's/^\s\+//g' > /opt/amnezia/awg/clients.tmpl
fi
