#!/bin/bash
#
# Считываем кол-во запросов по IP адресам из лога Nginx
# Без параметров количество запосов по IP, за последние 15 минут
# Опционально 1 параметром - время за которое выводим данные лога, в минутах
#
 
export LC_ALL=en_US.UTF-8
export LC_NUMERIC=C
 
if [ -z "$1" ]
then
    MNT="15"
else
    MNT="$1"
fi
 
# Максимальное количество IP в выводе
# По умолчанию 100
CNT="10"
 
TMS="$(date +%s)"
STR=""
STX=""

let "SEK = MNT * 60"
let "EXP = TMS - SEK"
 
while :
do   
     
    STR="$STR$STX$(date -d @$EXP +'%d/%h/%Y:%H:%M')"
    let "EXP = EXP + 60"
    STX="|"
     
    if [ "$EXP" == "$TMS" ]
    then
        break
    fi
         
done

#Сохраняем время последнего запуска
if [  ! -f "/tmp/LTR"  ]
then
    LTR="$(date -d @$EXP +'%d/%h/%Y:%H:%M')"
    echo $LTR > /tmp/LTR   
    
else
    LTR="$(cat /tmp/LTR)"
    echo $LTR
    
fi

RESULTFILE="/tmp/RESULTFILE"
find $RESULTFILE 2>/dev/null && rm -f $RESULTFILE
touch $RESULTFILE

MLTR=$(echo $STR | sed "s|^.*\($LTR.*$\)|\1|")  


echo "--- $LTR ---" > $RESULTFILE
#X IP адресов (с наибольшим кол-вом запросов) 
echo "The list of addresses with the most requests to the server " >> $RESULTFILE
echo "$(cat /var/log/nginx/nginx_logs | grep -E $MLTR | awk '{print $1}' | sort -n | uniq -c | sort -nr | head -n $CNT)" >> $RESULTFILE

#список всех кодов возврата с указанием их кол-ва с момента последнего запуска
echo "The list of status codes with their total number " >> $RESULTFILE
echo "$(cat /var/log/nginx/nginx_logs | grep -E $MLTR | cut -d '"' -f3 | cut -d ' ' -f2 | sort | uniq -c | sort -rn | head -n $CNT)" >> $RESULTFILE

#Y запрашиваемых адресов 
echo "The list of server resources with the most requests from the clients (top 10 req-res pairs)" >> $RESULTFILE
echo "$(cat /var/log/nginx/nginx_logs | grep -E $MLTR |awk '{print $7}' |sort |uniq -c |sort -rn| head -n $CNT)" >> $RESULTFILE

#Все ошибки 
echo "Total number of errors (status codes 4xx and 5xx, number-code pairs)" >> $RESULTFILE
echo "$(cat /var/log/nginx/nginx_logs | grep -E $MLTR |awk '{print $9}' |grep -E "[4-5]{1}[0-9][0-9]" |sort |uniq -c |sort -rn| head -n $CNT)" >> $RESULTFILE

#
##LTR="$(date -d @$EXP +'%d/%h/%Y:%H:%M')"
#echo $LTR > /tmp/LTR 
#echo $LTR

# Проверяем наличие указанного почтового адреса, иначе root@localhost
ADDRESS=$2
if [ -z $ADDRESS ] ;
        then
        ADDRESS=root@otuslinux.localdomain
fi
#
# Делаем простую проверку адреса почты
emailcheck() {
        echo "Checking email."
        echo "$1" | egrep --quiet "^([A-Za-z]+[A-Za-z0-9]*((\.|\-|\_)?[A-Za-z]+[A-Za-z0-9]*){1,})@(([A-Za-z]+[A-Za-z0-9]*)+((\.|\-|\_)?([A-Za-z]+[A-Za-z0-9]*)+){1,})+\.([A-Za-z]{2,})+"
        if [ $? -ne 0 ] ;
                then
                echo "Invalid email address!"
                exit 1
                else
                echo "Email check - OK!"
        fi
}
#
# Проверяем корректность введенного почтового адреса
if [ $ADDRESS != 'root@otuslinux.localdomain' ]
        then
        emailcheck $ADDRESS
fi

cat $RESULTFILE | mail -s "Message fron NGINX parser" $ADDRESS
##rm -f $RESULTFILE
exit 0