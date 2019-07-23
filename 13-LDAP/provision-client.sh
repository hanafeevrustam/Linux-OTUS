echo "qqq" >> /home/vagrant/qqq
sudo yum -y install freeipa-client ipa-admintools telnet

sudo echo 'nameserver 192.168.11.150' >> /etc/resolv.conf
sudo echo '127.0.1.1    client.example.test client' >> /etc/hosts

sudo ipa-client-install --mkhomedir --force-ntpd