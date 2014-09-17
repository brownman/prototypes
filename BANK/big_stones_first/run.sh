#!/bin/bash

#gvim -f: dont fork! bring to foreground

#depend: gvim yad gxmessage 
clear
set -o nounset
#set -e
xcowsay 'remember the big stones !'
exec 2> >(tee /tmp/err)
source /tmp/library.cfg

$cmd_trap_err

let counter_rounds=0
#use1
use ps1
use ps4
use assert
use where_am_i
use commander
use print
use trace
use cat1
use ensure
use who_am_i
use breaking
use dialog_sleep
use exiting
use dialog_optional

#pid  switcher lock

intro(){
  print func
  # print color 33 'assuming: alt+F1: triggers /tmp/hotkey.sh run '
  #  print color 34 'alt+F2: triggers: /tmp/hotkey.sh edit'
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


testing(){
  #ls $dir_self/HOTKEY
  return 0
}

set_env(){
  #source /tmp/library.cfg
  echo
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
  #set -x
  set -u
  print func
  local file="$1"
  local tag="$2"
  print color 33 "file: $file tag:$tag"

  commander "cat $file | grep '^$tag:' -m1 | cut -d':' -f2-"
}

task(){
  set -u
  print func
  local file="$1"
  local tag="$2"
  local   cmd=$( parse_line "$file" "$tag" )
  commander "$cmd"  &
}

init_task(){
  print func
  local task_name="$1"
  log $task_name
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
  commander dialog_optional_edit $file


  commander task $file start
  commander $cmd_sleep
  while :;do
    #dialog_optional contine? && ( $cmd_sleep )   || break 
    dialog_yes_no 'y/n' 'another minute ?' && ( point_up; commander $cmd_sleep )   || break
  done

  # commander  task $file end
}

single(){

  dialog_optional_edit $file_list
  while read line;do
    [ -z "$line" ] && { breaking; }
    commander_gxmessage   init_task $line
  done< $file_list
}
point_up(){
  let 'counter_rounds += 1'
  xcowsay "wow!" &
  sleep .1
  xcowsay "round: $counter_rounds"  &
}

loop(){
  while :;do
    #dialog_optional contine?  || break 
    dialog_yes_no 'y/n' 'magnify the small ?'  || { dialog_optional_edit $0; break; }
    point_up
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
