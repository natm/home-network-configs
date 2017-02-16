! Cisco IOS Software, C3750 Software (C3750-IPSERVICESK9-M), Version 12.2(55)SE10, RELEASE SOFTWARE (fc2)
! NAME: "1", DESCR: "WS-C3750G-24TS-1U"
! PID: WS-C3750G-24TS-S1U, VID: V02  , SN: FOC0941U2FW
! 
! NAME: "GigabitEthernet1/0/25", DESCR: "1000BaseLX SFP"
! PID: Unspecified       , VID:      , SN: FNS11360M46     
! 
! 
!
! Last configuration change at 16:01:58 UTC Thu Feb 16 2017 by nat
! NVRAM config last updated at 16:02:00 UTC Thu Feb 16 2017 by nat
!
version 12.2
no service pad
service timestamps debug uptime
service timestamps log uptime
service password-encryption
!
hostname sw1.gorras
!
boot-start-marker
boot-end-marker
!
!
<secret hidden>
<secret hidden>
<secret hidden>
!
!
no aaa new-model
switch 1 provision ws-c3750g-24ts-1u
system mtu routing 1500
ip routing
no ip domain-lookup
ip domain-name hw.esgob.com
!
!
ip multicast-routing distributed
ipv6 unicast-routing
!
!
crypto pki trustpoint TP-self-signed-3337938048
 enrollment selfsigned
 subject-name cn=IOS-Self-Signed-Certificate-3337938048
 revocation-check none
 rsakeypair TP-self-signed-3337938048
!
!
crypto pki certificate chain TP-self-signed-3337938048
 certificate self-signed 01
  3082024F 308201B8 A0030201 02020101 300D0609 2A864886 F70D0101 04050030 
  31312F30 2D060355 04031326 494F532D 53656C66 2D536967 6E65642D 43657274 
  69666963 6174652D 33333337 39333830 3438301E 170D3933 30333031 30303032 
  33335A17 0D323030 31303130 30303030 305A3031 312F302D 06035504 03132649 
  4F532D53 656C662D 5369676E 65642D43 65727469 66696361 74652D33 33333739 
  33383034 3830819F 300D0609 2A864886 F70D0101 01050003 818D0030 81890281 
  8100A27D 1F0BB623 CD038170 580F2573 A163CCE0 0DE5C9BE C05EA571 E3CADBA6 
  2CE42D9F 9AF6F4B5 C38DFCD3 1791FD57 339383BD 46545BCE B0DB6B36 06C1EF3A 
  49FC437F 755C8DF8 184D7FC1 6DC0034C DB5D7DD7 F60B3D28 E37A1C0F FAFCE585 
  40E75B6A 4E8C1AF9 1BEF0E82 34A8935C 607DD633 20C5EAAE D21DE7E5 F908B2C7 
  009F0203 010001A3 77307530 0F060355 1D130101 FF040530 030101FF 30220603 
  551D1104 1B301982 17737731 2E676F72 7261732E 68772E65 73676F62 2E636F6D 
  301F0603 551D2304 18301680 14E9AC21 3F22BE41 5D1A5649 198084A0 FAA9913E 
  01301D06 03551D0E 04160414 E9AC213F 22BE415D 1A564919 8084A0FA A9913E01 
  300D0609 2A864886 F70D0101 04050003 81810068 412AD15B D9C432CE 13AD81A2 
  D6C9CCA8 4452E4FB 0B69697B AE95B975 B343D1BD 3FA766B5 4900292B 148A2CB8 
  B256A828 B6096507 63A163AC 542DF402 07E1EA03 061A655A A871313B F0698FEF 
  46DFF7A6 FE93DED8 0DA3D01A A1761A43 31A88E7F D5615843 EC1C6613 94BE8F26 
  00064BD0 3A21FCBD 389EA7A6 6D20E595 BC0879
  quit
!
!
!
spanning-tree mode pvst
spanning-tree extend system-id
!
vlan internal allocation policy ascending
lldp run
!
ip ssh version 2
!
!
!
interface Loopback0
 ip address 185.61.112.65 255.255.255.255
 ipv6 address 2A04:EBC0:766:1::65/128
 ipv6 ospf 1 area 0
!
interface GigabitEthernet1/0/1
 description to-rt2-at-pole
 switchport trunk encapsulation dot1q
 switchport trunk native vlan 29
 switchport trunk allowed vlan 29
 switchport mode trunk
