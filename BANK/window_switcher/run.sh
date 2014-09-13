#!/bin/bash

#gvim -f: dont fork! bring to foreground

#depend: gvim yad gxmessage 
clear
set -o nounset
#set -e
exec 2> >(tee /tmp/err)
source /tmp/library.cfg
#pid  switcher lock

intro(){
  print func
  print color 33 'assuming: alt+F1: triggers /tmp/hotkey.sh run '
  print color 34 'alt+F2: triggers: /tmp/hotkey.sh edit'
  #sleep 4
}


update_handler_for_hotkey(){
  print func
  local file="$1"
  commander rm1 /tmp/hotkey.txt
  commander ln -s $file /tmp/hotkey.txt

  dialog_optional_edit $file
  #print ok 'DONE !'
}

trap_err_service(){
  use print
  print func
  print error 
  local str_caller="`caller`" 
  local cmd="gvim  +${str_caller}"
  $( gxmessage -file /tmp/err -entrytext "$cmd" )
  exit 0
}


testing(){
  #ls $dir_self/HOTKEY
  return 0
}

set_env(){


  #source /tmp/library.cfg

  #USE
  use assert
  use where_am_i
  use commander
  use print
  use trace
  use cat1
  use rm1
  use who_am_i
  use breaking
  use dialog_sleep
  use dialog_optional
}
myself(){
  #SELF AWARE
  dir_self=`where_am_i $0` 
  file_self=`who_am_i`


  export file_list=$dir_self/LIST/tasks.txt

  #EXPORT
  export dir_self="$dir_self"

  export file_sample="$dir_self/TASK/.sample.txt"
  export file_hotkey=$dir_self/SH/hotkey.sh 

}


parse_line(){
  print func
  local file="$1"
  local tag="$2"
  set +o pipefail
  local cmd="cat $file | grep '^$tag:' -m1 | cut -d':' -f2-"
  local str_res=$( eval "$cmd" )
  #print color 33 "$str_res"
  echo $str_res
  # eval "$str_res"
}

task(){
  print func
  local file="$1"
  local tag="$2"
  local   cmd=$(parse_line $file $tag )
  echo 1>&2 $cmd
  commander "$cmd"  &
}

init_task(){
  print func
  local task_name="$1"
  local delay="$2"
  local desc=${3:-}
  if [ -n "$desc" ];then
    xcowsay "[TASK] $desc"
  fi

  #figure it out
  local file="$dir_self/TASK/${task_name}.txt"
  local cmd_sleep="dialog_sleep '$delay' '$task_name'"
  ( assert file_exist $file )  || ( cp $file_sample $file; gvim -f $file )

  cat1 $file true
  #sleep 5
  #  update_handler_for_hotkey $file 



  task $file start
  while :;do
    dialog_optional contine? && ( $cmd_sleep )   || break 
  done

  task $file end
}

single(){

  dialog_optional_edit $file_list
  while read line;do
    [ -z "$line" ] && { breaking; }
    commander  init_task $line
  done< $file_list
}
validate_symlinks(){
  #  trap trap_err_service ERR

  #anchors
  #rm1 /tmp/hotkey.sh
  test $file_hotkey -ef /tmp/hotkey.sh || (   rm1 /tmp/hotkey.sh; ln -s $file_hotkey /tmp/hotkey.sh
  )
  #rm1 /tmp/service.sh
  #ln -s $file_self /tmp/service.sh


}
loop(){

  let counter=1


  while :;do
    xcowsay "wow!"
    sleep .1
    xcowsay "round: $counter" 
    dialog_optional contine?  || break 
    let counter+=1
    single 
    sleep 5
  done
}
#validate
#assert file_exist $file_hotkey
steps(){
  set_env
  myself
  intro
  #validate_symlinks
  #  loop
  #single
  loop
}

#pushd $dir_self >/dev/null
steps
#popd >/dev/null


#pid  switcher unlock
