#!/bin/bash
cd /home/py
source /home/py/.profile
echo `date` >> monitor.log
ps aux |grep /data/deploy/LoopChannels/current/bin/www |awk '$3>10 {printf("%.f\n",$3)}'| while read memnum; do something $memnum >> monitor.log;done