!
interface GigabitEthernet1/0/2
!
interface GigabitEthernet1/0/3
 description gigabyte-brix-svc1
 switchport access vlan 21
 switchport mode access
 spanning-tree portfast
!
interface GigabitEthernet1/0/4
 description homewlc1-port1
 switchport trunk encapsulation dot1q
 switchport trunk native vlan 20
 switchport trunk allowed vlan 8-10,14,20
 switchport mode trunk
!
interface GigabitEthernet1/0/5
 description to-housesw1
 switchport trunk encapsulation dot1q
 switchport trunk native vlan 41
 switchport trunk allowed vlan 41,42,60-69
 switchport mode trunk
!
interface GigabitEthernet1/0/6
!
interface GigabitEthernet1/0/7
 description to-barn-1-copper
 switchport trunk encapsulation dot1q
 switchport trunk native vlan 9
 switchport trunk allowed vlan 9
 switchport mode trunk
!
interface GigabitEthernet1/0/8
 switchport access vlan 11
 switchport mode access
 spanning-tree portfast
!
interface GigabitEthernet1/0/9
 switchport access vlan 11
 switchport mode access
 spanning-tree portfast
!
interface GigabitEthernet1/0/10
 description proxmox1
 switchport access vlan 70
 switchport mode access
 speed 1000
 spanning-tree portfast
!
interface GigabitEthernet1/0/11
 description proxmox1
 switchport access vlan 70
 switchport mode access
 spanning-tree portfast
!
interface GigabitEthernet1/0/12
 switchport access vlan 11
 switchport mode access
 spanning-tree portfast
!
interface GigabitEthernet1/0/13
 switchport access vlan 11
 switchport mode access
 spanning-tree portfast
!
interface GigabitEthernet1/0/14
 description ripe-atlas-probe
 switchport access vlan 11
 switchport mode access
 spanning-tree portfast
!
interface GigabitEthernet1/0/15
 switchport access vlan 11
 switchport mode access
 spanning-tree portfast
!
interface GigabitEthernet1/0/16
 switchport access vlan 11
 switchport mode access
 spanning-tree portfast
!
interface GigabitEthernet1/0/17
 switchport access vlan 11
 switchport mode access
 spanning-tree portfast
!
interface GigabitEthernet1/0/18
 description upsshed1
 switchport access vlan 11
 switchport mode access
 spanning-tree portfast
!
interface GigabitEthernet1/0/19
 description pirelay1
 switchport access vlan 11
 switchport mode access
 spanning-tree portfast
!
interface GigabitEthernet1/0/20
 description pdushed1
 switchport access vlan 11
 switchport mode access
 spanning-tree portfast
!
interface GigabitEthernet1/0/21
 switchport access vlan 11
 switchport mode access
 spanning-tree portfast
!
interface GigabitEthernet1/0/22
 switchport access vlan 11
 switchport mode access
 spanning-tree portfast
!
interface GigabitEthernet1/0/23
 switchport access vlan 11
 switchport mode access
 spanning-tree portfast
!
interface GigabitEthernet1/0/24
 switchport access vlan 11
 switchport mode access
 spanning-tree portfast
!
interface GigabitEthernet1/0/25
 description to-barn-1-fibre
 switchport trunk encapsulation dot1q
 switchport trunk native vlan 9
 switchport trunk allowed vlan 9
 switchport mode trunk
!
interface GigabitEthernet1/0/26
!
interface GigabitEthernet1/0/27
!
interface GigabitEthernet1/0/28
!
interface Vlan1
 no ip address
!
interface Vlan9
 description barn-workshop
 ip address 185.61.113.1 255.255.255.224
 ip helper-address 185.61.112.82
 ip pim sparse-dense-mode
 ipv6 address 2A04:EBC0:766:109::1/64
!
interface Vlan10
 description wificlients-guests
 ip address 185.61.112.193 255.255.255.192
 ip helper-address 185.61.112.82
 ip pim sparse-dense-mode
 ipv6 address 2A04:EBC0:766:114::1/64
!
interface Vlan11
 description shed-local
 ip address 185.61.112.145 255.255.255.240
 ip helper-address 185.61.112.82
 ip pim sparse-dense-mode
 ipv6 address 2A04:EBC0:766:111::1/64
