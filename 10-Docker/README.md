Запустить можно сл командами:
    vagrant up
    vagrnt ssh
    sudo -s
    cd dockerlab/
    docker build -t $DOCKER_ID_USER/testnginx .
    docker images
    docker ps
    docker run -d -p 80:80 $DOCKER_ID_USER/testnginx
    docker push $DOCKER_ID_USER/testnginx

Ссылка на размещенный образ в docker hub: https://cloud.docker.com/u/8403374f984e/repository/docker/8403374f984e/testnginx

 Можно ли в контейнере собрать ядро?
 - Нет, тк контейнеры это изолированные процессы с общим ядром
