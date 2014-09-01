clear
set -u
pushd `dirname $0`>/dev/null

make_vars(){
while read line;do
  [ -n "$line" ] || break
commander  "export $line"
done <$file_container_details
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
  echo CONTAINER_ID=$CONTAINER_ID > $file_container_details
  echo CONTAINER_NAME=$CONTAINER_NAME >> $file_container_details
  get_env >> $file_container_details
  cat1 $file_container_details true
}

start(){
  #ssh docker@$inet -p 49153 ÃŸh -c './docker-desktop -s 800x600 -d 10 > /dev/null 2>&1 &'" # Here is where we use the external port
  echo
}
server1(){
 commander  test -v CONTAINER_ID
#  commander ssh docker@$inet -p $port sh -c './docker-desktop -s 800x600 -d 10'
 ssh docker@$inet -p $port "sh -c './docker-desktop -s 800x600 -d 10 > /dev/null 2>&1 &'" # Here is where we use the external port

}
client1(){
commander   test -v CONTAINER_ID
#  update_clipboard $password
xpra --ssh="ssh -p $port" attach ssh:docker@${inet}:10
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
    commander docker kill $pid && ( rm1 $file_container_details )
    
  else
    print error "docker has no instances currently running"

  fi
}
save1(){

  local max=$( docker ps | wc -l )
  [ $max -gt 2 ]  && { echo 1>&2 too many instances of docker are running - make sure only 1 instance is running - before try saving - exiting; exit 1; }
local num=$( docker ps -l | tail -1 |  cut -d' ' -f1  )

time_update
local name_base=$( echo $CONTAINER_NAME | cut -d'-' -f1 )
local container_new="$name_base-${date_ws}${time_ws}"

commander docker commit $num $container_new
echo $container_new > $file_container_name
cowsay "[PUSH COMMIT?] commander docker push $container_new"
}

file_container_details=/tmp/container
file_container_name=/tmp/container2
#file_container_details_new=./recent
#NAME=brownman

set_env
CONTAINER_NAME=$(cat $file_container_name)
#$NAME/docker-desktop}

test -v CONTAINER_NAME || { exit 1; }

expose_var CONTAINER_NAME
commander ensure_running
make_vars
if [ $# -gt 0 ];then
  cmd="$1"
  commander  $cmd
  #get_env
else 
intro 2>&1
fi

#ssh_x11
#interactive

popd >/dev/null