!
interface Vlan14
 description wificlients-guests
 ip address 185.61.113.193 255.255.255.192
 ip helper-address 185.61.112.82
 ip pim sparse-dense-mode
 ipv6 address 2A04:EBC0:766:110::1/64
!
interface Vlan15
 description treehouse
 ip address 185.61.113.113 255.255.255.240
 ip helper-address 185.61.112.82
 ipv6 address 2A04:EBC0:766:115::1/64
!
interface Vlan18
 description logstore
 ip address 185.61.113.161 255.255.255.240
 ip helper-address 185.61.112.82
 ipv6 address 2A04:EBC0:766:118::1/64
!
interface Vlan19
 description greenhouse
 ip address 185.61.113.177 255.255.255.240
 ip helper-address 185.61.112.82
 ipv6 address 2A04:EBC0:766:119::1/64
!
interface Vlan20
 description homewlc1mgmt
 ip address 185.61.112.93 255.255.255.252
 ip pim sparse-dense-mode
 ipv6 address 2A04:EBC0:766:2:4::1/112
!
interface Vlan21
 description homesvc1
 ip address 185.61.112.81 255.255.255.252
 ipv6 address 2A04:EBC0:766:2:1::1/112
!
interface Vlan29
 description to-sw4-in-woods
 ip address 185.61.112.90 255.255.255.252
 ip ospf network point-to-point
 ipv6 address 2A04:EBC0:766:2:3::2/112
 ipv6 ospf 1 area 0
!
interface Vlan41
 description house-lounge
 ip address 185.61.112.161 255.255.255.240
 ip helper-address 185.61.112.82
 ip pim sparse-dense-mode
 ipv6 address 2A04:EBC0:766:112::1/64
!
interface Vlan42
 description house-office
 ip address 185.61.112.33 255.255.255.224
 ip helper-address 185.61.112.82
 ip pim sparse-dense-mode
 ipv6 address 2A04:EBC0:766:142::1/64
!
interface Vlan60
 description house-office-dev1
 ip address 185.61.113.69 255.255.255.252
 ip ospf network point-to-point
 ipv6 address 2A04:EBC0:766:2:22::1/112
!
interface Vlan70
 description proxmox1 linknet
 ip address 185.61.112.85 255.255.255.252
 ip ospf network point-to-point
 ipv6 address 2A04:EBC0:766:2:2::1/112
 ipv6 ospf 1 area 0
!
interface Vlan400
 description nat-test-15
 no ip address
!
interface Vlan991
 no ip address
!
router ospf 1
 router-id 185.61.112.65
 log-adjacency-changes
 network 185.61.112.65 0.0.0.0 area 0
 network 185.61.112.84 0.0.0.3 area 0
 network 185.61.112.88 0.0.0.3 area 0
