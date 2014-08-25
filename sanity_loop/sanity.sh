env -i
#set -e
#set -x
reset
set -o nounset
#export DISPLAY=:0
pushd `dirname $0` >/dev/null
source BANK/where_am_i.cfg

export dir_root=`where_am_i $0`
echo 1>&2 dir_root: $dir_root 
sleep 1
#alias set='trace set is locked'
#source $dir_root/init.cfg
exec 2> >( tee /tmp/err )
exiting(){
  print color 33  exiting
  exit 0
}
assertEqual(){
  print func
  test  "$1" = "$2" 
  indicator $?
  exiting
}
print_fallback(){
  #type print &>/dev/null
  local args=( $@ )
  local cmd="${args[@]}"
  command "$cmd" || ( echo 1>&2 $cmd )

}
depend(){
  local type_is="$1"
  local item="$2"
  case $type_is in
    var)
      assert var_exist $item
      ;;
    **)
      print error no handler for type: $type_is
      ;;
  esac


}


trap_exit(){
  local str1=$?

  exec 2>&1          
  print func 
  local str_caller="`caller`"
  print caller $str_caller
  indicator $str1
  #print func
  ( cat1 /tmp/trace true  | tail -1 )
  ( cat1 /tmp/err true | tail -1 )
  rm1 /tmp/err
  rm1 /tmp/trace
}

use_many(){
  local cmd
  for item in $@;do
    cmd="use $item"
    echo 1>&2  "[USE MANY] $cmd"
    eval "$cmd"
  done
}
use(){
  set -u
  #set -o pipefail 
  local str="$1"
  ( exec &>/dev/null; type $str | grep function ) && { return 0; } 

  local file="$dir_root/BANK/${str}.cfg"
  local str_caller="`caller`"
  local cmd


  if [ -f "$file" ];then
    cmd="source $file"
    echo 1>&2 $cmd
    eval "$cmd"

  else
    echo 1>&2 "[USE] $str_caller"
    print_fallback print error file not found: $file
  fi
}

use_sh(){
  local str="$1"
  echo "$dir_root/BANK/${str}.sh"
}
export -f use
export -f depend
export -f use_many
export -f use_sh
export -f print_fallback


trap trap_exit EXIT
trap trap_exit SIGTERM


use print
use indicator
use commander

use assert
use dialog_sleep


use file_update
use rm1
use flite1
use cat1
use ps1
use ps4
use trace    
use pipe_translate
use trap_err

export builtin_commitment=$( use_sh commitment )
export builtin_translate=$( use_sh translate )


loop(){
  while :;do
    source $dir_root/vars.cfg
    depend var file_language
    eval "$builtin_commitment"
    ( dialog_sleep 60 commitment ) || echo

  done
}
loop 

popd >/dev/null
