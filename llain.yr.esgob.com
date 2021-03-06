firewall {
    all-ping enable
    broadcast-ping disable
    group {
        address-group cctv {
            address 185.19.150.198
        }
        network-group trusted {
            description ""
            network 195.177.252.0/23
            network 185.61.112.0/23
            network 82.69.41.80/31
            network 185.19.150.0/24
        }
        port-group nvr_ports {
            description ""
            port 80
            port 554
            port 8000
            port 9010
            port 9020
        }
    }
    ipv6-name 6_internet_in {
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
            protocol icmpv6
        }
    }
    ipv6-name 6_internet_local {
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
            protocol icmpv6
        }
    }
    ipv6-receive-redirects disable
    ipv6-src-route disable
    ip-src-route disable
    log-martians enable
    modify internet_modify_out {
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
    name internet_in {
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
            description "cctv access"
            destination {
                group {
                    address-group cctv
                    port-group nvr_ports
                }
            }
            log disable
            protocol all
            state {
                established disable
                invalid disable
                new enable
                related disable
            }
        }
        rule 4 {
            action accept
            description "ssh from trusted"
            destination {
                port ssh
            }
            log disable
            protocol tcp
            source {
                group {
                    network-group trusted
                }
            }
        }
    }
    name internet_local {
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
            description "mgmt web ui"
            destination {
                group {
                }
                port 443
            }
            log disable
            protocol tcp
            source {
                group {
                    network-group trusted
                }
            }
        }
        rule 4 {
            action accept
            description "mgmt ssh"
            destination {
                port 22
            }
            log disable
            protocol tcp
            source {
                group {
                    network-group trusted
                }
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
        address 192.168.0.1/24
        description house
        duplex auto
        ipv6 {
            dup-addr-detect-transmits 1
        }
        speed auto
    }
    ethernet eth1 {
        description fttc
        duplex auto
        pppoe 0 {
            default-route auto
            firewall {
                in {
                    ipv6-name 6_internet_in
                    name internet_in
                }
                local {
                    ipv6-name 6_internet_local
                    name internet_local
                }
                out {
                    modify internet_modify_out
                }
            }
            ipv6 {
                dup-addr-detect-transmits 1
                enable {
                }
            }
            mtu 1492
            name-server auto
            password ****************
            user-id gb12@a
        }
        speed auto
    }
    ethernet eth2 {
        description wireless
        duplex auto
        speed auto
    }
    loopback lo {
    }
}
protocols {
    static {
        interface-route6 ::/0 {
            next-hop-interface pppoe0 {
            }
        }
    }
}
service {
    dhcp-server {
        disabled false
        hostfile-update disable
        shared-network-name housetemp {
            authoritative disable
            subnet 192.168.0.0/24 {
                default-router 192.168.0.1
                dns-server 8.8.8.8
                dns-server 8.8.4.4
                lease 86400
                start 192.168.0.100 {
                    stop 192.168.0.200
                }
            }
        }
    }
    gui {
        https-port 443
    }
    nat {
        rule 5000 {
            description "nat via aaisp"
            log disable
            outbound-interface pppoe0
            protocol all
            type masquerade
        }
        rule 5001 {
            description "nat via wireless"
            log disable
            outbound-interface eth2
            protocol all
            type masquerade
        }
    }
    ssh {
        port 22
        protocol-version v2
    }
}
system {
    domain-name llain.yr.esgob.com
    host-name llainyresgob
    login {
        user nat {
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
    name-server 8.8.8.8
    ntp {
        server 0.ubnt.pool.ntp.org {
        }
        server 1.ubnt.pool.ntp.org {
        }
        server 2.ubnt.pool.ntp.org {
        }
        server 3.ubnt.pool.ntp.org {
        }
    }
    offload {
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
    }
    time-zone UTC
    traffic-analysis {
        dpi disable
        export disable
    }
}
