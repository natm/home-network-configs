firewall {
    all-ping enable
    broadcast-ping disable
    ipv6-receive-redirects disable
    ipv6-src-route disable
    ip-src-route disable
    log-martians enable
    receive-redirects disable
    send-redirects enable
    source-validation disable
    syn-cookies enable
}
interfaces {
    ethernet eth0 {
        address 185.61.113.82/30
        address 2a04:ebc0:766:2:25::2/112
        description "Core: rt2-gorras to rt1-gorras"
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
        poe {
            output off
        }
        speed auto
    }
    ethernet eth1 {
        address 185.61.113.145/28
        address 2A04:EBC0:766:117::1/64
        address 185.61.113.129/28
        description "to swpole1"
        duplex auto
        poe {
            output off
        }
        speed auto
    }
    ethernet eth2 {
        duplex auto
        poe {
            output off
        }
        speed auto
    }
    ethernet eth3 {
        duplex auto
        poe {
            output off
        }
        speed auto
    }
    ethernet eth4 {
        address 185.61.112.89/30
        address 2A04:EBC0:766:2:3::1/112
        description to-shed-sw1
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
        poe {
            output off
        }
        speed auto
    }
    loopback lo {
        address 185.61.112.71/32
        address 2a04:ebc0:766:1::71/128
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
    prefix-list6 all-v6 {
        rule 10 {
            action permit
            le 128
            prefix ::/0
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
    route-map deny-all-v6 {
        rule 10 {
            action deny
            match {
                ipv6 {
                    address {
                        prefix-list all-v6
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
                network 2A04:EBC0:766:116::/64 {
                    route-map originated-internal-v6-map
                }
                network 2A04:EBC0:766:117::/64 {
                    route-map originated-internal-v6-map
                }
            }
        }
        neighbor 185.19.148.1 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.61.112.71
        }
        neighbor 185.19.148.2 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.61.112.71
        }
        neighbor 185.19.149.1 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.61.112.71
        }
        neighbor 185.19.149.2 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.61.112.71
        }
        neighbor 185.19.149.3 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.61.112.71
        }
        neighbor 185.61.112.64 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.61.112.71
        }
        neighbor 185.61.112.65 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.61.112.71
        }
        neighbor 185.61.112.66 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.61.112.71
        }
        neighbor 185.61.112.67 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.61.112.71
        }
        neighbor 185.61.112.68 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.61.112.71
        }
        neighbor 185.61.112.69 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.61.112.71
        }
        neighbor 185.61.112.70 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.61.112.71
        }
        neighbor 185.61.112.72 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.61.112.71
        }
        neighbor 2a04:ebc0:748:1::1 {
            address-family {
                ipv6-unicast {
                    maximum-prefix 1000
                    nexthop-self
                }
            }
            remote-as 60036
            route-map {
                import deny-all-v4
            }
            update-source 2a04:ebc0:766:1::71
        }
        neighbor 2a04:ebc0:748:1::2 {
            address-family {
                ipv6-unicast {
                    maximum-prefix 1000
                    nexthop-self
                }
            }
            remote-as 60036
            route-map {
                import deny-all-v4
            }
            update-source 2a04:ebc0:766:1::71
        }
        neighbor 2a04:ebc0:749:1::1 {
            address-family {
                ipv6-unicast {
                    maximum-prefix 1000
                    nexthop-self
                }
            }
            remote-as 60036
            route-map {
                import deny-all-v4
            }
            update-source 2a04:ebc0:766:1::71
        }
        neighbor 2a04:ebc0:749:1::2 {
            address-family {
                ipv6-unicast {
                    maximum-prefix 1000
                    nexthop-self
                }
            }
            remote-as 60036
            route-map {
                import deny-all-v4
            }
            update-source 2a04:ebc0:766:1::71
        }
        neighbor 2a04:ebc0:749:1::3 {
            address-family {
                ipv6-unicast {
                    maximum-prefix 1000
                    nexthop-self
                }
            }
            remote-as 60036
            route-map {
                import deny-all-v4
            }
            update-source 2a04:ebc0:766:1::71
        }
        neighbor 2a04:ebc0:766:1::64 {
            address-family {
                ipv6-unicast {
                    maximum-prefix 1000
                    nexthop-self
                }
            }
            remote-as 60036
            route-map {
                import deny-all-v4
            }
            update-source 2a04:ebc0:766:1::71
        }
        neighbor 2a04:ebc0:766:1::65 {
            address-family {
                ipv6-unicast {
                    maximum-prefix 1000
                    nexthop-self
                }
            }
            remote-as 60036
            route-map {
                import deny-all-v4
            }
            update-source 2a04:ebc0:766:1::71
        }
        neighbor 2a04:ebc0:766:1::66 {
            address-family {
                ipv6-unicast {
                    maximum-prefix 1000
                    nexthop-self
                }
            }
            remote-as 60036
            route-map {
                import deny-all-v4
            }
            update-source 2a04:ebc0:766:1::71
        }
        neighbor 2a04:ebc0:766:1::67 {
            address-family {
                ipv6-unicast {
                    maximum-prefix 1000
                    nexthop-self
                }
            }
            remote-as 60036
            route-map {
                import deny-all-v4
            }
            update-source 2a04:ebc0:766:1::71
        }
        neighbor 2a04:ebc0:766:1::68 {
            address-family {
                ipv6-unicast {
                    maximum-prefix 1000
                    nexthop-self
                }
            }
            remote-as 60036
            route-map {
                import deny-all-v4
            }
            update-source 2a04:ebc0:766:1::71
        }
        neighbor 2a04:ebc0:766:1::69 {
            address-family {
                ipv6-unicast {
                    maximum-prefix 1000
                    nexthop-self
                }
            }
            remote-as 60036
            route-map {
                import deny-all-v4
            }
            update-source 2a04:ebc0:766:1::71
        }
        neighbor 2a04:ebc0:766:1::70 {
            address-family {
                ipv6-unicast {
                    maximum-prefix 1000
                    nexthop-self
                }
            }
            remote-as 60036
            route-map {
                import deny-all-v4
            }
            update-source 2a04:ebc0:766:1::71
        }
        neighbor 2a04:ebc0:766:1::72 {
            address-family {
                ipv6-unicast {
                    maximum-prefix 1000
                    nexthop-self
                }
            }
            remote-as 60036
            route-map {
                import deny-all-v4
            }
            update-source 2a04:ebc0:766:1::71
        }
        network 185.61.113.128/28 {
            route-map originated-internal-v4-map
        }
        network 185.61.113.144/28 {
            route-map originated-internal-v4-map
        }
        parameters {
            default {
            }
            router-id 185.61.112.71
        }
    }
    ospf {
        area 0 {
            network 185.61.112.71/32
            network 185.61.113.80/30
            network 185.61.113.72/30
            network 185.61.112.88/30
        }
        parameters {
            abr-type cisco
            router-id 185.61.112.71
        }
    }
    ospfv3 {
        area 0.0.0.0 {
            interface lo
            interface eth0
            interface eth4
        }
        parameters {
            router-id 185.61.112.71
        }
    }
    static {
        route 185.61.113.128/28 {
            blackhole {
            }
        }
        route 185.61.113.144/28 {
            blackhole {
            }
        }
        route6 2A04:EBC0:766:116::/64 {
            blackhole {
            }
        }
        route6 2A04:EBC0:766:117::/64 {
            blackhole {
            }
        }
    }
}
service {
    dhcp-server {
        disabled false
        hostfile-update disable
        shared-network-name pole-devices {
            authoritative enable
            subnet 185.61.113.144/28 {
                default-router 185.61.113.145
                dns-server 185.61.112.98
                dns-server 185.19.148.98
                lease 3600
                start 185.61.113.146 {
                    stop 185.61.113.158
                }
                static-mapping adsb {
                    ip-address 185.61.113.152
                    mac-address b8:27:eb:52:8d:11
                }
                static-mapping cctvpole1 {
                    ip-address 185.61.113.156
                    mac-address c0:56:e3:ef:a7:60
                }
            }
        }
    }
    gui {
        https-port 443
    }
    lldp {
        interface all {
        }
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
    host-name rt2-gorras
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
    offload {
        ipsec enable
        ipv4 {
            forwarding enable
            pppoe enable
            vlan enable
        }
        ipv6 {
            forwarding enable
            pppoe enable
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
    time-zone UTC
}
