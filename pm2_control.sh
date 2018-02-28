#!/bin/bash
source /home/py/.profile
source /home/py/.bashrc
source /home/py/.bash_togic
export HOME=/home/py
case $1 in
        start)
                PORT=30031 /usr/local/bin/pm2 start -x -f --node-args='--harmony' /data/deploy/MediaTube/current/app.js -n mediatube
                PORT=30032 /usr/local/bin/pm2 start -x -f --node-args='--harmony' /data/deploy/MediaTube/current/app.js -n mediatube
                PORT=30033 /usr/local/bin/pm2 start -x -f --node-args='--harmony' /data/deploy/MediaTube/current/app.js -n mediatube
                PORT=30034 /usr/local/bin/pm2 start -x -f --node-args='--harmony' /data/deploy/MediaTube/current/app.js -n mediatube
                #PORT=3003 /usr/local/bin/pm2 start -x -f --node-args='--harmony' /data/deploy/MediaTube/current/app.js -n mediatube
                ;;
        stop)
                /usr/local/bin/pm2 stop mediatube
                /usr/local/bin/pm2 delete mediatube
                ;;
        restart|force-reload)
                /usr/local/bin/pm2 restart mediatube
                ;;
        status)
                ;;
        *)
                echo "Usage: $0 {start|stop|restart|force-reload|status}"
                exit 2
                ;;

esac
