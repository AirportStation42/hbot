#!/bin/bash

function firewall_support_allow_local_only
{
    firewall_header

    echo -e "\n\e[44mDeploying Local Firewall Rules\e[49m"

    echo " - Allow Private IP's (All Ports TCP and UDP)"
        echo " - Class C"
            iptables -A OUTPUT -d 192.168.0.0/16 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new to Private Class C"
        echo " - Class B"
            iptables -A OUTPUT -d 172.16.0.0/12 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new to Private Class B"
        echo " - Class A"
            iptables -A OUTPUT -d 10.0.0.0/8 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new to Private Class A"
        echo " - Localhost"
            iptables -A OUTPUT -d 127.0.0.1 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new to Loopback"            

    echo -e "\n\e[91mFirewall Ruleset Updated - NOT Persistant - Will be Cleared on Restart\e[39m"
}