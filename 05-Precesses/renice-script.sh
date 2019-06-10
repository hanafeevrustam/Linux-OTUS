#!/usr/bin/env bash; 


fpp=$( yes > /dev/null & echo $!) ;  spp=$( yes > /dev/null & echo $!) ;  
renice -n -19 -p $fpp ; renice -n -19 -p $spp
x=1
while [ $x -le 5 ]
do
    date >> /tmp/renice.log
    ps -eo pid,nice,%cpu,command | grep yes | head -n 2 >> /tmp/renice.log
    x=$(( $x + 1 ))
    sleep 10
done