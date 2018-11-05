#!/bin/sh

#case "$choose" in
#  [yY]) echo "Yes" && exit;;
#  [nN]) echo "No" && exit;;
#  * ) echo "wrong input" && exit;;
#esac

black="\033[0;30m"
blackb="\033[1;30m"
white="\033[0;37m"
whiteb="\033[1;37m"
red="\033[0;31m"
redb="\033[1;31m"
green="\033[0;32m"
greenb="\033[1;32m"
yellow="\033[0;33m"
yellowb="\033[1;33m"
blue="\033[0;34m"
blueb="\033[1;34m"
purple="\033[0;35m"
purpleb="\033[1;35m"
lightblue="\033[0;36m"
lightblueb="\033[1;36m"
end="\033[0m"

if [ "$1" = 'start' ];then
  echo Start docker-compose
  docker-compose -f /opt/docker/compose/docker-compose.yml up -d
elif [ "$1" = 'restart' ];then
  docker-compose -f /opt/docker/compose/docker-compose.yml down && sudo docker-compose -f /opt/docker/compose/docker-compose.yml up -d
elif [ "$1" = 'stop' ];then
  docker-compose -f /opt/docker/compose/docker-compose.yml down
elif [ "$1" = 'logs' ];then
  docker-compose -f /opt/docker/compose/docker-compose.yml logs $2
elif [ "$1" = 'rebuild' ];then
  docker-compose -f /opt/docker/compose/docker-compose.yml down && sudo docker-compose -f /opt/docker/compose/npm-rebuild.yml up -d
elif [ "$1" = 'ps' ];then
  docker ps
elif [ "$1" = 'update' ];then
  cd /opt/docker/ && git pull origin master && dcm restart
elif [ "$1" = 'install' ];then
  if [ "$(whoami)" != "root" ];then 
    echo ${red}Please run as root.${end}
    exit
  fi
  echo Install\: dcm
  sudo ln -s $(readlink -f "$0") /usr/local/bin/dcm
  echo Install\: docker-compose yml
  sudo mkdir -p /opt/docker/
  sudo chown www-data:www-data /opt/docker/
  sudo chmod 775 /opt/docker
  cd /opt/docker/ && git clone https://github.com/DeLuXoUa/dev-local.git ./
  echo Install\: Project SSFront
  sudo mkdir -p /var/www/ssfront/
  cd /var/www/ssfront/ && sudo git clone https://github.com/SelectSpecs/SSFront.git ./
  sudo chown -r www-data:www-data /var/www/ssfront/
  sudo chmod -r 775 /var/www/ssfront/
  echo Install\: Project SSYii
  sudo mkdir -p /var/www/ssyii/
  cd /var/www/ssyii/ && sudo git clone https://github.com/SelectSpecs/SSYii.git ./
  sudo chown www-data:www-data /var/www/ssyii/
  sudo chmod 775 /var/www/ssyii/
else
  echo
  echo ${yellowb}Docker Compose Manage Tool${end}
  echo Help:
  echo ${green}start${end} - run all projects
  echo ${red}stop${end} - stop all projects
  echo ${lightblue}restart${end} - restart all projects
  echo ${purple}rebuild${end} - full reinstall node_modules on ssfront
  echo ${lightblue}logs${end} - all logs
  echo ${lightblue}logs \<image_id\>${end} - container logs
  echo ${lightblue}ps${end} - show runned docker\'s
  echo ${end}
fi

#exit 0;
