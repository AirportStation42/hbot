#!/bin/bash

function firewall_server_wol
{
    firewall_header

    echo -e "\n\e[44mDeploying WoL Server Firewall Rules\e[49m"

    echo -e "\nINPUT"
        echo -e " - ACCEPT ssh IN from devices, vpn"
            iptables -A INPUT -p tcp -s 10.0.40.0/24,10.0.90.0/24 --dport 22 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new incoming ssh from devices/vpn"

    echo -e "\nOUTPUT"

        # dns
        USERS=( _apt ntp uptime )
        for U in "${USERS[@]}"
        do
            echo " - ACCEPT dns out for $U "
                iptables -A OUTPUT -p udp --dport 53 -m owner --uid-owner $U -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing dns for $U"
        done

        # block private after dns
        echo -e " - DROP private OUT"
            iptables -A OUTPUT -d 10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,169.254.0.0/16 -j DROP -m comment --comment "DROP private"

        # https
        USERS=( _apt uptime )
        for U in "${USERS[@]}"
        do
            echo " - ACCEPT http out for $U "
                iptables -A OUTPUT -p tcp --dport 80 -m owner --uid-owner $U -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing https for $U"
            echo " - ACCEPT https out for $U "
                iptables -A OUTPUT -p tcp --dport 443 -m owner --uid-owner $U -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing https for $U"
        done

        # ntp
        echo -e " - ACCEPT ntp OUT for ntp"
            iptables -A OUTPUT -p udp --dport 123 -m owner --uid-owner ntpsec -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing NTP"

    firewall_persistentSave
}