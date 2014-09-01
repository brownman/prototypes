set -u
clear
#dir_root=$PWD
#echo dir_root: $dir_root

test $# -gt 0 || { echo supply a funcname ; exit; }
set_env(){
  source /tmp/library.cfg
  use print
  use assert
  use indicator
  use commander
}


single(){
  file=$( commander finder "$str1" "$str2"  )
  res=$?
  if [ $res -eq 0  ];then
    #if [ -n "$file" ];then
    commander assert file_exist $file

    filename=`basename $file`
    dir_target='./COMMON/BANK'
    commander assert dir_exist $dir_target
    file_target="$dir_target/$filename"
    [ -L $file_target ] && ( print color 33  file already exist: $file_target ) || (  commander ln -s $file $file_target ;   commander
    assert symlink_exist $file_target )
  fi
}
str1="$1"
str2="${2:-cfg}"
single "$str1" "$str2"


