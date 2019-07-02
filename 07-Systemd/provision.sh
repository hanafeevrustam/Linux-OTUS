sudo yum install epel-release -y && sudo yum install spawn-fcgi php php-cli mod_fcgid httpd vim -y

cat >> /etc/sysconfig/watchlog << EOF
# Configuration file for my watchdog service
# Place it to /etc/sysconfig
# File and word in that file that we will be monit
WORD="ALERT"
LOG=/var/log/watchlog.log
EOF

touch /var/log/watchlog.log

cat >>  /opt/watchlog.sh  << EOF
#!/bin/bash

WORD=$1
LOG=$2
DATE=`date`

if grep $WORD $LOG &> /dev/null
then
    logger "$DATE: I found word, Master!"
else
    exit 0
fi
EOF
chmod +x /opt/watchlog.sh



cat >> /etc/systemd/system/watchlog.service << EOF
[Unit]
Description=My watchlog service
[Service]
Type=oneshot
EnvironmentFile=/etc/sysconfig/watchdog
ExecStart=/opt/watchlog.sh $WORD $LOG
EOF

cat >> /etc/systemd/system/watchlog.timer << EOF
[Unit]
Description=Run watchlog script every 30 second
[Timer]
# Run every 30 second
OnUnitActiveSec=30
Unit=watchlog.service
[Install]
WantedBy=multi-user.target
EOF



#######
#2-nd task
#############


sed -i 's/#SOCKET/SOCKET/' /etc/sysconfig/spawn-fcgi
sed -i 's/#OPTIONS/OPTIONS/' /etc/sysconfig/spawn-fcgi

cat >> /etc/sysconfig/spawn-fcgi.service << EOF
[Unit]
Description=Spawn-fcgi startup service by Otus
After=network.target
[Service]
Type=simple
PIDFile=/var/run/spawn-fcgi.pid
EnvironmentFile=/etc/sysconfig/spawn-fcgi
ExecStart=/usr/bin/spawn-fcgi -n $OPTIONS
KillMode=process
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload

systemctl enabled watchlog.timer
systemctl start watchlog.timer

systemctl enabled spawn-fcgi
systemctl start spawn-fcgi
#systemctl status spawn-fcgi
############
#3-rd task
#############


cat >> /etc/systemd/system/httpd@.service  << EOF
[Unit]
Description=The Apache HTTP Server
After=network.target remote-fs.target nss-lookup.target
Documentation=man:httpd(8)
Documentation=man:apachectl(8)

[Service]
Type=notify
EnvironmentFile=/etc/sysconfig/httpd-config-%I
ExecStart=/usr/sbin/httpd $OPTIONS -DFOREGROUND
ExecReload=/usr/sbin/httpd $OPTIONS -k graceful
ExecStop=/bin/kill -WINCH ${MAINPID}
KillSignal=SIGCONT
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF


cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd-1.conf
sed  -i 's/Listen 80/Listen 8080/' /etc/httpd/conf/httpd-1.conf
sed -i 's/"logs\/error_log"/"logs\/error_log-1"/' /etc/httpd/conf/httpd-1.conf
sed -i 's/"logs\/access_log"/"logs\/access_log-1"/' /etc/httpd/conf/httpd-1.conf
cp /etc/sysconfig/httpd /etc/sysconfig/httpd-config-1
sed -i 's/#OPTIONS=/OPTIONS=-f \/etc\/httpd\/conf\/httpd-1.conf/' /etc/sysconfig/httpd-config-1



systemctl disable httpd
systemctl daemon-reload 

systemctl enable --now httpd@1
#systemctl start httpd@2.service