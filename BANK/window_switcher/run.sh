#!/bin/bash

#gvim -f: dont fork! bring to foreground

#depend: gvim yad gxmessage 
clear
set -o nounset
#set -e
exec 2> >(tee /tmp/err)
source /tmp/library.cfg
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
  set -e
  print func
  local file="$1"
  local tag="$2"
  print color 33 "file: $file tag:$tag"

cat $file | grep '^$tag:' -m1 | cut -d':' -f2-
}

task(){
  set -e
  set -u
  print func
  local file="$1"
  local tag="$2"
  local   cmd=$( commander parse_line $file $tag )
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
commander dialog_optional_edit $file


  commander task $file start
  commander $cmd_sleep
  while :;do
    #dialog_optional contine? && ( $cmd_sleep )   || break 
    dialog_yes_no 'y/n' 'another minute ?' && ( commander $cmd_sleep )   || break
  done

# commander  task $file end
}

single(){

  dialog_optional_edit $file_list
  while read line;do
    [ -z "$line" ] && { breaking; }
    commander  init_task $line
  done< $file_list
}
loop(){

  let counter=1


  while :;do
    xcowsay "wow!"
    sleep .1
    xcowsay "round: $counter" 
    #dialog_optional contine?  || break 

    dialog_yes_no 'y/n' 'magnify the small ?'  || break
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
