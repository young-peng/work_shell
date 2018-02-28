#!/bin/bash
cd /data/deploy/static/CloudMediaManager/public/metro/background
for f in *.gif; do
    filename=${f%.*}
    jpgfilename=$filename.jpg
    if [ ! -f "$jpgfilename" ]; then
        convert $f[0] $jpgfilename
        echo $jpgfilename
    fi
done
X=`date +%Y%m`
echo $X
cd /data/deploy/static/CloudMediaManager/public/metro/animate_background/$X
for f in *.gif; do
    filename=${f%.*}
    jpgfilename=$filename.jpg
    if [ ! -f "$jpgfilename" ]; then
        convert $f[0] $jpgfilename
        echo $jpgfilename
    fi
done