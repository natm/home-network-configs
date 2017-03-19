firewall {
    all-ping enable
    broadcast-ping disable
    group {
        address-group adsb {
            address 185.61.113.152
            description ""
        }
        address-group authdns {
            address 185.61.112.98
            description ""
        }
        address-group bgpextneighbors {
            address 90.155.53.61
            address 90.155.53.62
            description "Offnet BGP neighbors"
        }
        address-group cctvnvr {
            address 185.61.112.148
            description ""
        }
        address-group mosh_servers {
            address 185.61.112.98
            description ""
        }
        address-group ournets {
            address 185.61.112.0/22
            address 185.19.148.0/23
            address 195.177.252.0/23
            address 91.232.181.0/24
            address 193.47.147.0/24
            description ""
        }
        address-group trusted_nat {
            address 185.19.150.0/24
            address 185.61.112.0/23
            address 195.177.252.0/23
            description ""
        }
        network-group no_filter_nets {
            description ""
            network 195.177.253.0/24
            network 193.47.147.0/24
        }
        port-group cctvnvr_ports {
            description ""
            port 80
            port 554
            port 8000
            port 9010
            port 9020
        }
        port-group mosh_ports {
            description ""
            port 60000-61000
        }
        port-group trusted_dst_ports {
            description ""
            port 22
            port 443
        }
    }
    ipv6-receive-redirects disable
    ipv6-src-route disable
    ip-src-route disable
    log-martians enable
    modify pppoe_modify_out {
        rule 1 {
            action modify
            modify {
                tcp-mss 1452
            }
            protocol tcp
            tcp {
                flags SYN
            }
        }
    }
    name transit4_in {
        default-action drop
        description ""
        rule 1 {
            action drop
            description "drop all NTP"
            destination {
                port 123
            }
            log disable
            protocol udp
            state {
                established enable
                invalid disable
                new enable
                related disable
            }
        }
        rule 2 {
            action accept
            description established
            log disable
            protocol all
            state {
                established enable
                invalid disable
                new disable
                related enable
            }
        }
        rule 3 {
            action accept
            description outbound
            log disable
            protocol all
            source {
                group {
                    address-group ournets
                }
            }
            state {
                established disable
                invalid disable
                new enable
                related disable
            }
        }
        rule 4 {
            action accept
            description ICMP
            log disable
            protocol icmp
            state {
                established enable
                invalid disable
                new enable
                related disable
            }
        }
        rule 5 {
            action accept
            description Traceroute
            destination {
                port 33434-33524
            }
            log disable
            protocol udp
            state {
                established enable
                invalid disable
                new enable
                related enable
            }
        }
        rule 6 {
            action accept
            description "trusted from nat"
            destination {
                group {
                }
            }
            log disable
            protocol all
            source {
                group {
                    address-group trusted_nat
                }
            }
            state {
                established disable
                invalid disable
                new enable
                related disable
            }
        }
        rule 7 {
            action accept
            description "No filtering to legacy networks"
            destination {
                group {
                    network-group no_filter_nets
                }
            }
            log disable
            protocol all
            state {
                established enable
                invalid disable
                new enable
                related disable
            }
        }
        rule 8 {
            action accept
            description "CCTV from NVR"
            destination {
                group {
                    address-group cctvnvr
                    port-group cctvnvr_ports
                }
            }
            log disable
            protocol tcp_udp
            source {
                group {
                }
            }
            state {
                established disable
                invalid disable
                new enable
                related disable
            }
        }
        rule 9 {
            action accept
            description "ADSB web ui"
            destination {
                group {
                    address-group adsb
                }
                port 80
            }
            log disable
            protocol tcp
            state {
                invalid disable
                related disable
            }
        }
        rule 10 {
            action accept
            description "http site redirects on homesvc1"
            destination {
                address 185.61.112.82
                port 80
            }
            log disable
            protocol tcp
            state {
                established enable
                invalid disable
                new enable
                related disable
            }
        }
        rule 11 {
            action accept
            description "ssl sites on homesvc1"
            destination {
                address 185.61.112.82
                port 443
            }
            log disable
            protocol tcp
            state {
                established disable
                invalid disable
                new enable
                related disable
            }
        }
        rule 12 {
            action accept
            description "ssh to homesvc"
            destination {
                address 185.61.112.82
                port 22
            }
            log disable
            protocol tcp
            state {
                established enable
                invalid disable
                new enable
                related disable
            }
        }
        rule 14 {
            action accept
            description "public access to mqtt (owntracks)"
            destination {
                address 185.61.112.82
                port 1883
            }
            log disable
            protocol tcp
            state {
                established enable
                invalid disable
                new enable
                related disable
            }
        }
        rule 15 {
            action accept
            description "mgmt access to pve1"
            destination {
                address 185.61.112.86
                port 8006
            }
            log disable
            protocol tcp
            state {
                established enable
                invalid disable
                new enable
                related disable
            }
        }
        rule 16 {
            action accept
            description "ssh to pve1"
            destination {
                address 185.61.112.86
                port 22
            }
            log disable
            protocol tcp
            state {
                established enable
                invalid disable
                new enable
                related disable
            }
        }
        rule 17 {
            action accept
            description "ssh to docker1"
            destination {
                address 185.61.112.134
                port 22
            }
            log disable
            protocol tcp
            state {
                established enable
                invalid disable
                new enable
                related disable
            }
        }
        rule 18 {
            action accept
            description "temporary DNS on loft"
            destination {
                address 185.61.112.37
                port 53
            }
            log disable
            protocol tcp_udp
            state {
                established enable
                invalid disable
                new enable
                related disable
            }
        }
        rule 19 {
            action accept
            description "legacy anycast DNS"
            destination {
                address 193.47.147.100
                port 53
            }
            log disable
            protocol tcp_udp
            state {
                established enable
                invalid disable
                new enable
                related disable
            }
        }
    }
    name transit4_local {
        default-action drop
        description ""
        rule 1 {
            action accept
            description established
            log disable
            protocol all
            state {
                established enable
                invalid disable
                new disable
                related enable
            }
        }
        rule 2 {
            action accept
            description "inbound ping"
            log disable
            protocol icmp
        }
        rule 3 {
            action accept
            description "bgp from aaisp"
            destination {
                port 179
            }
            log disable
            protocol tcp
            source {
                group {
                    address-group bgpextneighbors
                }
            }
            state {
                established disable
                invalid disable
                new enable
                related disable
            }
        }
        rule 4 {
            action accept
            description "trusted from nat"
            destination {
                group {
                    port-group trusted_dst_ports
                }
            }
            log disable
            protocol all
            source {
                group {
                    address-group trusted_nat
                }
            }
            state {
                established disable
                invalid disable
                new enable
                related disable
            }
        }
    }
    receive-redirects disable
    send-redirects enable
    source-validation disable
    syn-cookies enable
}
interfaces {
    ethernet eth0 {
        description "Transit: FTTC AAISP 1 in Mathry Cowshed"
        duplex auto
        pppoe 0 {
            default-route auto
            firewall {
                in {
                    name transit4_in
                }
                local {
                    name transit4_local
                }
                out {
                    modify pppoe_modify_out
                }
            }
            ipv6 {
                address {
                }
                dup-addr-detect-transmits 1
                enable {
                }
            }
            mtu 1492
            name-server auto
            password ****************
            user-id el6@a.1
        }
        speed auto
    }
    ethernet eth1 {
        description "Transit: FTTC AAISP 2 in Mathry Cowshed"
        duplex auto
        pppoe 1 {
            default-route auto
            firewall {
                in {
                    name transit4_in
                }
                local {
                    name transit4_local
                }
                out {
                    modify pppoe_modify_out
                }
            }
            ipv6 {
                address {
                }
                dup-addr-detect-transmits 1
                enable {
                }
            }
            mtu 1492
            name-server auto
            password ****************
            user-id el6@a.2
        }
        speed auto
    }
    ethernet eth2 {
        address 185.19.148.41/30
        address 2a04:ebc0:748:2:3::1/112
        description svc0
        duplex auto
        speed auto
    }
    ethernet eth3 {
        address 185.19.148.113/28
        address 2a04:ebc0:748:201::1/64
        description "sw0 port 26"
        duplex auto
        speed auto
        vif 128 {
            address 185.19.148.129/29
            address 2a04:ebc0:748:101::1/64
            description les-ann
            mtu 1500
        }
    }
    ethernet eth4 {
        address 185.19.148.37/30
        address 2A04:EBC0:748:2:2::1/112
        description "Core: PtP Cowshed to LlwynYGorras"
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
                cost 50
                dead-interval 40
                hello-interval 10
                instance-id 0
                priority 1
                retransmit-interval 5
                transmit-delay 1
            }
        }
        speed auto
        vif 37 {
            address 185.19.148.33/30
            description ptp0-mgmt
        }
    }
    ethernet eth5 {
        duplex auto
        speed auto
    }
    ethernet eth6 {
        duplex auto
        speed auto
    }
    ethernet eth7 {
        duplex auto
        speed auto
    }
    loopback lo {
        address 185.19.148.1/32
        address 2a04:ebc0:748:1::1/128
        address 185.19.150.68/32
        address 2a04:ec40:e004::1/128
    }
}
policy {
    community-list 66 {
        description rtbh-in
        rule 1 {
            action permit
            regex 60036:666
        }
    }
    community-list 100 {
        description transit-out
        rule 1 {
            action permit
            regex 60036:8001
        }
        rule 2 {
            action permit
            regex 60036:9000
        }
    }
    prefix-list all-v4 {
        rule 10 {
            action permit
            le 32
            prefix 0.0.0.0/0
        }
    }
    prefix-list slash24orless-v4 {
        rule 10 {
            action permit
            le 24
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
    prefix-list6 slash48orless-v6 {
        rule 10 {
            action permit
            le 48
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
                community "60036:4004 60036:8000 60036:8002"
            }
        }
    }
    route-map originated-internal-v6-map {
        rule 10 {
            action permit
            set {
                community "60036:4004 60036:8000 60036:8002"
            }
        }
    }
    route-map originated-supernet-v4-map {
        rule 10 {
            action permit
            set {
                community "60036:4004 60036:8000 60036:8001"
            }
        }
    }
    route-map originated-supernet-v6-map {
        rule 10 {
            action permit
            set {
                community "60036:4004 60036:8000 60036:8001"
            }
        }
    }
    route-map rtbh-in {
        rule 1 {
            action permit
            match {
                community {
                    community-list 66
                }
            }
            set {
                ip-next-hop 192.0.2.1
            }
        }
    }
    route-map transit-aaisp-v4-in-map {
        rule 10 {
            action permit
            set {
                community "60036:1000 60036:1001 60036:4004"
            }
        }
    }
    route-map transit-aaisp-v4-out-map {
        rule 10 {
            action permit
            match {
                community {
                    community-list 100
                }
                ip {
                    address {
                        prefix-list slash24orless-v4
                    }
                }
            }
        }
    }
    route-map transit-aaisp-v6-in-map {
        rule 10 {
            action permit
            set {
                community "60036:1000 60036:1001 60036:4004"
            }
        }
    }
    route-map transit-aaisp-v6-out-map {
        rule 10 {
            action permit
            match {
                community {
                    community-list 100
                }
                ipv6 {
                    address {
                        prefix-list slash48orless-v6
                    }
                }
            }
        }
    }
}
protocols {
    bgp 60036 {
        address-family {
            ipv6-unicast {
                network 2A04:EBC0:748::/48 {
                    route-map originated-supernet-v6-map
                }
                network 2a04:ebc0:748:2:3::/112 {
                    route-map originated-internal-v6-map
                }
                network 2a04:ebc0:748:200::/64 {
                }
                network 2a04:ebc0:748:201::/64 {
                    route-map originated-internal-v6-map
                }
            }
        }
        neighbor 90.155.53.61 {
            description aaisp1
            ebgp-multihop 4
            maximum-prefix 500
            remote-as 20712
            remove-private-as
            route-map {
                export transit-aaisp-v4-out-map
                import transit-aaisp-v4-in-map
            }
            soft-reconfiguration {
                inbound
            }
            update-source 185.19.150.68
        }
        neighbor 90.155.53.62 {
            description aaisp2
            ebgp-multihop 4
            maximum-prefix 500
            remote-as 20712
            remove-private-as
            route-map {
                export transit-aaisp-v4-out-map
                import transit-aaisp-v4-in-map
            }
            soft-reconfiguration {
                inbound
            }
            update-source 185.19.150.68
        }
        neighbor 185.19.148.42 {
            remote-as 65534
        }
        neighbor 185.61.112.65 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.19.148.1
        }
        neighbor 185.61.112.70 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.19.148.1
        }
        neighbor 185.61.112.71 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.19.148.1
        }
        neighbor 185.61.112.72 {
            maximum-prefix 1000
            nexthop-self
            remote-as 60036
            update-source 185.19.148.1
        }
        neighbor 2a04:ebc0:748:2:3::2 {
            address-family {
                ipv6-unicast {
                    maximum-prefix 1000
                }
            }
            no-activate
            remote-as 65534
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
        neighbor 2001:8b0:0:53::61 {
            address-family {
                ipv6-unicast {
                    maximum-prefix 500
                    route-map {
                        export transit-aaisp-v6-out-map
                        import transit-aaisp-v6-in-map
                    }
                }
            }
            ebgp-multihop 4
            maximum-prefix 500
            no-activate
            remote-as 20712
            remove-private-as
            soft-reconfiguration {
                inbound
            }
            update-source 2a04:ec40:e004::1
        }
        neighbor 2001:8b0:0:53::62 {
            address-family {
                ipv6-unicast {
                    maximum-prefix 500
                    route-map {
                        export transit-aaisp-v6-out-map
                        import transit-aaisp-v6-in-map
                    }
                }
            }
            ebgp-multihop 4
            maximum-prefix 500
            no-activate
            remote-as 20712
            remove-private-as
            soft-reconfiguration {
                inbound
            }
            update-source 2a04:ec40:e004::1
        }
        network 185.19.148.0/24 {
            route-map originated-supernet-v4-map
        }
        network 185.19.148.32/30 {
            route-map originated-internal-v4-map
        }
        network 185.19.148.40/30 {
            route-map originated-internal-v4-map
        }
        network 185.19.148.96/30 {
        }
        network 185.19.148.112/28 {
            route-map originated-internal-v4-map
        }
        parameters {
            default {
            }
            router-id 185.19.148.1
        }
    }
    ospf {
        area 0 {
            network 185.19.148.36/30
            network 185.19.148.1/32
        }
        parameters {
            abr-type cisco
            router-id 185.19.148.1
        }
    }
    ospfv3 {
        area 0.0.0.0 {
            interface eth4
            interface lo
        }
        parameters {
            router-id 185.19.148.1
        }
    }
    static {
        interface-route 90.155.53.60/32 {
            next-hop-interface pppoe0 {
            }
            next-hop-interface pppoe1 {
            }
        }
        interface-route 90.155.53.61/32 {
            next-hop-interface pppoe0 {
            }
            next-hop-interface pppoe1 {
            }
        }
        interface-route 90.155.53.62/32 {
            next-hop-interface pppoe0 {
            }
            next-hop-interface pppoe1 {
            }
        }
        interface-route6 2001:8b0:0:53::60/128 {
            next-hop-interface pppoe0 {
            }
            next-hop-interface pppoe1 {
            }
        }
        interface-route6 2001:8b0:0:53::61/128 {
            next-hop-interface pppoe0 {
            }
            next-hop-interface pppoe1 {
            }
        }
        interface-route6 2001:8b0:0:53::62/128 {
            next-hop-interface pppoe0 {
            }
            next-hop-interface pppoe1 {
            }
        }
        route 2.91.150.196/32 {
            blackhole {
                description anycastddos
            }
        }
        route 23.121.39.118/32 {
            blackhole {
                description anycastddos
            }
        }
        route 24.218.134.41/32 {
            blackhole {
                description anycastddos
            }
        }
        route 50.171.57.155/32 {
            blackhole {
                description anycastddos
            }
        }
        route 51.39.104.63/32 {
            blackhole {
                description anycastddos
            }
        }
        route 67.1.203.106/32 {
            blackhole {
                description anycastddos
            }
        }
        route 73.69.110.74/32 {
            blackhole {
                description anycastddos
            }
        }
        route 73.231.144.189/32 {
            blackhole {
                description anycastddos
            }
        }
        route 80.241.218.216/32 {
            blackhole {
                description anycastddos
            }
        }
        route 82.26.151.227/32 {
            blackhole {
                description anycastddos
            }
        }
        route 84.46.122.214/32 {
            blackhole {
                description anycastddos
            }
        }
        route 87.109.145.95/32 {
            blackhole {
                description anycastddos
            }
        }
        route 98.206.149.108/32 {
            blackhole {
                description anycastddos
            }
        }
        route 103.230.138.242/32 {
            blackhole {
                description anycastddos
            }
        }
        route 104.8.130.222/32 {
            blackhole {
                description anycastddos
            }
        }
        route 104.156.236.55/32 {
            blackhole {
                description anycastddos
            }
        }
        route 107.152.104.154/32 {
            blackhole {
                description anycastddos
            }
        }
        route 118.211.24.228/32 {
            blackhole {
                description anycastddos
            }
        }
        route 143.179.27.179/32 {
            blackhole {
                description anycastddos
            }
        }
        route 167.57.114.27/32 {
            blackhole {
                description anycastddos
            }
        }
        route 172.56.20.21/32 {
            blackhole {
                description anycastddos
            }
        }
        route 172.110.128.140/32 {
            blackhole {
                description anycastddos
            }
        }
        route 174.108.107.19/32 {
            blackhole {
                description anycastddos
            }
        }
        route 184.158.75.30/32 {
            blackhole {
                description anycastddos
            }
        }
        route 185.19.148.0/24 {
            blackhole {
            }
        }
        route 185.19.148.32/30 {
            blackhole {
            }
        }
        route 185.19.148.112/28 {
            blackhole {
            }
        }
        route 186.129.138.69/32 {
            blackhole {
                description anycastddos
            }
        }
        route 192.0.2.1/32 {
            blackhole {
            }
        }
        route 195.147.56.40/32 {
            blackhole {
                description anycastddos
            }
        }
        route6 2A04:EBC0:748::/48 {
            blackhole {
            }
        }
        route6 2a04:ebc0:748:201::/64 {
            blackhole {
            }
        }
    }
}
service {
    dhcp-server {
        disabled false
        hostfile-update disable
        shared-network-name les-morris {
            authoritative disable
            subnet 185.19.148.128/29 {
                default-router 185.19.148.129
                dns-server 185.19.148.98
                dns-server 185.61.112.98
                lease 86400
                start 185.19.148.130 {
                    stop 185.19.148.134
                }
            }
        }
        shared-network-name sw0-general {
            authoritative disable
            subnet 185.19.148.112/28 {
                default-router 185.19.148.113
                dns-server 185.19.148.98
                dns-server 185.61.112.98
                lease 3600
                start 185.19.148.114 {
                    stop 185.19.148.127
                }
                static-mapping ap0 {
                    ip-address 185.19.148.118
                    mac-address 28:94:0f:58:c9:10
                }
                static-mapping atlas1 {
                    ip-address 185.19.148.117
                    mac-address 64:66:b3:b0:e1:0a
                }
            }
        }
        use-dnsmasq disable
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
    host-name rt0-cowshed
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
    name-server 185.19.148.98
    name-server 185.61.112.98
    ntp {
        server 185.61.112.97 {
        }
    }
    offload {
        hwnat disable
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
    traffic-analysis {
        dpi disable
        export disable
    }
}
