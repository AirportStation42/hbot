#!/bin/bash

function firewall_server_pbs
{
    firewall_header

    echo -e "\n\e[44mDeploying Proxmox Backup Server Firewall Rules\e[49m"

    echo -e "\nALLOW services IN"
        echo " - pbs 8007  (IN)"
            iptables -A INPUT -p tcp -s 10.0.30.10/32,10.0.30.20/32,10.0.40.0/24,10.0.90.0/24 --dport 8007 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new incoming pbs 8007 from pve,proxy,devices,vpn"
        echo " - ssh"
            iptables -A INPUT -p tcp -s 10.0.40.0/24,10.0.90.0/24 --dport 22 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new incoming ssh from devices,vpn"
        echo " - icmp ping (IN)"
            iptables -A INPUT -p icmp --icmp-type 8 -s 10.0.30.0/24,10.0.40.0/24,10.0.90.0/24 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new incoming ping from servers,devices,vpn"
    
    echo -e "\nALLOW services OUT"
        echo -e " - ACCEPT http OUT"
            iptables -A OUTPUT -p tcp --dport 80 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing http"
        echo -e " - ACCEPT https OUT"
            iptables -A OUTPUT -p tcp --dport 443 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing https"
        echo -e " - ACCEPT dns OUT"
            iptables -A OUTPUT -p udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing dns"
        echo -e " - ACCEPT ntp OUT"
            iptables -A OUTPUT -p udp --dport 123 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing ntp"
        echo -e " - ACCEPT smtps OUT"
            iptables -A OUTPUT -p tcp --dport 465 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing smtps"

    firewall_persistentSave

    echo -e "\n\e[91mDon't Forget About Edge Firewall!\e[39m"
    echo -e "\n\e[31mSSH should be alive, if frozen and not coming back, try SSHing in a new terminal\e[39m\n"
}