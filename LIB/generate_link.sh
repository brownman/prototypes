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
    dir_target='SYMLINK'
    commander assert dir_exist $dir_target
    file_symlink="$dir_target/$filename"
    if [ -L $file_symlink ];then
      if  [ ! $file -ef $file_symlink ];then
        print error symlink is broken
        use confirm 
        confirm 'remove symlink?' 'rm $file_symlink'
        echo run again for creating the symlink
      else
        print color 33  file already exist: $file_symlink  
      fi 
    else
      commander ln -s $file $file_symlink ;  
      commander     assert symlink_exist $file_symlink 

    fi
  fi
}
str1="$1"
str2="${2:-cfg}"
single "$str1" "$str2"


