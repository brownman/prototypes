set -o nounset
clear
set_env(){
  source /tmp/library.cfg
  use assert
  use print
  use commander
}

help1(){
  print color 33 supply a folder for linking BANK to;  
}

steps(){
  print color 33 replacing the BANK LINK TO: $str
  commander rm BANK
  commander ln -s $str BANK
}
#validate we got a dir
set_env
if [ $# -eq 0 ];then
  help1
else
  str="$1"
  assert dir_exist "$str"
  steps
fi

commander ls -l BANK




