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
        address 185.61.113.81/30
        address 2a04:ebc0:766:2:25::1/112
        description "Core: rt1-gorras to rt2-gorras"
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
        ipv6 {
            dup-addr-detect-transmits 1
            ospfv3 {
                cost 1
                dead-interval 40
                hello-interval 10
                instance-id 0
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
        address 185.19.148.38/30
        address 2A04:EBC0:748:2:2::2/112
        description "Core: PtP Llwyn-y-Gorras to Cowshed"
        duplex auto
        ip {
            ospf {
                cost 50
                dead-interval 40
                hello-interval 10
                network point-to-point
                priority 1
                retransmit-interval 5
                transmit-delay 1
            }
        }
        ipv6 {
            dup-addr-detect-transmits 1
            ospfv3 {
                cost 60
                dead-interval 40
                hello-interval 10
                instance-id 0
                priority 1
                retransmit-interval 5
                transmit-delay 1
            }
        }
        poe {
            output off
        }
        speed auto
        vif 36 {
            address 185.61.113.65/30
            description ptp0-mgmt
        }
    }
    ethernet eth2 {
        description "temp to sw0"
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
    ethernet eth3 {
        duplex auto
        poe {
            output off
        }
        speed auto
    }
    ethernet eth4 {
        address 185.61.112.118/30
        address 2A04:EBC0:766:2:10::1/112
        description "Core: Pole to Neighbors"
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
        address 185.61.112.70/32
        address 2a04:ebc0:766:1::70/128
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
                network 2A04:EBC0:700::/40 {
                    route-map originated-supernet-v6-map
                }
                network 2A04:EBC0:714::/48 {
                    route-map originated-supernet-v6-map
                }
                network 2A04:EBC0:766::/48 {
                    route-map originated-supernet-v6-map
                }
            }
        }
        neighbor 185.19.148.1 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.61.112.70
        }
        neighbor 185.61.112.65 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.61.112.70
        }
        neighbor 185.61.112.66 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.61.112.70
        }
        neighbor 185.61.112.71 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.61.112.70
        }
        neighbor 185.61.112.72 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.61.112.70
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
        neighbor 2a04:ebc0:766:1::66 {
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
        neighbor 2a04:ebc0:766:1::72 {
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
        network 185.19.148.0/23 {
            route-map originated-supernet-v4-map
        }
        network 185.61.112.0/22 {
            route-map originated-supernet-v4-map
        }
        network 185.61.112.0/24 {
            route-map originated-supernet-v4-map
        }
        network 185.61.113.0/24 {
            route-map originated-supernet-v4-map
        }
        network 185.61.113.64/30 {
            route-map originated-internal-v4-map
        }
        network 185.61.114.0/24 {
            route-map originated-supernet-v4-map
        }
        network 185.61.115.0/24 {
            route-map originated-supernet-v4-map
        }
        network 195.177.252.0/24 {
            route-map originated-supernet-v4-map
        }
        parameters {
            default {
            }
            router-id 185.61.112.70
        }
    }
    ospf {
        area 0 {
            network 185.61.112.70/32
            network 185.19.148.36/30
            network 185.61.112.116/30
            network 185.61.113.76/30
            network 185.61.113.80/30
        }
        parameters {
            abr-type cisco
            router-id 185.61.112.70
        }
    }
    ospfv3 {
        area 0.0.0.0 {
            interface lo
            interface eth1
            interface eth4
            interface eth0
        }
        parameters {
            router-id 185.61.112.70
        }
    }
    static {
        route 185.19.148.0/23 {
            blackhole {
            }
        }
        route 185.61.112.0/22 {
            blackhole {
            }
        }
        route 185.61.112.0/24 {
            blackhole {
            }
        }
        route 185.61.113.0/24 {
            blackhole {
            }
        }
        route 185.61.113.64/30 {
            blackhole {
            }
        }
        route 185.61.114.0/24 {
            blackhole {
            }
        }
        route 185.61.115.0/24 {
            blackhole {
            }
        }
        route 195.177.252.0/24 {
            blackhole {
            }
        }
        route6 2A04:EBC0:700::/40 {
            blackhole {
            }
        }
        route6 2A04:EBC0:714::/48 {
            blackhole {
            }
        }
        route6 2A04:EBC0:766::/48 {
            blackhole {
            }
        }
    }
}
service {
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
    host-name rt1-gorras
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
