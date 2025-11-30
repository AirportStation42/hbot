#!/bin/bash

function firewall_server_web
{
    firewall_header
    
    echo -e "\nACCEPT services IN"
        echo " - ssh       (ACCEPT - IN)"
            iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new incoming ssh"
        echo " - http      (ACCEPT - IN)"
            iptables -A INPUT -p tcp --dport 80 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new incoming http"
        echo " - https     (ACCEPT - IN)"
            iptables -A INPUT -p tcp --dport 443 -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new incoming https"

    # ACCEPT Data Out -> All Handled on a per-user basis
        echo -e "\nACCEPT services OUT (per-user basis)"

            # Root Only
                echo " - ssh       root         (ACCEPT - OUT)"
                    iptables -A OUTPUT -p tcp --dport 22 -m owner --uid-owner root -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing ssh for root"
                echo " - ping      root         (ACCEPT - OUT)"
                    iptables -A OUTPUT -p icmp --icmp-type 8 -m owner --uid-owner root -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing ping request for root"
                echo " - Speedtest root         (ACCEPT - OUT)"
                    iptables -A OUTPUT -p tcp --dport 8080 -m owner --uid-owner root -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing Speedtest (8080) for root"
            
            # Loop for services enabled across multiple accounts
                USERS=( root _apt www-data )
                for U in "${USERS[@]}"
                do
                    echo " - http      $U         (ACCEPT - OUT)"
                        iptables -A OUTPUT -p tcp --dport 80 -m owner --uid-owner $U -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing http for $U"
                    echo " - https     $U         (ACCEPT - OUT)"
                        iptables -A OUTPUT -p tcp --dport 443 -m owner --uid-owner $U -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing https for $U"
                    echo " - dns       $U         (ACCEPT - OUT)"
                        iptables -A OUTPUT -p udp --dport 53 -m owner --uid-owner $U -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing dns for $U"
                done

            # www-data only
                echo " - smtp      www-data         (ACCEPT - OUT)"
                    iptables -A OUTPUT -p tcp --dport 587 -m owner --uid-owner www-data -m conntrack --ctstate NEW -j ACCEPT -m comment --comment "ACCEPT new outgoing smtp for www-data"
            
    #    #Figure out if these need to go on input or output (exept for ping), for ones going out, look into what account needs to do so to use owner mod
    #        echo "ACCEPT ICMP"
    #            echo " - Dest. unreachable  (IN)"
    #                iptables -A INPUT -p icmp --icmp-type 3  -m limit --limit 1/s --limit-burst 2 -j ACCEPT -m comment --comment "Limited ACCEPT ICMP IN Dest. unreachable (3)"
    #            echo " - Dest. unreachable  (OUT)"
    #                iptables -A OUTPUT -p icmp --icmp-type 3 -m limit --limit 1/s --limit-burst 2 -j ACCEPT -m comment --comment "Limited ACCEPT ICMP OUT Dest. unreachable (3)"
    #            echo " - Redirect           (IN)"
    #                iptables -A INPUT -p icmp --icmp-type 5 -m limit --limit 1/s --limit-burst 2 -j ACCEPT -m comment --comment "Limited ACCEPT ICMP IN Redirect (5)"
    #            echo " - Redirect           (OUT)"
    #                iptables -A OUTPUT -p icmp --icmp-type 5 -m limit --limit 1/s --limit-burst 2 -j ACCEPT -m comment --comment "Limited ACCEPT ICMP OUT Redirect (5)"
    #            echo " - Route Advert       (IN)"
    #                iptables -A INPUT -p icmp --icmp-type 9 -m limit --limit 1/s --limit-burst 2 -j ACCEPT -m comment --comment "Limited ACCEPT ICMP IN Route Advert (9)"
    #            echo " - Route Advert       (OUT)"
    #                iptables -A OUTPUT -p icmp --icmp-type 9 -m limit --limit 1/s --limit-burst 2 -j ACCEPT -m comment --comment "Limited ACCEPT ICMP OUT Route Advert (9)"
    #            echo " - Time Exce.         (IN)"
    #                iptables -A INPUT -p icmp --icmp-type 11  -m limit --limit 1/s --limit-burst 2 -j ACCEPT -m comment --comment "Limited ACCEPT ICMP IN Time Exce. (11)"
    #            echo " - Time Exce.         (OUT)"
    #                iptables -A OUTPUT -p icmp --icmp-type 11 -m limit --limit 1/s --limit-burst 2 -j ACCEPT -m comment --comment "Limited  ACCEPT ICMP OUT Time Exce. (11)"
        
    firewall_persistentSave

    echo -e "\n\e[91mDon't Forget About Edge Firewall!\e[39m"
    echo -e "\n\e[31mSSH should be alive, if frozen and not coming back, try SSHing in a new terminal\e[39m\n"
}