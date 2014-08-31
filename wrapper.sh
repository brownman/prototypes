#!/bin/bash
reset
#env -i
set -o nounset
#set -x
#set -e


pushd $( dirname $0 ) >/dev/null
#aware of director  y
#update dir_root 
#source $dir_root/COMMON/funcs.cfg

exec 2> >( tee /tmp/err )
#trap trap_exit SIGTERM
set_traps(){
trap trap_exit EXIT
trap trap_err ERR
}
#export dir_root="."
#source $( find where_am_i )
#use where_am_i
clear(){
  echo 1>&2 "[CLEAR] `caller`"
}


trap_exit(){
#  echo `caller`
  echo 1>&2 "[ $FUNCNAME ] "
  #cowsay $FUNCNAME
 # eval $str_caller
}

trap_err(){
  echo 1>&2 $FUNCNAME
  cowsay $FUNCNAME
  $str_caller
}

set_env(){
  use where_am_i
  use trace
  use commander
  use assert
  use print
}



set_root(){
  source ./COMMON/BANK/where_am_i.cfg
  export dir_root=`where_am_i $0`
  echo 1>&2 "[dir root] $dir_root"
}

init(){
  if [ -n "$str1" ] && [ -f "$str1" ];then
    if [ "$str2" = edit ];then
      gvim $str1
    else
      set_env
      commander $str1
    fi

  else
    cowsay please supply a file
  fi
}

testing(){
  set_env
  use print
  print ok testing
}
str1=${1:-}
str2=${2:-}

export dir_library_proto=/tmp/LIBRARY_PROTO
( exec 2>/dev/null;  test -L $dir_library_proto ) || ./install.sh
#echo $?

source $dir_library_proto/library_proto.cfg
#set_root
#source $dir_root/COMMON/helper.cfg
testing &&  init
popd >/dev/null
