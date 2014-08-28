set -o nounset
MODE_TEST=false

file_lock=/tmp/crontab.pid


[ -f $file_lock ] && { notify-send 'INDICATOR:' 'crontab is working'; notify-send 'removing locker'; rm /tmp/crontab.pid ;exit 0; } || ( xcowsay 'restarting: crontab';touch $file_lock; echo $$ > $file_lock; )


trap_exit(){
  rm1 $file_locker
}

broadcast(){
  xcowsay "$@" &
}

press(){
  local cmd="xdotool key $1"
  broadcast $cmd
  commander "$cmd"
}

window(){
  #fallback: fork proccess
  local str1="$1" #window title
  local str2="${2:-no fallback for $str1}" #fallback
  local res=1
  (   wmctrl -l | grep -i $str1 &>/dev/null )  && { wmctrl -a $str1 ;res=0; } || (
  broadcast "[ $str1 ] fallback to: $str2"; commander "$str2" &  )
  return $res
}
thunar1(){
  window thunar thunar
}
edit0(){
  local file="$1"
  local str2="$2"

    cat >$file <<FILE
    hotkey: xcowsay 'hotkey $str1'
    start: xcowsay 'start $str1'
    end: xcowsay 'end $str1'
FILE
}

edit1(){
  local file="$1"
  local str2="$2"
  #local cmd_edit="gvim -f $file"

  local cmd_edit="gvim $file"
  local msg1="add tag: $str2"

  broadcast "$str2";
  commander1 "$cmd_edit"
}

switch(){
  local str1="$1"
  local str2="$2"
  local file="$dir_root/HOTKEY/${str1}.txt"
  local cmd=''
  local res

  cat1 $file true


  dialog_optional_edit_file $file

  if [ ! -f $file ];then
    


    edit1 $file 
    #'[ADD] tags for: start,end,hotkey'
  else
    cmd=$( cat $file | grep "\#${str2}:" -m1 | cut -d':' -f2-  )
    res=$?
    if [ $res -eq 0 ];then
      ( commander1 $cmd )  || ( edit1 $file $str2 )
    else
      edit1 $file $str2 
    fi

  fi
}

clear
set -o nounset
switch1(){
  return 0
  local str1=$1
  local str2=$2
  case $str1 in
    sleep)
      echo 1>&2 sleeeep
      ;;
    count)
      [ $str2 = start ] && ( commander "$dir_root/TASK/count.sh" )
      ;;
    lpi)
      [ $str2 = start ] && ( window CertExam 'thunar1' )
      ;;
    vlc)
      [ $str2 = start ] && ( window cisco 'thunar1'  && (press p) || (broadcast       err) )
      [ $str2 = end ] && ( window cisco 'thunar1'  && (press space) || (broadcast       err)  )
      ;;
    job)
      [ $str2 = start ] && ( window alljobs 'google-chrome-stable' )
      ;;
    **)
      xcowsay "[no handler] $str1 --> $str2"
      ;;
  esac
}

set_env(){
  trap - ERR
  use dialog_sleep
  use dialog_optional
  use rm1
  use cat1
  use print
  #use trap_err
  use link_hotkey_file   

  file_list=$dir_LIST/crontab.txt
}


ask(){
  local name="$1"
  while :;do
    dialog_optional "continue $name ?" true
    local res=$?
    if [ $res -eq 0 ];then
      switch $name start
      dialog_sleep 60 "$name"
    else
      breaking
    fi
  done
  return 0
}


task(){
  local name="$1"
  local   delay=${2:-60}
  #$cmd_trap_err
  xcowsay $name
  link_hotkey_file $name
  switch $name start
  dialog_sleep $delay $name && ( ask $name )
  switch $name end
  #local file=$dir_root/TASK/${filename}.sh 

  #$file 
  #$delay
}

loop(){
  while read line;do
    [ -n "$line" ] || breaking
    echo 1>&2 "[LINE] $line"

    ( commander $line )
    #&& ( ask "$line" ) || ( xcowsay "[return false] $line" )
  done < $file_list
}
count_reset(){
rm1 /tmp/count
  #link_hotkey_file count
  commander "$dir_root/TASK/count.sh" 
  ( dialog_sleep 30 count ) || echo


}

intro(){
  dialog_optional_edit_file $file_list
  count_reset

}
testing(){
  #  local cmd="$@"
  local cmd='task vlc'
  commander "$cmd"
}
run(){
  if [ $MODE_TEST = true ];then
    intro
  fi
  loop 
}
steps(){
  set_env

  commander   $cmd_start 
}
trap trap_exit EXIT
trap trap_exit SIGTERM
trap trap_exit ERR

cmd_start=${1:-run}
steps
[ -f $file_lock ] && ( rm $file_lock ) || echo

