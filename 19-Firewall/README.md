vagrant up

https://drive.google.com/file/d/1dJrSrtNEpfPTvMXcLTz_LNRe39110xVj/view?usp=sharing

# Практическая часть
1) реализовать knocking port
- centralRouter может попасть на ssh inetrRouter через knock скрипт
Для выполнения данного пункта нашел анибл роль: https://github.com/fcsonline/ansible-port-knocking
2) добавить inetRouter2, который виден(маршрутизируется (host-only тип сети для виртуалки)) с хоста или форвардится порт через локалхост
3) запустить nginx на centralServer
4) пробросить 80й порт на inetRouter2 8080
5) дефолт в инет оставить через inetRouter

