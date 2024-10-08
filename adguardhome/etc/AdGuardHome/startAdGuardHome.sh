#!/bin/sh

ROUTER_IP=$(uci show network | grep network.lan.ipaddr|cut -d "'" -f 2)
IP_INCONFIG=$ROUTER_IP

if [ -f "/etc/AdGuardHome/AdGuardHome.yaml" ];
then
IP_IN_CONFIG=$(cat /etc/AdGuardHome/AdGuardHome.yaml | grep "address:" | awk '{print $2}' | awk -F':' '{print $1}')
fi

if [ ! -f "/etc/AdGuardHome/AdGuardHome.yaml" ];
then
        /etc/AdGuardHome/initConfig.sh
fi

if [ "$IP_IN_CONFIG" != "$ROUTER_IP" ];
then
echo "Router lan ip changed. Automatic change ip address in /etc/AdGuardHome/AdGuardHome.yaml."
echo "Change bind_host form "$IP_IN_CONFIG" to "$ROUTER_IP"."
sed -i "s/address: $IP_IN_CONFIG/address: $ROUTER_IP/" /etc/AdGuardHome/AdGuardHome.yaml
echo "Bind address in /etc/AdGuardHome/AdGuardHome.yaml has been changed to "$ROUTER_IP"."
fi

/usr/bin/AdGuardHome/AdGuardHome -c /etc/AdGuardHome/AdGuardHome.yaml
