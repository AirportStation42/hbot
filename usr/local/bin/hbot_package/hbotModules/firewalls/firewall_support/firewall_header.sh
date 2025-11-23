#!/bin/bash

function firewall_header
{
    firewall_v6_support_basic   # call v6 rules

    echo -e "\n\e[44mDeploying standard Firewall Header Rules\e[49m"

    # Setup
    echo -e "\nSetting default policy to DROP"
        iptables -P OUTPUT DROP
        iptables -P INPUT DROP
        iptables -P FORWARD DROP

    echo -e "\nFlushing all chains"
        iptables -F

    echo -e "\nDeleting added chains"
        iptables -X

    # INPUT
    echo -e "\nDROP bad packets IN"
        echo " - lo spoof   (DROP - IN)"
            iptables -A INPUT -s 127.0.0.0/8 ! -i lo -j DROP -m comment --comment "DROP 127.0.0.0/8 not from loopback"
        echo " - XMAS       (DROP - IN)"
            iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP -m comment --comment "DROP outgoing XMAS"
        echo " - NULL       (DROP - IN)"
            iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP -m comment --comment "DROP outgoing NULL"
        echo " - INVALID    (DROP - IN)"
            iptables -A INPUT -m conntrack --ctstate INVALID -j DROP -m comment --comment "DROP anything marked INVALID"
        echo " - NEW != SYN (DROP - IN)"
            iptables -A INPUT -p tcp ! --syn -m conntrack --ctstate NEW -j DROP -m comment --comment "DROP any NEW tcp connections that do NOT start with SYN"
        echo " - SYN Flood  (DROP - IN)"
            iptables -A INPUT -p tcp --syn -m hashlimit --hashlimit-name synFlood --hashlimit-above 30/s -j DROP -m comment --comment "LIMIT SYN to 30/sec"
        echo " - UPnP       (DROP - IN)" 
            iptables -A INPUT -p udp --dport 1900 -j DROP -m comment --comment "DROP UPnP"
        echo " - Steam"
            echo "   - Remote Play UPD (DROP - IN)" 
                iptables -A INPUT -p udp --dport 27031:27036 -j DROP -m comment --comment "DROP new incoming Steam remote play udp"
            echo "   - Remote Play TCP (DROP - IN)" 
                iptables -A INPUT -p tcp --dport 27036 -j DROP -m comment --comment "DROP new incoming Steam remote play tcp"
            echo "   - SRCDS Rcon      (DROP - IN)"
                iptables -A INPUT -p tcp --dport 27015 -j DROP -m comment --comment "DROP new incoming Steam - source dedicated server remote console"

    # OUTPUT
    echo -e "\nDROP services OUT"
        echo " - Steam" # needs to be before related/established, steam will intitiate on both sides and remote play will match on related/established. Needs to be BEFORE. Even with dropping these before, steam can lauch the game on remote, but will not be able to get a virtual desktop connection 
            echo "   - Remote Play UPD (DROP - OUT)" 
                iptables -A OUTPUT -p udp --dport 27031:27036 -m conntrack --ctstate NEW -j DROP -m comment --comment "DROP new outgoing Steam remote play udp"
            echo "   - Remote Play TCP (DROP - OUT)" 
                iptables -A OUTPUT -p tcp --dport 27036 -m conntrack --ctstate NEW -j DROP -m comment --comment "DROP new outgoing Steam remote play tcp"
            echo "   - SRCDS Rcon      (DROP - OUT)"
                iptables -A OUTPUT -p tcp --dport 27015 -m conntrack --ctstate NEW -j DROP -m comment --comment "DROP new outgoing Steam - source dedicated server remote console"

    echo -e "\nACCEPT everything marked RELATED/ESTABLISHED"
        iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT -m comment --comment "ACCEPT incoming RELATED/ESTABLISHED"
        iptables -A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT -m comment --comment "ACCEPT outgoing RELATED/ESTABLISHED"

    echo "ACCEPT everything on loopback"
        iptables -A INPUT -i lo -s 127.0.0.0/8 -d 127.0.0.0/8 -j ACCEPT -m comment --comment "ACCEPT all incoming on loopback"
        iptables -A OUTPUT -o lo -s 127.0.0.0/8 -d 127.0.0.0/8 -j ACCEPT -m comment --comment "ACCEPT all outgoing on loopback"
}