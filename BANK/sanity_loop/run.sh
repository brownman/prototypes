clear
set -u
#source /tmp/library_proto.cfg

pushd `dirname $0` >/dev/null
source /tmp/library.cfg
#$cmd_trap_err
#$cmd_trap_exit
#init_lib
single(){

  local delay=${1:-60}
commander     "$builtin_commitment $delay" || break
}

loop(){
  local delay=${1:-60}
  while :;do
commander     "$builtin_commitment $delay" || break
#{ kill 0; }
#breaking
  done
}
set_env(){
  local file_list=./DEPLOY/INSTALL/required.txt
  cat  $file_list 
  local cmd
  while read line;do
    cmd="use $line"
    echo "[CMD] $cmd"
#commander_fallback    "$cmd" "exit 1"
commander $cmd
  done < $file_list
}
testing(){
return 0
}

validate_file_lang(){
  export file_language=$HOME/.config/langs

  if [ ! -f $file_language ];then
    touch $file_language
    echo -e "ru\nit\nar\nhi" > $file_language
  fi
}




#use commander
use_sh  commitment 

#set_env
#commander validate_file_lang
#loop ${@:-}

single ${@:-}
popd >/dev/null
