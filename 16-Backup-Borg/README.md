Настраиваем бэкапы
Настроить стенд Vagrant с двумя виртуальными машинами server и client.

Настроить политику бэкапа директории /etc с клиента:
1) Полный бэкап - раз в день
2) Инкрементальный - каждые 10 минут
3) Дифференциальный - каждые 30 минут

Запустить систему на два часа. Для сдачи ДЗ приложить list jobs, list files jobid=<id>
и сами конфиги bacula-*

* Настроить доп. Опции - сжатие, шифрование, дедупликация

Для запуска проекта необходимо заустить: vagrant up && sudo ansible-playbook playbook-server.yml -i inventory.yml && sudo ansible-playbook playbook-client.yml -i inventory.yml

Отличная статья по теме:
https://habr.com/ru/company/flant/blog/420055/
https://community.hetzner.com/tutorials/install-and-configure-borgbackup?title=BorgBackup/en


https://github.com/yurihs/ansible-role-borg-client
https://github.com/yurihs/ansible-role-borg-server