Домашнее задание
PostgreSQL
- Настроить hot_standby репликацию с использованием слотов
- Настроить правильное резервное копирование

Для сдачи присылаем postgresql.conf, pg_hba.conf и recovery.conf
А так же конфиг barman, либо скрипт резервного копирования

Для запука стенда необходимо выполнить сл команды:
    sudo vagrant up && sudo ansible-playbook playbook.yml -i inventory.yml

Проверить репликацию можно сл способом:
    На мастере запустить:
[vagrant@pgmaster ~]$ ps auwx | grep sender
postgres  7936  0.0  0.1 297048  3288 ?        Ss   15:40   0:00 postgres: walsender replication 192.168.111.40(50416) streaming 0/3000140
vagrant  27341  0.0  0.0  12520   980 pts/0    R+   17:13   0:00 grep --color=auto sender

    На слейве запустить:
[vagrant@pgslave ~]$ ps auwx | grep receiver
postgres  7769  0.1  0.1 303316  3640 ?        Rs   15:40   0:06 postgres: walreceiver   streaming 0/3000140
vagrant  26729  0.0  0.0  12520   984 pts/0    S+   17:03   0:00 grep --color=auto receiver

    Также необходимо проверить наличие среплицированной базы на слейве:
[vagrant@pgslave ~]$ sudo -s
[root@pgslave vagrant]# su postgres
bash-4.2$ psql -l
could not change directory to "/home/vagrant": Permission denied
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges
-----------+----------+----------+-------------+-------------+-----------------------
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 test      | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
(4 rows)














https://www.digitalocean.com/community/tutorials/how-to-back-up-restore-and-migrate-postgresql-databases-with-barman-on-centos-7

https://github.com/Cepxio/PgBarman-Tutorial-Series/blob/master/documents/Part1_BarmanViaRsyncSSH.md

https://www.youtube.com/watch?v=03wNXENAbIk&list=PLaFqU3KCWw6JhHBp07QSu9uE8zahhKnTn&index=19

http://docs.pgbarman.org/release/2.9/#wal-archiving-via-archive_command