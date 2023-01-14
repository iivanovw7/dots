#!/bin/sh

#Requires sysstat
mpstat | awk 'END{print $4"%"}'