#!/usr/bin/env bash
#
# Simple Firewall-Script with iptables
# only IPv4
#
# (c) by Wutze 2006-18 Version 3.0
#
# This file is copyright under the latest version of the EUPL.
# Please see LICENSE file for your rights under this license.
# Version 1.x
#
# Twitter -> @HuWutze
#

## Zwingend einzutragen
## Eintrag sollte unique sein!
rulename="KIDS"

## nicht verändern
## Diese beiden Zeilen erzeugen ein Array, welches in der "ende.sh" eingelesen und
## und entsprechend verarbeitet wird.
count=$(( $count + 1 ))
forwardrule[$count]="$rulename"
## Container"$rulename" definieren
$FW -N $rulename
########################################################
## Angabe ob das Regelset für ein Netzwerk zuständig sein soll oder nur für einen Host
## Wird diese Variable nicht gesetzt oder ist nicht vorhanden, wird das Script
## zwar ordentlich funktionieren, das Logging aber wird nicht korrekt angezeigt,
## da die Firewall sonst nicht nach den einzelnen Netzwerken unterscheiden kann
## Zudem wird "current_object_s" für das definieren der Rückrouten benötigt,
## damit der Router weiß, wohin die Antwortpakete gesendet werden dürfen.
## "current_object_d" kann jedoch leer bleiben.
######
## Source Host or Net
current_object_s[$count]="10.10.10.0/24"
## Destination Host or Net
current_object_d[$count]="0.0.0.0/0"
########################################################

#$FW -A $rulename -o $DEV_LAN1 -i $DEV_DMZ1 -j ACCEPT            ## -> DMZ

$FW -A $rulename -i $DEV_LAN1 -o $DEV_EXTERN -s 10.10.10.61 -p tcp -m multiport --dport 80,443 -j ACCEPT            ## HTTP/S
$FW -A $rulename -i $DEV_LAN1 -o $DEV_INTERN -s 10.10.10.61 -p udp -m multiport --dport 53 -j ACCEPT            ## DNS UDP
$FW -A $rulename -i $DEV_LAN1 -o $DEV_INTERN -s 10.10.10.61 -p tcp -m multiport --dport 53 -j ACCEPT            ## DNS TCP
$FW -A $rulename -i $DEV_LAN1 -o $DEV_INTERN -s 10.10.10.61 -p ICMP -j ACCEPT            ## ICMP

$FW -A $rulename -i $DEV_LAN1 -o $DEV_DMZ1 -s 10.10.10.61 -p tcp -m multiport --dport 80,443 -j ACCEPT            ## HTTP/S

$FW -A $rulename -i $DEV_LAN1 -o $DEV_EXTERN -s 10.10.10.50 -j ACCEPT		## PC1
$FW -A $rulename -i $DEV_LAN1 -o $DEV_INTERN -s 10.10.10.50 -d $DNS_INTERN1 -j ACCEPT		## PC1
$FW -A $rulename -i $DEV_LAN1 -o $DEV_DMZ1 -s 10.10.10.50 -j ACCEPT		## PC1

$FW -A $rulename -i $DEV_LAN1 -o $DEV_EXTERN -s 10.10.10.52 -j ACCEPT		## PS4
$FW -A $rulename -i $DEV_LAN1 -o $DEV_INTERN -s 10.10.10.52 -d $DNS_INTERN1 -j ACCEPT		## PS4
$FW -A $rulename -i $DEV_LAN1 -o $DEV_DMZ1 -s 10.10.10.52 -j ACCEPT		## PS4

$FW -A $rulename -i $DEV_LAN1 -o $DEV_EXTERN -s 10.10.10.54 -j ACCEPT		## PC2
$FW -A $rulename -i $DEV_LAN1 -o $DEV_INTERN -s 10.10.10.54 -d $DNS_INTERN1 -j ACCEPT		## PC2
$FW -A $rulename -i $DEV_LAN1 -o $DEV_DMZ1 -s 10.10.10.54 -j ACCEPT		## PC2




########################################################
