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

Проверить работу бэкапов можно командами:
[root@barman vagrant]# barman check pgmaster
Server pgmaster:
        empty incoming directory: FAILED ('/var/lib/barman/pgmaster/incoming' must be empty when archiver=off)
        PostgreSQL: OK
        is_superuser: OK
        PostgreSQL streaming: OK
        wal_level: OK
        replication slot: OK
        directories: OK
        retention policy settings: OK
        backup maximum age: OK (no last_backup_maximum_age provided)
        compression settings: OK
        failed backups: OK (there are 0 failed backups)
        minimum redundancy requirements: OK (have 0 backups, expected at least 0)
        pg_basebackup: OK
        pg_basebackup compatible: OK
        pg_basebackup supports tablespaces mapping: OK
        pg_receivexlog: OK
        pg_receivexlog compatible: OK
        receive-wal running: OK
        archiver errors: OK
[root@barman vagrant]# barman backup pgmaster
Starting backup using postgres method for server pgmaster in /var/lib/barman/pgmaster/base/20190921T075822
Backup start at LSN: 0/4000140 (000000010000000000000004, 00000140)
Starting backup copy via pg_basebackup for 20190921T075822
Copy done (time: 6 seconds)
Finalising the backup.
This is the first backup for server pgmaster
WAL segments preceding the current backup have been found:
        000000010000000000000003 from server pgmaster has been removed
Backup size: 30.0 MiB
Backup end at LSN: 0/6000060 (000000010000000000000006, 00000060)
Backup completed (start time: 2019-09-21 07:58:22.228834, elapsed time: 6 seconds)
Processing xlog segments from streaming for pgmaster
        000000010000000000000004
        000000010000000000000005

Примечание: Обязательное условие работы Бармана это возсожность подключиться по ssh с мастер-сервер на барман-сервер 
pgmaster]$ su postgres
ssh barman@barman


Полезные статьи по данной теме:

https://www.digitalocean.com/community/tutorials/how-to-back-up-restore-and-migrate-postgresql-databases-with-barman-on-centos-7

https://github.com/Cepxio/PgBarman-Tutorial-Series/blob/master/documents/Part1_BarmanViaRsyncSSH.md

https://www.youtube.com/watch?v=03wNXENAbIk&list=PLaFqU3KCWw6JhHBp07QSu9uE8zahhKnTn&index=19

http://docs.pgbarman.org/release/2.9/#wal-archiving-via-archive_command

http://qaru.site/questions/16088747/postgresql-how-to-take-incremental-backup-with-barman

https://medium.com/@deepakputhraya/postgresql-backup-and-recovery-with-barman-a41c81dd10fd

https://medium.com/@deepakputhraya/postgresql-backup-and-recovery-with-barman-a41c81dd10fd


Восстановить стенд: (vagrant snapshot restore barman bar) -and (vagrant snapshot restore pgslave pgs) -and (vagrant snapshot restore pgmaster pgm)