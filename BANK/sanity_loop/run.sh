clear
#set -e
set -u
source /tmp/library_proto.cfg
#init_lib
pushd `dirname $0` >/dev/null

loop(){
  local delay=${1:-60}
  while :;do
commander     $builtin_commitment $delay || exit
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
  export file_language=.config/langs

  if [ ! -f $file_language ];then
    touch $file_language
    echo -e "ru\nit\nar\nhi" > $file_language
  fi
}




use commander
set_env
validate_file_lang
loop ${@:-}
popd >/dev/null
