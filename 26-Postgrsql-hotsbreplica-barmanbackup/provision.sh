touch qqq
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCW+VHI6di+7jZZhnYiCUciVO3oCSJ1xkV+8TINsNy1Itek0BUnorH+Mh6wC5eHoFVsid39v5A5ypzYZvJWhjwu4LNBJFroNhPnpmSBoA7Xk9U+slDI1A6pImop3qQbncMbYMdeyK5yoQO9bgJKDoQG7ak99qp24C4koFHGXO9Bejhenkkct2j0iTQreRyv2y3oSeOvsvQcBFuYS3H0FPhTUII8dx+/tjOTYFaxiA+EkWhuyXfhnrUd60BN5+ajqEgtv4CYZm2MBzDWu3Sor142Ms3R/FbwF1MJKd7JHOzJcTARfnpBqBZi+Or+l9+Pdl8yzxbxO0+9yaj7MGP9eyVT" >> /home/vagrant/.ssh/authorized_keys
cp /vagrant/id_rsa /home/vagrant/.ssh/
chown vagrant:vagrant /home/vagrant/.ssh/id_rsa 
chmod 0600 /home/vagrant/.ssh/id_rsa