#!/bin/bash

function firewall_server_wol
{
    firewall_header

    echo -e "\n\e[44mDeploying WoL Server Firewall Rules\e[49m"

    echo -e "\nINPUT"
        echo -e " - ACCEPT ssh IN from devices, vpn"
            iptables -A INPUT -p tcp -s 10.0.40.0/24,10.0.90.0/24 --dport 22 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new incoming ssh from devices/vpn"
    
    echo -e "\nOUTPUT"

        # dns per user account before blocking local
        echo -e " - ACCEPT dns out for _apt to network"
            iptables -A OUTPUT -p udp -d 10.0.30.1 --dport 53 -m owner --uid-owner _apt -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing dns for _apt"

        echo -e " - ACCEPT dns out for ntp to network"
            iptables -A OUTPUT -p udp -d 10.0.30.1 --dport 53 -m owner --uid-owner ntpsec -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing dns for ntp"

        echo -e " - ACCEPT dns out for uptime to network"
            iptables -A OUTPUT -p udp -d 10.0.30.1 --dport 53 -m owner --uid-owner uptime -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing dns for uptime"

        # block local after dns
        echo -e " - DROP local OUT"
            iptables -A OUTPUT -d 10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,169.254.0.0/16 -j DROP -m comment --comment "DROP local"

        # http per user account
        echo -e " - ACCEPT http OUT for _apt"
            iptables -A OUTPUT -p tcp --dport 80 -m owner --uid-owner _apt -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing http for _apt"

        # https per user account
        echo -e " - ACCEPT https OUT for _apt"
            iptables -A OUTPUT -p tcp --dport 443 -m owner --uid-owner _apt -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing https for _apt"
        
        echo -e " - ACCEPT https OUT for uptime"
            iptables -A OUTPUT -p tcp --dport 443 -m owner --uid-owner uptime -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing https for uptime"

        # ntp per account
        echo -e " - ACCEPT ntp OUT for ntp"
            iptables -A OUTPUT -p udp --dport 123 -m owner --uid-owner ntpsec -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing NTP"


        
    
    firewall_persistentSave
}