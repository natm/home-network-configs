! Image stamp:    /sw/code/build/harp(harp)
!                 Feb  6 2007 13:34:59
!                 Q.10.05
!                 554
! 
!  Status and Counters - General System Information
! 
!   System Name        : sw0.cowshed                                     
!   System Contact     :                                                 
!   System Location    :                                                 
! 
!   MAC Age Time (sec) : 300    
! 
!   Time Zone          : 0    
!   Daylight Time Rule : None                      
! 
! 
!   Software revision  : Q.10.05          Base MAC Addr      : 0018fe-57dfe0
!   ROM Version        : Q.10.02          Serial Number      : CN640WX0JE  

Running configuration:

; J9019A Configuration Editor; Created on release #Q.10.05

hostname "sw0.cowshed" 
interface 1 
   name "atlas1.cowshed" 
exit
interface 2 
   name "pdu0.cowshed" 
exit
interface 3 
   name "ups0.cowshed" 
exit
interface 4 
   name "ap0.cowshed" 
exit
interface 5 
   name "vdsl1-mgmt" 
exit
interface 6 
   name "vdsl2-mgmt" 
exit
interface 14 
   name "Cust: Les and Ann Morris" 
exit
ip default-gateway 185.19.148.113 
sntp server 185.61.112.97 
timesync sntp 
sntp unicast 
logging 185.61.112.99 
snmp-server community <configuration removed>
vlan 1 
   name "DEFAULT_VLAN" 
   untagged 1-13,15-26 
   ip address 185.19.148.114 255.255.255.240 
   no untagged 14 
   exit 
vlan 128 
   name "les-morris" 
   untagged 14 
   no ip address 
   tagged 26 
   exit 
ip authorized-managers 185.61.112.0 255.255.252.0 
ip authorized-managers 185.19.148.0 255.255.255.0 
ip ssh
password manager
password operator
