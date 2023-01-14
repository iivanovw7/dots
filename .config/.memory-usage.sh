#!/bin/sh
meminfo=`free -m | grep 'Mem:'`

used=`echo $meminfo | cut -d" " -f3`
total=`echo $meminfo | cut -d" " -f2`

used_calc=`awk "BEGIN {print ($used / 1000)}"`
total_calc=`awk "BEGIN {print ($total / 1000)}"`

echo " RAM $used_calc/$total_calc G "