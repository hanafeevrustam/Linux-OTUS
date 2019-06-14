yum groupinstall -y "Development Tools" && yum -y install createrepo rpmdevtools yum-utils wget epel-release vim redhat-lsb openssl-devel zlib-devel pcre-devel

wget https://www.openssl.org/source/latest.tar.gz
tar -xzvf latest.tar.gz


rpm -ivh https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm

wget https://gist.github.com/lalbrekht/6c4a989758fccf903729fc55531d3a50/archive/8104e513dd9403a4d7b5f1393996b728f8733dd4.zip
unzip 8104e513dd9403a4d7b5f1393996b728f8733dd4.zip
cat 6c4a989758fccf903729fc55531d3a50-8104e513dd9403a4d7b5f1393996b728f8733dd4/gistfile1.txt > /root/rpmbuild/SPECS/nginx.spec

sed -i 's?--with-openssl=/root/openssl-1.1.1a?--with-openssl=/home/vagrant/openssl-1.1.1c?g' /root/rpmbuild/SPECS/nginx.spec

rpmbuild -ba /root/rpmbuild/SPECS/nginx.spec
#!Check path and name
rpm -Uvh /root/rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm


mkdir -p /usr/share/nginx/html/repo

cp /root/rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm /usr/share/nginx/html/repo/

wget http://www.percona.com/downloads/percona-release/redhat/0.1-6/percona-release-0.1-6.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm

createrepo /usr/share/nginx/html/repo/

sed '/index.htm;/i autoindex on; ' /etc/nginx/conf.d/default.conf > /tmp/nginx.conf 
cat /tmp/nginx.conf > /etc/nginx/conf.d/default.conf

nginx -t
nginx -s reload


cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF

yum repolist enabled | grep otus