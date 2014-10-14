#!/bin/bash 
set -u
source /tmp/library.cfg 
use dialog_show_args
use dialog_confirm
use update_clipboard
use str_to_vars
use indicator
use commander 
use exiting 
$cmd_trap_err
$cmd_trap_exit


intro(){
  print color 33 'example:\nsendEmail -f advance.linux2@gmail.com -t
  advance.linux2@gmail.com -u "this is the test subject" -m "this is a test
  message" -s "smtp.gmail.com" -o tls=yes -xu advance.linux2 -xp \$BASHRC_PASSWORD'
  print ok
}



set_vars(){
  #`MSG`
  #set -e
  str_from="$@"
  local   MODE_DEBUG=false
  #From_Mail Sndr_Uname Sndr_Passwd
  str_to="To_Mail Subject textArea Attachment"
  dialog_show_args "$str_to" "$str_from" || exiting

  if [ $MODE_DEBUG = true ];then
    str_to2="From_Mail name password"
    str_from2="${From_Mail}  ${Sndr_Uname} ${Sndr_Passwd}"
    dialog_show_args "$str_to2" "$str_from2" || exiting

  fi
  local cmd="str_to_vars \"$str_to\" \"$str_from\""
  commander_gxmessage $cmd
  RELAY_SERVER="smtp.gmail.com:587"
  Log_File=/tmp/log
  CC_TO=''
  tls=auto
}


send(){
  set -o nounset
  use commander
  util=/usr/bin/sendEmail
  local cmd=""
  cmd="$util -v \
    -f ${From_Mail} \
    -t ${To_Mail}  \
    -u '${Subject}' \
    -m '${textArea}'  \
    -xu ${Sndr_Uname} \
    -xp ${Sndr_Passwd} \
    -o tls=${tls} \
    -s ${RELAY_SERVER} \
    -l ${Log_File} "

  if  [ -f "$Attachment" ];then
    cmd="$cmd -a ${Attachment}"
  else
    notify-send "no attachment"
  fi

  print color 33 "[cmd] $cmd"
  eval "$cmd" &>/tmp/err || (xcowsay err; $gxmessage1 )
}

step(){
  use commander
  echo $@
  commander "$@" || { print error; exit 1; }
}

ping_google(){
  ping -c 3 8.8.8.8 || { print error "network is down";exit 1; }
}

steps(){
  #type arr_print &>/dev/null  && { arr_print; } 
  step set_vars "${arr[@]}"
  #  step ping_google
  step send
}
arr=( $@ )
steps
