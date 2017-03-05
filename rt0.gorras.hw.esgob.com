interfaces {
    ethernet eth0 {
        address 185.61.114.1/29
        address 2a04:ebc0:714:101::1/64
        description "Cust: Julia and Ken"
        duplex auto
        speed auto
    }
    ethernet eth1 {
        address 2a04:ebc0:714:102::1/64
        address 195.177.252.9/29
        description "Cust: Neil"
        duplex auto
        poe {
            output off
        }
        speed auto
    }
    ethernet eth2 {
        address 2a04:ebc0:714:103::1/64
        address 185.61.114.17/29
        description "Cust: Jane and Ken"
        duplex auto
        poe {
            output off
        }
        speed auto
    }
    ethernet eth3 {
        address 2a04:ebc0:714:104::1/64
        address 185.61.114.25/29
        description "Cust: Adam and Helena"
        duplex auto
        poe {
            output off
        }
        speed auto
    }
    ethernet eth4 {
        address 2a04:ebc0:714:105::1/64
        address 185.61.114.33/29
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
                network 2a04:ebc0:714:101::/64 {
                    route-map originated-internal-v6-map
                }
                network 2a04:ebc0:714:102::/64 {
                    route-map originated-internal-v6-map
                }
                network 2a04:ebc0:714:103::/64 {
                    route-map originated-internal-v6-map
                }
                network 2a04:ebc0:714:104::/64 {
                    route-map originated-internal-v6-map
                }
                network 2a04:ebc0:714:105::/64 {
                    route-map originated-internal-v6-map
                }
            }
        }
        neighbor 185.19.148.1 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.61.112.72
        }
        neighbor 185.19.148.2 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.61.112.72
        }
        neighbor 185.19.149.1 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.61.112.72
        }
        neighbor 185.19.149.2 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.61.112.72
        }
        neighbor 185.19.149.3 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.61.112.72
        }
        neighbor 185.61.112.64 {
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
        neighbor 185.61.112.66 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.61.112.72
        }
        neighbor 185.61.112.67 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.61.112.72
        }
        neighbor 185.61.112.68 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.61.112.72
        }
        neighbor 185.61.112.69 {
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
            remote-as 60036
            route-map {
                import deny-all-v4
            }
            update-source 185.61.112.72
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
            update-source 185.61.112.72
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
            update-source 185.61.112.72
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
            update-source 185.61.112.72
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
            update-source 185.61.112.72
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
            update-source 185.61.112.72
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
            update-source 185.61.112.72
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
            update-source 185.61.112.72
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
            update-source 185.61.112.72
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
            update-source 185.61.112.72
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
            update-source 185.61.112.72
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
            update-source 185.61.112.72
        }
        neighbor 2a04:ebc0:766:1::71 {
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
            update-source 185.61.112.72
        }
        network 185.61.114.0/29 {
            route-map originated-internal-v4-map
        }
        network 185.61.114.8/29 {
            route-map originated-internal-v4-map
        }
        network 185.61.114.16/29 {
            route-map originated-internal-v4-map
        }
        network 185.61.114.24/29 {
            route-map originated-internal-v4-map
        }
        network 185.61.114.32/29 {
            route-map originated-internal-v4-map
        }
        network 195.177.252.8/29 {
            route-map originated-internal-v4-map
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
        route 185.61.114.0/29 {
            blackhole {
            }
        }
        route 185.61.114.8/29 {
            blackhole {
            }
        }
        route 185.61.114.16/29 {
            blackhole {
            }
        }
        route 185.61.114.24/29 {
            blackhole {
            }
        }
        route 185.61.114.32/29 {
            blackhole {
            }
        }
        route 195.177.252.8/29 {
            blackhole {
            }
        }
        route6 2a04:ebc0:714:101::/64 {
            blackhole {
            }
        }
        route6 2a04:ebc0:714:102::/64 {
            blackhole {
            }
        }
        route6 2a04:ebc0:714:103::/64 {
            blackhole {
            }
        }
        route6 2a04:ebc0:714:104::/64 {
            blackhole {
            }
        }
        route6 2a04:ebc0:714:105::/64 {
            blackhole {
            }
        }
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
        shared-network-name adam-and-helena {
            authoritative enable
            subnet 185.61.114.24/29 {
                default-router 185.61.114.25
                dns-server 185.61.112.98
                dns-server 185.19.148.98
                lease 3600
                start 185.61.114.26 {
                    stop 185.61.114.30
                }
                static-mapping AdamHelena_Archer_C2 {
                    ip-address 185.61.114.26
                    mac-address a4:2b:b0:a4:7b:71
                }
            }
        }
        shared-network-name ken-and-jane {
            authoritative enable
            subnet 185.61.114.16/29 {
                default-router 185.61.114.17
                dns-server 185.61.112.98
                dns-server 185.19.148.98
                lease 3600
                start 185.61.114.18 {
                    stop 185.61.114.22
                }
                static-mapping JaneKen_Archer_C2 {
                    ip-address 185.61.114.18
                    mac-address f4:f2:6d:9b:cf:7d
                }
            }
        }
        shared-network-name ken-and-julia {
            authoritative enable
            subnet 185.61.114.0/29 {
                default-router 185.61.114.1
                dns-server 185.61.112.98
                dns-server 185.19.148.98
                lease 3600
                start 185.61.114.2 {
                    stop 185.61.114.7
                }
                static-mapping JuliaKen_Archer_C2 {
                    ip-address 185.61.114.2
                    mac-address f4:f2:6d:7a:cc:31
                }
            }
        }
        shared-network-name neil {
            authoritative enable
            subnet 195.177.252.8/29 {
                default-router 195.177.252.9
                dns-server 185.61.112.98
                dns-server 185.19.148.98
                lease 3600
                start 195.177.252.10 {
                    stop 195.177.252.14
                }
                static-mapping Neil_Archer_C2 {
                    ip-address 195.177.252.10
                    mac-address f4:f2:6d:9b:dc:82
                }
            }
        }
        shared-network-name test {
            authoritative enable
            subnet 185.61.114.32/29 {
                default-router 185.61.114.33
                dns-server 185.61.112.98
                dns-server 185.19.148.98
                lease 3600
                start 185.61.114.34 {
                    stop 185.61.114.38
                }
            }
        }
    }
    dhcpv6-server {
        shared-network-name test {
            subnet 2a04:ebc0:714:105::/64 {
                prefix-delegation {
                    start 2a04:ebc0:714:1500:: {
                        prefix-length 56
                        stop 2a04:ebc0:714:15ff::
                    }
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
            }
        }
    }
    time-zone Europe/London
}
