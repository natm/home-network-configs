# NAME: "Chassis"    , DESCR: "Cisco 2500 Series Wireless LAN Controller"
# PID: AIR-CT2504-K9,  VID: V01,  SN: PSJ153500PR

# Primary Boot Image............................... 8.1.111.0 (default) (active)
# Backup Boot Image................................ 7.6.130.0

802.11a 11nSupport a-mpdu tx scheduler enable
802.11a 11nSupport a-mpdu tx scheduler timeout rt 10
802.11a 11nSupport mcs tx 8 disable
802.11a 11nSupport mcs tx 9 disable
802.11a beacon range 0
802.11a rx-sop threshold auto default
802.11a cca threshold 0 default
802.11a multicast buffer 0
802.11a multicast data-rate 0 default
802.11a cac video cac-method static
802.11a max-clients 200
802.11a rate disabled 6
802.11a rate disabled 9
802.11a rate disabled 12
802.11a rate disabled 18
802.11a cleanair enable network
802.11a dfs-peakdetect enable
802.11b 11nSupport a-mpdu tx scheduler enable
802.11b 11nSupport a-mpdu tx scheduler timeout rt 10
802.11b beacon range 0
802.11b rx-sop threshold auto default
802.11b cca threshold 0 default
802.11b multicast buffer 0
802.11b multicast data-rate 0 default
802.11b cac video cac-method static
802.11b max-clients 200
802.11b rate disabled 1
802.11b rate disabled 2
802.11b rate disabled 5.5
802.11b rate supported 11
802.11b rate disabled 6
802.11b rate disabled 9
802.11b rate mandatory 24
802.11b cleanair enable network
aaa auth mgmt  local radius
flexconnect fallback-radio-shut disable
connect fallback-radio-shut disable
advanced 802.11a channel dca interval 0
advanced 802.11a channel dca startup-interval 0
advanced 802.11a channel dca anchor-time 0
advanced 802.11a channel dca chan-width 20
advanced 802.11a channel dca sensitivity 15
advanced 802.11a channel dca min-metric -95
advanced 802.11a reporting neighbor 180
advanced 802.11a reporting interference 120
advanced 802.11b channel dca interval 0
advanced 802.11b channel dca startup-interval 0
advanced 802.11b channel dca anchor-time 0
advanced 802.11b channel dca sensitivity 10
advanced 802.11b channel dca min-metric -95
advanced 802.11b reporting neighbor 180
advanced 802.11b reporting interference 120
location info rogue extended
location rssi-half-life tags 0
location rssi-half-life client 0
location rssi-half-life rogue-aps 0
location expiry tags 5
location expiry client 5
location expiry calibrating-client 5
location expiry rogue-aps 5
advanced backup-controller primary
advanced backup-controller secondary
advanced backup-controller
advanced backup-controller
advanced sip-snooping-ports 0 0
advanced eap bcast-key-interval 3600
advanced 802.11-abgn pak-rssi-location threshold -100
advanced 802.11-abgn pak-rssi-location trigger-threshold 10
advanced 802.11-abgn pak-rssi-location reset-threshold 8
advanced 802.11-abgn pak-rssi-location timeout 3
advanced hotspot cmbk-delay 50
Cisco Public Safety is not allowed to set in this domain
ap syslog host global ::
ap dtls-cipher-suite RSA-AES128-SHA
ap dtls-wlc-mic sha2
cdp advertise-v2 enable
country GB
cts sxp disable
cts sxp connection default password ****
cts sxp retry period 120
cts sxp sxpversion 2
database size 2048
dhcp opt-82 remote-id ap-mac
qos qosmap disable
qos qosmap trust-dscp-upstream disable
local-auth method fast server-key ****
interface create dragonbackup 9
interface create wificlients-private 14
interface create wificlients-visitors 10
interface address dynamic-interface dragonbackup 192.168.9.9 255.255.255.0 192.168.9.1
interface address management 185.61.112.94 255.255.255.252 185.61.112.93
interface address virtual 185.61.112.78
interface address dynamic-interface wificlients-private 192.168.14.14 255.255.255.0 192.168.14.1
interface address dynamic-interface wificlients-visitors 192.168.10.10 255.255.255.0 192.168.10.1
interface dhcp  management primary 185.61.112.93
interface vlan dragonbackup 9
interface vlan wificlients-private 14
interface vlan wificlients-visitors 10
interface port dragonbackup 1
interface port management 1
interface port wificlients-private 1
interface port wificlients-visitors 1
mdns snooping enable
mdns policy service-group create "default-mdns-policy" "Default Access Policy created by WLC"
mdns policy service-group user-role add default-mdns-policy admin
mdns profile create "default-mdns-profile"
mdns service create "AirPort" _airport._tcp.local. origin All LSS disable query enable
mdns service create "AirPrint" _ipp._tcp.local. origin All LSS disable query enable
mdns service create "AirTunes" _raop._tcp.local. origin All LSS disable query enable
mdns service create "AppleTV" _airplay._tcp.local. origin All LSS disable query enable
mdns service create "HP_Photosmart_Printer_1" _universal._sub._ipp._tcp.local. origin All LSS disable query enable
mdns service create "HP_Photosmart_Printer_2" _cups._sub._ipp._tcp.local. origin All LSS disable query enable
mdns service create "Printer" _printer._tcp.local. origin All LSS disable query enable
mdns profile service add "default-mdns-profile" "AirPrint"
mdns profile service add "default-mdns-profile" "AirTunes"
mdns profile service add "default-mdns-profile" "AppleTV"
mdns profile service add "default-mdns-profile" "HP_Photosmart_Printer_1"
mdns profile service add "default-mdns-profile" "HP_Photosmart_Printer_2"
mdns profile service add "default-mdns-profile" "Printer"
mdns query interval 15
interface mdns-profile "management" "default-mdns-profile"
wlan mdns enable 1
wlan mdns enable 2
wlan mdns enable 4
wlan mdns profile 1 "default-mdns-profile"
wlan mdns profile 2 "default-mdns-profile"
wlan mdns profile 4 "default-mdns-profile"
ipv6 ra-guard ap disable
ipv6 capwap udplite enable all
ipv6 multicast mode multicast ::
rogue ap friendly add fa:8f:ca:68:41:a9
load-balancing aggressive enable
load-balancing window 5
wlan apgroup add default-group
wlan apgroup add main_house_apgroup
wlan apgroup qinq tagging eap-sim-aka default-group enable
wlan apgroup interface-mapping add default-group 1 wificlients-private
wlan apgroup interface-mapping add default-group 2 wificlients-visitors
wlan apgroup interface-mapping add default-group 4 dragonbackup
wlan apgroup nac-snmp disable default-group 1
wlan apgroup nac-snmp disable default-group 2
wlan apgroup nac-snmp disable default-group 4
logging syslog host 185.61.112.99
logging syslog level 2
memory monitor errors enable
memory monitor leak thresholds 10000 30000
Outdoor Mesh Ext.UNII B Domain channels: Disable
mesh security rad-mac-filter disable
mesh security rad-mac-filter disable
mesh security eap
mesh background-scanning disable
mesh backhaul rrm disable
mesh backhaul rrm auto-rf global
mesh lsc advanced ap-provision open-window enable
mgmtuser add admin **** read-write
mgmtuser add oxidized-prod **** read-write
mgmtuser add oxidized-test **** read-write
mgmtuser add waffle **** read-write
mobility group domain home
mobility dscp 0
network broadcast enable
network multicast global enable
network multicast igmp snooping enable
network multicast mld snooping enable
network multicast mode multicast 239.1.2.3
network mgmt-via-wireless enable
network ap-priority disabled
network rf-network-name home
network secureweb cipher-option rc4-preference disable
network client-ip-conflict-detection disable
paging disable
qos priority bronze background background background
qos priority gold video video video
qos priority platinum voice voice voice
qos priority silver besteffort besteffort besteffort
radius auth callStationIdType ap-macaddr-ssid
radius fallback-test mode off
radius fallback-test username cisco-probe
radius fallback-test interval 300
radius dns disable
radius dns auth network enable
radius dns auth management enable
radius dns acct network enable
radius dns auth rfc3576 disable
tacacs dns disable
rogue detection report-interval 10
rogue detection min-rssi -128
rogue detection transient-rogue-interval 0
rogue detection client-threshold 0
rogue detection security-level custom
rogue ap aaa-auth disable
rogue ap aaa-auth polling-interval 0
rogue ap classify friendly state external e8:94:f6:bf:d4:fa
rogue ap ssid alarm
rogue ap valid-client alarm
rogue adhoc enable
rogue adhoc alert
rogue ap rldp disable
rogue auto-contain level 1
rogue containment flex-connect disable
rogue containment auto-rate disableNot Supported.
snmp version v1 enable
snmp version v2c enable
snmp version v3 enable
snmp community create 9j9E1sre5CIa
snmp community accessmode ro 9j9E1sre5CIa
snmp snmpEngineId 0000376300004b800101fea9
snmp community ipsec ike auth-mode pre-shared-key ****
switchconfig strong-pwd case-check enabled
switchconfig strong-pwd consecutive-check enabled
switchconfig strong-pwd default-check enabled
switchconfig strong-pwd username-check enabled
switchconfig strong-pwd position-check disabled
switchconfig strong-pwd case-digit-check disabled
switchconfig strong-pwd minimum upper-case 0
switchconfig strong-pwd minimum lower-case 0
switchconfig strong-pwd minimum digits-chars 0
switchconfig strong-pwd minimum special-chars 0
switchconfig strong-pwd min-length 3
sysname homewlc1
stats-timer realtime 5
stats-timer normal 180
time ntp interval 3600
time ntp server 1 195.66.241.3
rf-profile create 802.11a High-Client-Density-802.11a
rf-profile create 802.11b High-Client-Density-802.11bg
rf-profile create 802.11a Low-Client-Density-802.11a
rf-profile create 802.11b Low-Client-Density-802.11bg
rf-profile create 802.11a Typical-Client-Density-802.11a
rf-profile create 802.11b Typical-Client-Density-802.11bg
rf-profile tx-power-min 7 High-Client-Density-802.11a
rf-profile tx-power-min 7 High-Client-Density-802.11bg
rf-profile tx-power-control-thresh-v1 -65 High-Client-Density-802.11a
rf-profile tx-power-control-thresh-v1 -60 Low-Client-Density-802.11a
rf-profile tx-power-control-thresh-v1 -65 Low-Client-Density-802.11bg
rf-profile data-rates 802.11a mandatory 6 High-Client-Density-802.11a
rf-profile data-rates 802.11a supported 9 High-Client-Density-802.11a
rf-profile data-rates 802.11a mandatory 12 High-Client-Density-802.11a
rf-profile data-rates 802.11a supported 18 High-Client-Density-802.11a
rf-profile data-rates 802.11a mandatory 24 High-Client-Density-802.11a
rf-profile data-rates 802.11a supported 36 High-Client-Density-802.11a
rf-profile data-rates 802.11a supported 48 High-Client-Density-802.11a
rf-profile data-rates 802.11a supported 54 High-Client-Density-802.11a
rf-profile data-rates 802.11b disabled 1 High-Client-Density-802.11bg
rf-profile data-rates 802.11b disabled 2 High-Client-Density-802.11bg
rf-profile data-rates 802.11b disabled 5.5 High-Client-Density-802.11bg
rf-profile data-rates 802.11b disabled 11 High-Client-Density-802.11bg
rf-profile data-rates 802.11b disabled 6 High-Client-Density-802.11bg
rf-profile data-rates 802.11b supported 9 High-Client-Density-802.11bg
rf-profile data-rates 802.11b mandatory 12 High-Client-Density-802.11bg
rf-profile data-rates 802.11b supported 18 High-Client-Density-802.11bg
rf-profile data-rates 802.11b supported 24 High-Client-Density-802.11bg
rf-profile data-rates 802.11b supported 36 High-Client-Density-802.11bg
rf-profile data-rates 802.11b supported 48 High-Client-Density-802.11bg
rf-profile data-rates 802.11a mandatory 6 Low-Client-Density-802.11a
rf-profile data-rates 802.11a supported 9 Low-Client-Density-802.11a
rf-profile data-rates 802.11a mandatory 12 Low-Client-Density-802.11a
rf-profile data-rates 802.11a supported 18 Low-Client-Density-802.11a
rf-profile data-rates 802.11a mandatory 24 Low-Client-Density-802.11a
rf-profile data-rates 802.11a supported 36 Low-Client-Density-802.11a
rf-profile data-rates 802.11a supported 48 Low-Client-Density-802.11a
rf-profile data-rates 802.11a supported 54 Low-Client-Density-802.11a
rf-profile data-rates 802.11b mandatory 1 Low-Client-Density-802.11bg
rf-profile data-rates 802.11b mandatory 2 Low-Client-Density-802.11bg
rf-profile data-rates 802.11b mandatory 5.5 Low-Client-Density-802.11bg
rf-profile data-rates 802.11b mandatory 11 Low-Client-Density-802.11bg
rf-profile data-rates 802.11b supported 6 Low-Client-Density-802.11bg
rf-profile data-rates 802.11b supported 9 Low-Client-Density-802.11bg
rf-profile data-rates 802.11b supported 12 Low-Client-Density-802.11bg
rf-profile data-rates 802.11b supported 18 Low-Client-Density-802.11bg
rf-profile data-rates 802.11b supported 24 Low-Client-Density-802.11bg
rf-profile data-rates 802.11b supported 36 Low-Client-Density-802.11bg
rf-profile data-rates 802.11b supported 48 Low-Client-Density-802.11bg
rf-profile data-rates 802.11a mandatory 6 Typical-Client-Density-802.11a
rf-profile data-rates 802.11a supported 9 Typical-Client-Density-802.11a
rf-profile data-rates 802.11a mandatory 12 Typical-Client-Density-802.11a
rf-profile data-rates 802.11a supported 18 Typical-Client-Density-802.11a
rf-profile data-rates 802.11a mandatory 24 Typical-Client-Density-802.11a
rf-profile data-rates 802.11a supported 36 Typical-Client-Density-802.11a
rf-profile data-rates 802.11a supported 48 Typical-Client-Density-802.11a
rf-profile data-rates 802.11a supported 54 Typical-Client-Density-802.11a
rf-profile data-rates 802.11b disabled 1 Typical-Client-Density-802.11bg
rf-profile data-rates 802.11b disabled 2 Typical-Client-Density-802.11bg
rf-profile data-rates 802.11b disabled 5.5 Typical-Client-Density-802.11bg
rf-profile data-rates 802.11b disabled 11 Typical-Client-Density-802.11bg
rf-profile data-rates 802.11b disabled 6 Typical-Client-Density-802.11bg
rf-profile data-rates 802.11b supported 9 Typical-Client-Density-802.11bg
rf-profile data-rates 802.11b mandatory 12 Typical-Client-Density-802.11bg
rf-profile data-rates 802.11b supported 18 Typical-Client-Density-802.11bg
rf-profile data-rates 802.11b supported 24 Typical-Client-Density-802.11bg
rf-profile data-rates 802.11b supported 36 Typical-Client-Density-802.11bg
rf-profile data-rates 802.11b supported 48 Typical-Client-Density-802.11bg
rf-profile rx-sop threshold medium High-Client-Density-802.11a
rf-profile rx-sop threshold medium High-Client-Density-802.11bg
rf-profile rx-sop threshold low Low-Client-Density-802.11a
rf-profile rx-sop threshold low Low-Client-Density-802.11bg
rf-profile coverage data -90 Low-Client-Density-802.11a
rf-profile coverage data -90 Low-Client-Density-802.11bg
rf-profile coverage voice -90 Low-Client-Density-802.11a
rf-profile coverage voice -90 Low-Client-Density-802.11bg
rf-profile coverage exception 2 Low-Client-Density-802.11a
rf-profile coverage exception 2 Low-Client-Density-802.11bg
trapflags client nac-alert enable
trapflags ap ssidKeyConflict disable
trapflags ap timeSyncFailure disable
trapflags mfp disable
trapflags adjchannel-rogueap disable
trapflags mesh excessive hop count disable
trapflags mesh sec backhaul change disable
wlan create 1 "llwyn y gorras" "Llwyn Y Gorras"
wlan create 2 "llwyn y gorras - guests" "Llwyn Y Gorras - Visitors"
wlan create 4 "llwyn y gorras - backup" "Llwyn Y Gorras - Backup"
wlan nac snmp disable 1
wlan nac snmp disable 2
wlan nac snmp disable 4
wlan nac radius disable 1
wlan nac radius disable 2
wlan nac radius disable 4
wlan interface 1 wificlients-private
wlan interface 2 wificlients-visitors
wlan interface 4 dragonbackup
wlan multicast interface 1 disable
wlan multicast interface 2 disable
wlan multicast interface 4 disable
wlan band-select allow enable 1
wlan band-select allow enable 2
wlan band-select allow enable 4
wlan load-balance allow disable 1
wlan load-balance allow disable 2
wlan load-balance allow disable 4
wlan bss-transition disassociation-imminent timer 200 1
wlan bss-transition disassociation-imminent timer 200 2
wlan bss-transition disassociation-imminent timer 200 4
wlan bss-transition disassociation-imminent oproam-timer 40 1
wlan bss-transition disassociation-imminent oproam-timer 40 2
wlan bss-transition disassociation-imminent oproam-timer 40 4
wlan multicast buffer disable 0 1
wlan multicast buffer disable 0 2
wlan multicast buffer disable 0 4
wlan session-timeout 1 disable
wlan session-timeout 2 1800
wlan session-timeout 4 disable
wlan flexconnect local-switching 1 disable
wlan flexconnect local-switching 2 disable
wlan flexconnect local-switching 4 disable
wlan flexconnect learn-ipaddr 1 enable
wlan flexconnect learn-ipaddr 2 enable
wlan flexconnect learn-ipaddr 4 enable
wlan security wpa disable 2
wlan security splash-page-web-redir disable 1
wlan security splash-page-web-redir disable 2
wlan security splash-page-web-redir disable 4
wlan user-idle-threshold 70 1
wlan user-idle-threshold 70 2
wlan user-idle-threshold 70 4
wlan security wpa akm psk enable 1
wlan security wpa akm psk enable 4
wlan security wpa akm cckm timestamp-tolerance  1000 1
wlan security wpa akm cckm timestamp-tolerance  1000 2
wlan security wpa akm cckm timestamp-tolerance  1000 4
wlan security ft over-the-ds disable 1
wlan security wpa gtk-random disable 1
wlan security wpa gtk-random disable 2
wlan security wpa gtk-random disable 4
wlan security pmf association-comeback 1 1
wlan security pmf association-comeback 1 2
wlan security pmf association-comeback 1 4
wlan security pmf saquery-retrytimeout 200 1
wlan security pmf saquery-retrytimeout 200 2
wlan security pmf saquery-retrytimeout 200 4
wlan profiling radius dhcp disable 1
wlan profiling radius http disable 1
wlan profiling radius dhcp disable 2
wlan profiling radius http disable 2
wlan profiling radius dhcp disable 4
wlan profiling radius http disable 4
wlan apgroup hotspot venue type main_house_apgroup 0 0
wlan enable 1
wlan enable 2
license boot base
WMM-AC disabled
coredump disable
media-stream multicast-direct disable
media-stream message url
media-stream message email
media-stream message phone
media-stream message note denial
media-stream message state disable
802.11a media-stream multicast-direct enable
802.11b media-stream multicast-direct enable
802.11a media-stream multicast-direct radio-maximum 0
802.11b media-stream multicast-direct radio-maximum 0
802.11a media-stream multicast-direct client-maximum 0
802.11b media-stream multicast-direct client-maximum 0
802.11a media-stream multicast-direct admission-besteffort disable
802.11b media-stream multicast-direct admission-besteffort disable
802.11a media-stream video-redirect enable
802.11b media-stream video-redirect enable
ipv6 neighbor-binding timers reachable-lifetime 300
ipv6 neighbor-binding timers stale-lifetime 86400
ipv6 neighbor-binding timers down-lifetime 30
ipv6 neighbor-binding ra-throttle disable
ipv6 neighbor-binding ra-throttle allow at-least 1 at-most 1
ipv6 neighbor-binding ra-throttle max-through 10
ipv6 neighbor-binding ra-throttle throttle-period 600
ipv6 neighbor-binding ra-throttle interval-option passthrough
ipv6 ns-mcast-fwd disable
ipv6 na-mcast-fwd enable
ipv6 enable
nmheartbeat disable
ipv6 interface address management primary 2a04:ebc0:766:2:4::2 112 fe80::215:c6ff:fef4:e4c7
Service Port Not Supported.
sys-nas Cisco_e0:4b:84
tunnel eogre heart-beat interval 60
tunnel eogre heart-beat primary-fallback-timeout 30
tunnel eogre heart-beat max-skip-count 3
---------- show tunnel eogre summary -------------------
Heartbeat Interval...............60
Max Heartbeat Skip Count.........3
Interface........................management
---------- show tunnel eogre gateway summary -----------
--------- show tunnel eogre domain summary -----------
Domain Name        Gateways           Active Gateway
--------------   -----------------   --------------------
---------- show tunnel profile summary ----------------
WLAN Express Setup - False
Flex Avc Profile Configuration
