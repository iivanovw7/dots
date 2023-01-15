#!/bin/sh

top -b -n 10 -d.2 | grep 'Cpu' |  awk 'NR==3{ print($2)" % " }'