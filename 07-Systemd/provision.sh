sudo yum install epel-release -y && sudo yum install spawn-fcgi php php-cli mod_fcgid httpd vim -y


sudo cp /home/vagrant/watchlog /etc/sysconfig/
sudo cp /home/vagrant/watchlog.log /var/log/
sudo cp /home/vagrant/watchlog.sh /opt/
sudo cp /home/vagrant/watchlog.service /etc/systemd/system/
sudo cp /home/vagrant/watchlog.timer /etc/systemd/system/

sudo chmod +x /opt/watchlog.sh


sudo systemctl daemon-reload
sudo systemctl enable watchlog.timer
sudo systemctl enable watchlog.service
sudo systemctl start watchlog.timer
sudo systemctl start watchlog.service

#######
#2-nd task
#############


sudo sed -i 's/#SOCKET/SOCKET/' /etc/sysconfig/spawn-fcgi
sudo sed -i 's/#OPTIONS/OPTIONS/' /etc/sysconfig/spawn-fcgi

sudo cp /home/vagrant/spawn-fcgi.service /etc/systemd/system/spawn-fcgi.service

sudo systemctl daemon-reload

sudo systemctl enabled spawn-fcgi
sudo systemctl start spawn-fcgi
#systemctl status spawn-fcgi
############
#3-rd task
#############


sudo cat >> /etc/systemd/system/httpd@.service  << EOF
[Unit]
Description=The Apache HTTP Server
After=network.target remote-fs.target nss-lookup.target
Documentation=man:httpd(8)
Documentation=man:apachectl(8)

[Service]
Type=notify
EnvironmentFile=/etc/sysconfig/httpd-config-%I
ExecStart=/usr/sbin/httpd \$OPTIONS -DFOREGROUND
ExecReload=/usr/sbin/httpd \$OPTIONS -k graceful
ExecStop=/bin/kill -WINCH \${MAINPID}
KillSignal=SIGCONT
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF


sudo cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd-1.conf
sudo sed  -i 's/Listen 80/Listen 8080/' /etc/httpd/conf/httpd-1.conf
sudo sed -i 's/"logs\/error_log"/"logs\/error_log-1"/' /etc/httpd/conf/httpd-1.conf
sudo sed -i 's/"logs\/access_log"/"logs\/access_log-1"/' /etc/httpd/conf/httpd-1.conf
sudo cp /etc/sysconfig/httpd /etc/sysconfig/httpd-config-1
sudo sed -i 's/#OPTIONS=/OPTIONS=-f \/etc\/httpd\/conf\/httpd-1.conf/' /etc/sysconfig/httpd-config-1



sudo systemctl disable httpd
sudo systemctl daemon-reload 


sudo systemctl enable --now httpd@1
systemctl start httpd@1.service