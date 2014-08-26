#!/bin/bash
set -o nounset
set -e
exec 2> >(tee /tmp/err)

where_am_i () 
{ 
  local file=${1:-"${BASH_SOURCE[1]}"};
  local rpath=$(readlink -m $file);
  local rcommand=${rpath##*/};
  local str_res=${rpath%/*};
  local dir_self="$( cd $str_res  && pwd )";
  echo "$dir_self"
}

trap_err_service(){
  local str_caller="`caller`" 
  local cmd="gvim -f +${str_caller}"
  $( gxmessage /tmp/err -entrytext "$cmd" )
  exit 0
}


dir_self=`where_am_i $0` 
export dir_self=$dir_self
pushd $dir_self >/dev/null

set_env(){
  source $dir_self/init.cfg
}

intro_start(){
  #    echo "[dir_self] $dir_self"
  print func
  print ok Genius You
  nl < <( ls -1 $dir_STEPPER )
}

run(){
  local runner=$1
  shift
  local args="${@:-}"
  local cmd
  local file="$dir_STEPPER/${runner}.sh"
  if [ -f "$file" ];then

    if [ "${args[@]}" = edit ];then
      cmd="gvim -f $file"
    else
      cmd="$file $args"
    fi
    echo "[cmd] $cmd"
  #  xcowsay "$cmd"
    eval "$cmd"
  else
    notify-send "no such file: $file" "$0"
  fi

}

steps(){
  set_env
  intro_start
}





#trap trap_err_service ERR
if [ -f /tmp/service.sh ];then
  if [ $# -gt 0 ];then
    args="$@"
    steps 

    run $args
  else
    #        echo no arguments
    notify-send "no arguments" "$0"
    #ls -1 $dir_self/SH
    steps 
  fi
else
  echo install symlink first
  #rm /tmp/service.sh
  #commander ln_to_tmp "`who_am_i $0`"
  #dir_self=$PWD
  filename=`basename $0`
  file=$dir_self/$filename

  ln -s $file /tmp

fi


if [ ! -f /tmp/hotkey.sh ] ;then
  ln -s $dir_self/SH/hotkey.sh /tmp
fi
[ -f /tmp/hotkey.txt ] && rm /tmp/hotkey.txt
popd >/dev/null
