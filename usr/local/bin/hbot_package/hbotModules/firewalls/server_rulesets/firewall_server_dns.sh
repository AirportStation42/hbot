#!/bin/bash

function firewall_server_dns
{
    firewall_header

    echo -e "\n\e[44mDeploying DNS Server Firewall Rules\e[49m"

    echo -e "\nALLOW services IN"
        echo " - dns"
            iptables -A INPUT -p udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new incoming dns anywhere"
        echo " - dns (tcp)"
            iptables -A INPUT -p tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new incoming dns (tcp) anywhere"        
        echo " - http"
            iptables -A INPUT -p tcp -s 10.0.40.0/24,10.0.90.0/24 --dport 80 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new incoming http from devices,vpn"
        echo " - https"
            iptables -A INPUT -p tcp -s 10.0.40.0/24,10.0.90.0/24 --dport 443 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new incoming https from devices,vpn"
       echo " - https from proxy"
            iptables -A INPUT -p tcp -s 10.0.30.20 --dport 80 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new incoming http from reverse proxy" 
        echo " - ssh"
            iptables -A INPUT -p tcp -s 10.0.40.0/24,10.0.90.0/24 --dport 22 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new incoming ssh from devices,vpn"
        echo " - icmp ping"
            iptables -A INPUT -p icmp --icmp-type 8 -s 10.0.30.0/24,10.0.40.0/24,10.0.90.0/24 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new incoming ping from servers,devices,vpn"

    echo -e "\nALLOW services OUT"
        echo -e " - dns"
            iptables -A OUTPUT -p udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing dns"
        echo -e " - http"
            iptables -A OUTPUT -p tcp --dport 80 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing http"
        echo -e " - https"
            iptables -A OUTPUT -p tcp --dport 443 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing https"
        echo -e " - ntp"
            iptables -A OUTPUT -p udp --dport 123 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing ntp"

    firewall_persistentSave

    echo -e "\n\e[91mDon't Forget About Edge Firewall!\e[39m"
    echo -e "\n\e[31mSSH should be alive, if frozen and not coming back, try SSHing in a new terminal\e[39m\n"
}