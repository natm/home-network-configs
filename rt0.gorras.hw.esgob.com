interfaces {
    bridge br0 {
        description "julia and ken"
    }
    bridge br1 {
        description neil
    }
    bridge br2 {
        description "jane and ken"
    }
    bridge br3 {
        description "adam and helena"
    }
    ethernet eth0 {
        bridge-group {
            bridge br0
        }
        description "Cust: Julia and Ken"
        duplex auto
        speed auto
    }
    ethernet eth1 {
        bridge-group {
            bridge br1
        }
        description "Cust: Neil"
        duplex auto
        poe {
            output off
        }
        speed auto
    }
    ethernet eth2 {
        bridge-group {
            bridge br2
        }
        description "Cust: Jane and Ken"
        duplex auto
        poe {
            output off
        }
        speed auto
    }
    ethernet eth3 {
        bridge-group {
            bridge br3
        }
        description "Cust: Adam and Helena"
        duplex auto
        poe {
            output off
        }
        speed auto
    }
    ethernet eth4 {
        description test
        duplex auto
        ipv6 {
            dup-addr-detect-transmits 1
            router-advert {
                cur-hop-limit 64
                link-mtu 0
                managed-flag false
                max-interval 600
                other-config-flag false
                prefix ::/64 {
                    autonomous-flag true
                    on-link-flag true
                    valid-lifetime 2592000
                }
                reachable-time 0
                retrans-timer 0
                send-advert true
            }
        }
        speed auto
    }
    ethernet eth5 {
        address 185.61.112.117/30
        address 2a04:ebc0:766:2:10::2/112
        description "to-sw0.gi/1/0/2  (cisco switch at pole)"
        duplex auto
        ip {
            ospf {
                dead-interval 40
                hello-interval 10
                network point-to-point
                priority 1
                retransmit-interval 5
                transmit-delay 1
            }
        }
        speed auto
        vif 100 {
            bridge-group {
                bridge br0
            }
        }
        vif 101 {
            bridge-group {
                bridge br1
            }
            description neil
        }
        vif 102 {
            bridge-group {
                bridge br2
            }
        }
        vif 103 {
            bridge-group {
                bridge br3
            }
        }
    }
    loopback lo {
        address 185.61.112.72/32
        address 2a04:ebc0:766:1::72/128
        description test4
    }
    switch switch0 {
        mtu 1500
    }
}
policy {
    prefix-list all-v4 {
        rule 10 {
            action permit
            le 32
            prefix 0.0.0.0/0
        }
    }
    route-map deny-all-v4 {
        rule 10 {
            action deny
            match {
                ip {
                    address {
                        prefix-list all-v4
                    }
                }
            }
        }
    }
    route-map originated-internal-v4-map {
        rule 10 {
            action permit
            set {
                community "60036:4003 60036:8000 60036:8002"
            }
        }
    }
    route-map originated-internal-v6-map {
        rule 10 {
            action permit
            set {
                community "60036:4003 60036:8000 60036:8002"
            }
        }
    }
    route-map originated-supernet-v4-map {
        rule 10 {
            action permit
            set {
                community "60036:4003 60036:8000 60036:8001"
            }
        }
    }
    route-map originated-supernet-v6-map {
        rule 10 {
            action permit
            set {
                community "60036:4003 60036:8000 60036:8001"
            }
        }
    }
}
protocols {
    bgp 60036 {
        address-family {
            ipv6-unicast {
            }
        }
        neighbor 185.19.148.1 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.61.112.72
        }
        neighbor 185.61.112.65 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.61.112.72
        }
        neighbor 185.61.112.70 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.61.112.72
        }
        neighbor 185.61.112.71 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.61.112.72
        }
        neighbor 2a04:ebc0:748:1::1 {
            address-family {
                ipv6-unicast {
                    maximum-prefix 1000
                    nexthop-self
                }
            }
            no-activate
            remote-as 60036
            route-map {
                import deny-all-v4
            }
            update-source lo
        }
        neighbor 2a04:ebc0:766:1::65 {
            address-family {
                ipv6-unicast {
                    maximum-prefix 1000
                    nexthop-self
                }
            }
            no-activate
            remote-as 60036
            route-map {
                import deny-all-v4
            }
            update-source lo
        }
        neighbor 2a04:ebc0:766:1::70 {
            address-family {
                ipv6-unicast {
                    maximum-prefix 1000
                    nexthop-self
                }
            }
            no-activate
            remote-as 60036
            route-map {
                import deny-all-v4
            }
            update-source lo
        }
        neighbor 2a04:ebc0:766:1::71 {
            address-family {
                ipv6-unicast {
                    maximum-prefix 1000
                    nexthop-self
                }
            }
            no-activate
            remote-as 60036
            route-map {
                import deny-all-v4
            }
            update-source lo
        }
        parameters {
            default {
            }
            router-id 185.61.112.72
        }
    }
    ospf {
        area 0 {
            network 185.61.112.72/32
            network 185.61.112.116/30
        }
        parameters {
            abr-type cisco
            router-id 185.61.112.72
        }
    }
    ospfv3 {
        area 0.0.0.0 {
            interface lo
            interface eth5
        }
        parameters {
            router-id 185.61.112.72
        }
    }
    static {
        route6 2a04:ebc0:714::/48 {
            blackhole {
            }
        }
    }
}
service {
    dhcp-server {
        disabled false
        hostfile-update disable
        use-dnsmasq disable
    }
    dhcpv6-server {
    }
    gui {
        http-port 80
        https-port 443
        older-ciphers enable
    }
    lldp {
        interface all {
        }
    }
    nat {
    }
    snmp {
        community <hidden> {
            authorization ro
        }
    }
    ssh {
        port 22
        protocol-version v2
    }
}
system {
    domain-name hw.esgob.com
    host-name rt0-gorras
    login {
        user nat {
            authentication {
                encrypted-password ****************
                plaintext-password ****************
            }
            level admin
        }
        user neil {
            authentication {
                encrypted-password ****************
                plaintext-password ****************
            }
            level admin
        }
        user oxidized-prod {
            authentication {
                encrypted-password ****************
                plaintext-password ****************
            }
            level admin
        }
        user oxidized-test {
            authentication {
                encrypted-password ****************
                plaintext-password ****************
            }
            level admin
        }
    }
    name-server 185.61.112.98
    name-server 185.19.148.98
    ntp {
        server 185.61.112.97 {
        }
    }
    syslog {
        global {
            facility all {
                level notice
            }
            facility protocols {
                level debug
            }
        }
        host 185.61.112.99 {
            facility all {
                level info
            }
        }
    }
    time-zone Europe/London
}
