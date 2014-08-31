clear
set -u
pushd $(dirname $0) >/dev/null

make_vars(){
while read line;do
  [ -n "$line" ] || break
commander  "export $line"
done <$file_container
update_clipboard password $password
}

set_env(){
  source /tmp/library.cfg
  use commander
  use print
  use assert
  use update_clipboard
  use cat1
  use rm1
  use exiting
  use vars
  use expose_var
}
get_env(){
  test -v CONTAINER_ID || { print error 'use init() first'; return 1; }
  inet=$(  ifconfig | grep "inet" | tee /tmp/ifconfig | head -1 | awk -F' ' '{print $2}' )
  password=$( docker logs $CONTAINER_ID | sed -n 1p | cut -d' ' -f4 )
  port=$( docker port $CONTAINER_ID 22 | cut -d':' -f2)
  echo inet=$inet
  echo port=$port
  echo password=$password

}

init(){
  echo 'run in detached mode, and expose port 22'
  CONTAINER_ID=$(docker run -d -P $CONTAINER_NAME)
  echo CONTAINER_ID=$CONTAINER_ID > $file_container
  echo CONTAINER_NAME=$CONTAINER_NAME > $file_container
  get_env >> $file_container
  cat1 $file_container true
}

start(){
  #ssh docker@$inet -p 49153 ÃŸh -c './docker-desktop -s 800x600 -d 10 > /dev/null 2>&1 &'" # Here is where we use the external port
  echo
}
server1(){
  test -v CONTAINER_ID
  commander ssh docker@$inet -p $port sh -c './docker-desktop -s 800x600 -d 10'

}
client1(){
  test -v CONTAINER_ID
#  update_clipboard $password
local cmd="xpra --ssh='ssh -p $port' attach ssh:docker@${inet}:10"
echo $cmd
eval "$cmd"
}

interactive(){
  commander "docker run -t -i $CONTAINER_NAME /bin/bash"

}
intro(){
  print color 33 RUN:
  print line
  echo init - for start a new container process
  echo client1 - use xpra for reading remote x11 session
  echo server1 - ssh connect + run ./docker-desktop 
  echo kill1 - to kill running containers
  echo save1 - commit changes of docker instance
  echo interactive - run interactive mode
}

ensure_running(){
  local num=$( docker ps | wc -l )
  if [ "$num" -eq  1 ];then
    print ok start a new container ?
    read answer
    if [ $answer = y ];then
      commander init
    else
      print ok '[skipping]  creating new container '
      exit 0 
    fi

  else
    print ok using already running docker container
    # CONTAINER_ID=$( cat container )
  fi
}
kill1(){
  local num=$( docker ps | wc -l )
  if [ "$num" -ne  1 ];then

    local   cmd="docker ps | tail -1 | cut -d' ' -f1"
    local pid=$( eval "$cmd" )
    commander docker kill $pid && ( rm1 $file_container )
    
  else
    print error "docker has no instances currently running"

  fi
}
save1(){
local num=$( docker ps -l |tail -1 |  cut -d' ' -f1  )
local container_new=$CONTAINER_NAME${date_ws}${time_ws}
time_update
commander docker commit $num $container_new
echo $container_new > $file_container2
cowsay "[PUSH COMMIT?] commander docker push $container_new"
}

file_container=/tmp/container
file_container_new=./recent
NAME=brownman
CONTAINER_NAME=$(cat $file_container_new)
#$NAME/docker-desktop}

test -v CONTAINER_NAME || { exit 1; }
set_env
expose_var CONTAINER_NAME
commander ensure_running
make_vars
if [ $# -gt 0 ];then
  cmd="$1"
  commander  $cmd
  #get_env
else 
  intro
fi

#ssh_x11
#interactive

pop >/dev/null
