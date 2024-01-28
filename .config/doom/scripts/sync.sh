#!/bin/bash

# customize these
WGET="/usr/bin/wget"
ICS2ORG="/home/iivanovw7/.config/doom/scripts/ical2org.awk"
ICSFILE="/home/iivanovw7/Documents/org/Agenda/calendar.ics"
ORGFILE="/home/iivanovw7/Documents/org/Agenda/calendar.org"
URL=""

$WGET -O $ICSFILE $URL
$ICS2ORG < $ICSFILE > $ORGFILE