!
router bgp 60036
 no bgp default ipv4-unicast
 bgp log-neighbor-changes
 neighbor ibgp-v4 peer-group
 neighbor ibgp-v4 remote-as 60036
 neighbor ibgp-v4 update-source Loopback0
 neighbor ibgp-v6 peer-group
 neighbor ibgp-v6 remote-as 60036
 neighbor ibgp-v6 update-source Loopback0
 neighbor 2A04:EBC0:748:1::1 peer-group ibgp-v6
 neighbor 2A04:EBC0:748:1::2 peer-group ibgp-v6
 neighbor 2A04:EBC0:749:1::1 peer-group ibgp-v6
 neighbor 2A04:EBC0:749:1::2 peer-group ibgp-v6
 neighbor 2A04:EBC0:749:1::3 peer-group ibgp-v6
 neighbor 2A04:EBC0:766:1::64 peer-group ibgp-v6
 neighbor 2A04:EBC0:766:1::66 peer-group ibgp-v6
 neighbor 2A04:EBC0:766:1::67 peer-group ibgp-v6
 neighbor 2A04:EBC0:766:1::68 peer-group ibgp-v6
 neighbor 2A04:EBC0:766:1::69 peer-group ibgp-v6
 neighbor 2A04:EBC0:766:1::70 peer-group ibgp-v6
 neighbor 2A04:EBC0:766:1::71 peer-group ibgp-v6
 neighbor 2A04:EBC0:766:1::72 peer-group ibgp-v6
 neighbor 2A04:EBC0:766:2:5::2 remote-as 60035
 neighbor 185.19.148.1 peer-group ibgp-v4
 neighbor 185.19.148.2 peer-group ibgp-v4
 neighbor 185.19.149.1 peer-group ibgp-v4
 neighbor 185.19.149.2 peer-group ibgp-v4
 neighbor 185.19.149.3 peer-group ibgp-v4
 neighbor 185.61.112.64 peer-group ibgp-v4
 neighbor 185.61.112.66 peer-group ibgp-v4
 neighbor 185.61.112.67 peer-group ibgp-v4
 neighbor 185.61.112.68 peer-group ibgp-v4
 neighbor 185.61.112.69 peer-group ibgp-v4
 neighbor 185.61.112.70 peer-group ibgp-v4
 neighbor 185.61.112.71 peer-group ibgp-v4
 neighbor 185.61.112.72 peer-group ibgp-v4
 neighbor 185.61.112.82 remote-as 65534
 neighbor 185.61.112.98 remote-as 60035
 !
 address-family ipv4
  redistribute static route-map rtbh-v4-map
  neighbor ibgp-v4 send-community
  neighbor ibgp-v4 next-hop-self
  neighbor ibgp-v4 maximum-prefix 1000
  neighbor 185.19.148.1 activate
  neighbor 185.19.148.2 activate
  neighbor 185.19.149.1 activate
  neighbor 185.19.149.2 activate
  neighbor 185.19.149.3 activate
  neighbor 185.61.112.64 activate
  neighbor 185.61.112.66 activate
  neighbor 185.61.112.67 activate
  neighbor 185.61.112.68 activate
  neighbor 185.61.112.69 activate
  neighbor 185.61.112.70 activate
  neighbor 185.61.112.71 activate
  neighbor 185.61.112.72 activate
  neighbor 185.61.112.82 activate
  neighbor 185.61.112.98 activate
  neighbor 185.61.112.98 route-map downstream-60035-in-v4-map in
  no auto-summary
  no synchronization
  network 185.61.112.1 mask 255.255.255.255 route-map originated-container-v4-map
  network 185.61.112.5 mask 255.255.255.255 route-map originated-container-v4-map
  network 185.61.112.32 mask 255.255.255.224 route-map originated-internal-v4-map
  network 185.61.112.80 mask 255.255.255.252 route-map originated-internal-v4-map
  network 185.61.112.84 mask 255.255.255.252 route-map originated-internal-v4-map
  network 185.61.112.92 mask 255.255.255.252 route-map originated-internal-v4-map
  network 185.61.112.144 mask 255.255.255.240 route-map originated-internal-v4-map
  network 185.61.112.160 mask 255.255.255.240 route-map originated-internal-v4-map
  network 185.61.112.192 mask 255.255.255.192 route-map originated-internal-v4-map
  network 185.61.113.0 mask 255.255.255.224 route-map originated-internal-v4-map
  network 185.61.113.112 mask 255.255.255.240 route-map originated-internal-v4-map
  network 185.61.113.160 mask 255.255.255.240 route-map originated-internal-v4-map
  network 185.61.113.176 mask 255.255.255.240 route-map originated-internal-v4-map
  network 185.61.113.192 mask 255.255.255.192 route-map originated-internal-v4-map
 exit-address-family
 !
 address-family ipv6
  neighbor ibgp-v6 send-community
  neighbor ibgp-v6 next-hop-self
  neighbor ibgp-v6 maximum-prefix 1000
  neighbor 2A04:EBC0:748:1::1 activate
  neighbor 2A04:EBC0:748:1::2 activate
  neighbor 2A04:EBC0:749:1::1 activate
  neighbor 2A04:EBC0:749:1::2 activate
  neighbor 2A04:EBC0:749:1::3 activate
  neighbor 2A04:EBC0:766:1::64 activate
  neighbor 2A04:EBC0:766:1::66 activate
  neighbor 2A04:EBC0:766:1::67 activate
  neighbor 2A04:EBC0:766:1::68 activate
  neighbor 2A04:EBC0:766:1::69 activate
  neighbor 2A04:EBC0:766:1::70 activate
  neighbor 2A04:EBC0:766:1::71 activate
  neighbor 2A04:EBC0:766:1::72 activate
  neighbor 2A04:EBC0:766:2:5::2 activate
  neighbor 2A04:EBC0:766:2:5::2 route-map downstream-60035-in-v6-map in
  network 2A04:EBC0:766:2:1::/112 route-map originated-internal-v6-map
  network 2A04:EBC0:766:2:2::/112 route-map originated-internal-v6-map
  network 2A04:EBC0:766:2:4::/112 route-map originated-internal-v6-map
  network 2A04:EBC0:766:109::/64 route-map originated-internal-v6-map
  network 2A04:EBC0:766:110::/64 route-map originated-internal-v6-map
  network 2A04:EBC0:766:111::/64 route-map originated-internal-v6-map
  network 2A04:EBC0:766:112::/64 route-map originated-internal-v6-map
  network 2A04:EBC0:766:114::/64 route-map originated-internal-v6-map
  network 2A04:EBC0:766:115::/64 route-map originated-internal-v6-map
  network 2A04:EBC0:766:118::/64 route-map originated-internal-v6-map
  network 2A04:EBC0:766:119::/64 route-map originated-internal-v6-map
  network 2A04:EBC0:766:142::/64 route-map originated-internal-v6-map
 exit-address-family
