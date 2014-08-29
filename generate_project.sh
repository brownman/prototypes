set -o nounset
clear

#source $dir_root/init.cfg
source /tmp/library.cfg
use commander
use print
use assert
use trace
use where_am_i 

dir_self="`where_am_i $0`"
dir_target="$dir_self/COMMON"
commander assert dir_exist $dir_target


single(){
  local line="$1"
  local   file=$( commander finder $line )
  commander   assert file_exist $file
  local   filename=`basename $file`

  file_target=$dir_target/$filename
  if [ ! -L $file_target ] ;then
    commander "ln -s $file $file_target" 
    #else
    # print ok file exist: $file_target 
  fi

  assert symlink_exist $file_target
}

many(){

  #file:   required.txt
  file_required=$1

  commander assert file_exist $file_required
  while read line;do
    echo $line 
    commander single $line  
  done < $file_required
}
#$cmd=${1:-single}
commander assert left_bigger $# 0
str="$1"
if [ -f "$str" ];then
  commander many "$1"
else
  commander single "$1"
fi

