clear

set -u
#pushd `dirname $0`>/dev/null
pushd `dirname $0`>/dev/null
#MODE_RUN=detach
MODE_RUN=interactive
set_env(){

  file_get_container_details=/tmp/container
  file_container_name=/tmp/container2
  #file_get_container_details_new=./recent
  #NAME=brownman

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

get_container_details(){


  type $FUNCNAME
  assert var_exist CONTAINER_NAME
  echo name: $CONTAINER_NAME
  CONTAINER_ID=$( docker ps -l | tail -1 | cut -d' ' -f1  )
  assert string_has_content "$CONTAINER_ID"

  echo id: $CONTAINER_ID
  password=$( docker logs $CONTAINER_ID | sed -n 1p | cut -d' ' -f4 )
  echo password: $password
  update_clipboard password $password
  port=$( docker port $CONTAINER_ID 22 | cut -d':' -f2 )
  echo port: $port
  inet=$(  ifconfig | grep "inet" | tee /tmp/ifconfig | head -1 | awk -F' ' '{print $2}' )
  echo inet: $inet

}

read_details(){
  local var_name
  while read line;do
    [ -n "$line" ] || break
    var_name="$(    echo $line | cut -d'=' -f1 )"
    var_content="$(    echo $line | cut -d'=' -f2 )"
    assert string_has_content "$var_content"
    commander  "export $line"
  done <$file_get_container_details

}


write_details(){
  local file=$file_get_container_details
  echo CONTAINER_NAME=$CONTAINER_NAME > $file
  echo CONTAINER_ID=$CONTAINER_ID >> $file
  echo inet=$inet  >>$file
  echo port=$port >>$file
  echo password=$password >>$file
}

show_details(){
  echo 'run in detached mode, and expose port 22'
  cat1 $file_get_container_details true
}
switch(){
  # start the container


  local cmd
  #  local CONTAINER_NAME="$1"
  local str="$1"

  type $FUNCNAME
  case $str in
    detach)
      cmd="docker run -d -P $CONTAINER_NAME"
      commander $cmd
      commander   connect1
      ;;
    interactive)
      echo interactive - run interactive mode
      cmd="docker run -t -i -P $CONTAINER_NAME /bin/bash"

      #cmd="docker run -t -i -P $CONTAINER_NAME /bin/bash"
      commander $cmd
      ;;
    forward) 
      cmd="docker run -i -p 22 -p 8000:80 -m /data:/data -t foo/live /bin/bash"
      commander $cmd
      ;;
    **)
      print error "No handler for case: $str"
      ;;
  esac
}

connect1(){

  type $FUNCNAME
  echo server1 - ssh connect + run ./docker-desktop 
  echo client1 - use xpra for reading remote x11 session
  commander get_container_details
  #  commander ssh docker@$inet -p $port sh -c './docker-desktop -s 800x600 -d 10'
  print color 34 check out
#echo  update_clipboard container-output  'cat1 /tmp/docker.out true'
commander  sleep 2
  ssh docker@$inet -p $port "sh -c './docker-desktop -s   800x600 -d 10 2>&1 &'" # Here is where we use the external port
  commander sleep 2
xpra --ssh="ssh -p $port" attach ssh:docker@${inet}:10
}

intro(){
  print color 33 RUN:
  print line
  #  echo write_details - for start a new container process
  echo kill1 - to kill running containers
  echo save1 - commit changes of docker instance
  echo log1 - print container details to the log file
  echo 'switch - <image-name> <run mode>'
}

container_alive(){
  local num=$( docker ps | wc -l )
  local res
  if [ "$num" -eq  1 ];then
    print color 33 please start a new container
    res=1
  else
    print ok there is already a running container
    res=0
    # CONTAINER_ID=$( cat container )
  fi
  return $res
}
kill1(){
  local num=$( docker ps | wc -l )
  if [ "$num" -ne  1 ];then

    local   cmd="docker ps | tail -1 | cut -d' ' -f1"
    local pid=$( eval "$cmd" )
    commander docker kill $pid && ( rm1 $file_get_container_details )

  else
    print error "docker has no instances currently running"

  fi
}
save1(){

  local max=$( docker ps -l | wc -l )
  [ $max -gt 2 ]  && { echo 1>&2 too many instances of docker are running - make sure only 1 instance is running - before try saving - exiting; exit 1; }
  local num=$( docker ps -l | tail -1 |  cut -d' ' -f1  )

  time_update
  local name_base=$( echo $CONTAINER_NAME | cut -d'-' -f1 )
  local container_new="$name_base-${date_ws}${time_ws}"

  commander docker commit $num $container_new
  echo $container_new > $file_container_name
  cowsay "[PUSH COMMIT?] commander docker push $container_new"
}


pick_from_file(){
  CONTAINER_NAME=$(cat $file_container_name)
  assert string_has_content "$CONTAINER_NAME" || { print error "update the file: $file_container_name with available docker image"; docker list; exiting; }
  commander expose_var CONTAINER_NAME
}

log1(){
  get_container_details
  write_details
  read_details
}

steps(){
  local res=1
  set_env
  #print ok
  intro
  #pick_from_pid ||     pick_from_file
  commander container_alive  
  res=$?
  echo $res
  if [ $res -eq 1 ];then
    commander docker images | tee /tmp/images
    echo for running docker image use:
    echo pick an image name and run: 
    print color 33 'switch <image-name> <running mode>'
    echo type the container name
    read answer
cat /tmp/images | grep $answer
    CONTAINER_NAME=$answer
    commander "switch $MODE_RUN"
  else      
    CONTAINER_NAME=$( docker ps -l   | awk -F' ' '{ print $2 }' | tail -1 | cut -d':' -f1 )
    commander assert string_has_content $CONTAINER_NAME
    print color 33 "[ currently running] $CONTAINER_NAME"
    print color 33 DEFAULT STARTUP COMMAND:
    echo option:  connect1 , kill1 , save1 , log1
    read answer
    commander     $answer
  fi
}

steps
if [ $# -gt 0 ];then
  cmd_start="$@"

fi

#ssh_x11
#interactive

#popd >/dev/null
popd