!
ip classless
ip route 185.61.112.20 255.255.255.255 192.0.2.1 tag 666
ip route 185.61.112.32 255.255.255.224 Null0
ip route 185.61.112.80 255.255.255.252 Null0
ip route 185.61.112.84 255.255.255.252 Null0
ip route 185.61.112.92 255.255.255.252 Null0
ip route 185.61.112.144 255.255.255.240 Null0
ip route 185.61.112.160 255.255.255.240 Null0
ip route 185.61.112.192 255.255.255.192 Null0
ip route 185.61.113.0 255.255.255.224 Null0
ip route 185.61.113.112 255.255.255.240 Null0
ip route 185.61.113.160 255.255.255.240 Null0
ip route 185.61.113.176 255.255.255.240 Null0
ip route 185.61.113.192 255.255.255.192 Null0
ip route 192.0.2.1 255.255.255.255 Null0
no ip http server
no ip http secure-server
!
ip bgp-community new-format
!
logging source-interface Loopback0
ipv6 route 2A04:EBC0:766:2:1::/112 Null0
ipv6 route 2A04:EBC0:766:2:2::/112 Null0
ipv6 route 2A04:EBC0:766:2:4::/112 Null0
ipv6 route 2A04:EBC0:766:109::/64 Null0
ipv6 route 2A04:EBC0:766:110::/64 Null0
ipv6 route 2A04:EBC0:766:111::/64 Null0
ipv6 route 2A04:EBC0:766:112::/64 Null0
ipv6 route 2A04:EBC0:766:114::/64 Null0
ipv6 route 2A04:EBC0:766:115::/64 Null0
ipv6 route 2A04:EBC0:766:118::/64 Null0
ipv6 route 2A04:EBC0:766:119::/64 Null0
ipv6 route 2A04:EBC0:766:142::/64 Null0
ipv6 router ospf 1
 router-id 185.61.112.65
 log-adjacency-changes
!
!
route-map downstream-60035-in-v6-map permit 10
 set community 60036:4003 60036:9000
!
route-map downstream-60035-in-v4-map permit 10
 set community 60036:4003 60036:9000
!
route-map originated-supernet-v4-map permit 10
 set community 60036:4003 60036:8000 60036:8001
!
route-map originated-supernet-v6-map permit 10
 set community 60036:4003 60036:8000 60036:8001
!
route-map originated-internal-v4-map permit 10
 set community 60036:4003 60036:8000 60036:8002
!
route-map originated-internal-v6-map permit 10
 set community 60036:4003 60036:8000 60036:8002
!
route-map rtbh-v4-map permit 10
 match tag 666
 set ip next-hop 192.0.2.1
 set community 60036:666 60036:4003
!
route-map transit-dragonwifi-v4-in-map permit 10
 set local-preference 150
!
route-map originated-container-v4-map permit 10
 set community 60036:4003 60036:8000 60036:8003
!
!
snmp-server community <configuration removed>
!
!
line con 0
 login local
 stopbits 1
line vty 0 4
 exec-timeout 6000 0
 login local
line vty 5 15
 login local
!
ntp source Loopback0
ntp server 185.61.112.98
ntp server 185.19.148.98
end

