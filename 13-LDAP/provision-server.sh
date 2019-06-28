cp -R /vagrant/freeipa-server/ /home/vagrant/

#yum install epel-release -y

sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo -y
sudo yum install docker-ce docker-ce-cli containerd.io -y
sudo yum install vim -y

sudo groupadd docker
sudo usermod -aG docker vagrant

sudo systemctl enable docker
sudo systemctl start docker

sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# sudo mkdir -p /opt/dockers/freeipa-data
# sudo cat > EOF /opt/dockers/freeipa-data/ipa-server-install-options
# --ds-password=The-directory-server-password
# --admin-password=The-admin-password
# EOF


docker-compose -f /home/vagrant/freeipa-server/docker-compose.yml up -d

# mkdir -p /opt/dockers/dnsmasq.d
# cat <<EOF >> /opt/dockers/dnsmasq.d/dnsmasq.conf
# address=/freeipa.example.test/10.12.0.172
# address=/server00.example.test/10.12.0.172
# address=/server01.example.test/10.12.0.173
# address=/server02.example.test/10.12.0.174
# EOF