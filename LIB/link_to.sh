set -o nounset
clear
set_env(){
source /tmp/library.cfg
use assert
use commander
}

help1(){
  echo supply a folder for linking BANK to; exit 0; 
}

steps(){
print color 33 replacing the BANK LINK TO: $str
commander rm BANK
commander ln -s $str BANK
}
#validate we got a dir
set_env
[ $# -gt 0 ] || help1
str="$1"
assert dir_exist "$str"

steps

