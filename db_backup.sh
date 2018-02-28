#!/bin/bash
cd /mnt/bak
X=`date +%Y%m%d`
D=`date -d "7 days ago" +"%Y%m%d%H%M"`
BAK_DIR=/mnt/bak
if [ -d $BAK_DIR ];then
     echo "The directory is existed!Now backup the database!"
     else echo "create the directory!"
              mkdir -p $BAK_DIR
fi
if [ -s $BAK_DIR/mediatube_$X ];then
        echo "The bakfile is existed!EXIT!"
        exit 0
   else
  /home/py/tools/mongodb-3.2.1/bin/mongodump --host host --port port  --authenticationDatabase=admin -u username -p 'password' -d dbname -o $BAK_DIR/mediatube_$X 
   tar -zcvf mediatube_$X.tar.gz $BAK_DIR/mediatube_$X/mediatube/ && rm -r $BAK_DIR/mediatube_$X
   echo "Backup is finished!"
fi
