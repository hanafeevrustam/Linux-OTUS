# Linux-OTUS
1)Download the project 
2) Change current directory to project directory 
3) Scrip needs in inventory file (ex: /etc/ansible/inventory/hosts) 
4) Run command: sudo ansible-playbook upgrade.yml -u root -k


cat /etc/ansible/hosts 
[centos7]
gce ansible_host=35.196.194.209 ansible_user=redbull05689 ansible_private_key_file=/home/redbull05689/.ssh/id_rsa


