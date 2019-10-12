https://github.com/kyourselfer/OTUS_LinuxAdmin201804/blob/master/lesson21_Journald_ELK/Playbook.yml




План:
1) Прочитать теорию про fluentd
1) Настроить web (nginx, rsyslogclient , journaldclient)
2) Настроить log (ntpd , journaldSrv , rsyslogSrv)
2) Настроить logweb EFK 



https://blog.selectel.ru/sbor-i-analiz-logov-s-fluentd/


Посмотреть роль
https://github.com/clickfreak/ansible-fluentd-role

https://github.com/sadsfae/ansible-elk


https://github.com/kyourselfer/OTUS_LinuxAdmin201804/tree/master/lesson21_Journald_ELK

Elasticsearch — сердце всего проекта, именно на нем лежит задача приема, хранения, обработки и поиска всех сущностей.
Fluentd — коллектор, который берет на себя роль приема всех логов, их последующего парсинга и бережного укладывания этого всего добра в индексы Elasticsearch.
Kibana — визуализатор, т.е. умеет работать с API Elasticsearch, получать и отображать полученные данные.
Nginx — используется как прокси сервер для доступа к Kibana, а так же обеспечивает базовую HTTP аутентификацию (HTTP basic authentication).
Curator — так как логи, в нашем случае, хранить более чем за 30 дней нету смысла, мы используем штуку, которая умеет ходить в Elasticsearch и подчищать индексы старше чем 30 дней.