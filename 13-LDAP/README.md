Домашнее задание LDAP
Установить FreeIPA
Написать playbook для конфигурации клиента 3*. Настроить авторизацию по ssh-ключам
В git - результирующий playbook

Стенд с FreeIPA server и client:
разворачивается командой vagrant up && sudo ansible-playbook ansible-freeipa-master.yml -i inventory.yml && sudo ansible-playbook ansible-freeipa-client.yml -i inventory.yml
в результате FreeIPA server дсотупен  (admin:password)
на client устанавливается freeipa-client через playbook intall-ipa-client.yml, client добавляется в домен otus.test
для проверки работоспособности можно залогинится на client под пользователем admin:password, или залогнится на web FreeIPA, создать пользователя и под ним также поробовать залогинится на client.

Запустить можно сл командами:
    vagrant up && sudo ansible-playbook ansible-freeipa-master.yml -i inventory.yml && sudo ansible-playbook ansible-freeipa-client.yml -i inventory.yml



Полезные ссылки по теме:
https://www.8host.com/blog/nastrojka-klienta-freeipa-na-servere-centos-7/
https://www.howtoforge.com/tutorial/how-to-install-freeipa-client-on-centos-7/
https://hub.docker.com/r/freeipa/freeipa-server
http://analogindex.ru/news/sistema-centralizovannogo-upravleni-avtorizaciej-pol-zovatelej-na-freeipa-v-docker_217237.html
