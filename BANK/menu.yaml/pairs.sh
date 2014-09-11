#info: a suggested replacement for the well-known(+not efficient) browser bookmark manager
reset
#exec 2>/tmp/err
#set -e

exec -c
set -e
source /tmp/library.cfg

set -o nounset
use exiting
use print
use where_am_i
use dialog_dropdown
use commander
use dialog_menu
use open_with

#set -x
$cmd_trap_err
$cmd_trap_exit
echo Main Menu for PAIRS
notify-send pairs &

set_env(){
  dir_self=`where_am_i $0`
  dir_assets=$dir_root/ASSETS #todo: remove me
  dir=$dir_assets/URLS/BANK
}
ls_dir(){
  #echo ln1 "$0"
  file_ls=/tmp/1
  ls -1 $dir/*.txt > $file_ls
  #strip surrounding text
  file_urls=/tmp/2
  cat $file_ls |  sed "s,$dir/,,g" | sed 's/.txt//g' > $file_urls
}
choose_subject(){
  file_bookmarks=$dir_assets/bookmarks.txt
  str_res=$( dialog_dropdown $file_bookmarks )
  echo "$str_res"
  print ok "[SELECTED] $str_res"
}

extract_file(){
  file_target="$dir/${str_res}.txt"
  if [ -f $file_target ];then
    file_present $file_target
  else
    gvim $file_target 
    exiting
  fi
}
extract_parser(){
  cat $file_target | grep -v '\#' > $file_list
  cmd="parse_tag $file_target parser"
  util=$( commander  "$cmd" )
  [ -n "$util" ]  || { print error "empty parser";exit ;}
  print ok "[PARSER] $util"
}

run_line(){
  title="$str_res"
  text="choose 1"
  file="$file_target"
  str=$(dialog_menu_echo "$file" "$title" "$text")
  open_with "$str"
}

steps(){
  set_env
  #ls_dir
  choose_subject
  extract_file
  #extract_parser
  run_line
}

steps


#echo "$files" > /tmp/list_tmp
#menu /tmp/list_tmp
#cat -n /tmp/list_tmp
#file_list=/tmp/list_tmp
#file_present $file_list


