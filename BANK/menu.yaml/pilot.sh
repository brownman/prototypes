#!/bin/bash
#info:   parse a menu which described in yaml
#YAML VALIDATOR: http://yamllint.com/


source /tmp/library.cfg
notify-send pilot 
exec -c
exports(){
export dir_prototypes=/tmp/dir_root/SCRIPT/prototypes/BANK
export dir_SERVICE=/tmp/dir_root/SCRIPT/SERVICE
export dir_LEARN_BASH=$dir_prototypes/LEARN_BASH
}

ensure_anchor(){
  file_self=$(who_am_i $0 )
  if [ ! /tmp/pilot.sh -ef "$file_self" ];then
    rm1 /tmp/pilot.sh
    commander ln -s $file_self /tmp 
  fi
}

using(){


  use ps1
  use open_with
  use ps4
  use where_am_i
  use dialog_confirm
  use rm1
  use exiting
  use commander
  use print
  use assert
  use cat1
  use dialog_menu
  use who_am_i
  use vars

}
broadcast1(){
  echo xcowsay "$@"
}

act_on_list1 () 
{ 
  local file=$1;
  local cmd=${2:-source};
  #while read line; do
    local         cmd1="$cmd $line";
    echo "$cmd1";
    eval "$cmd1"
  #done < $file
}




menu_subject(){

  set -o nounset
  #set -e
  #trap trap_err ERR


  local menu_name="$1"
  local str1 str cmd res

  commander assert string_has_content "$menu_name"
  #print ok $FUNCNAME 
  cmd="parse_subject_menus '$menu_name'"
  commander  "$cmd"

  str=$( dialog_menu_multiple /tmp/subject menu.yaml )

  #log1 "$str"
  [ -z "$str" ]  && { print error 'got empty string';exit 0; }

  match_name "$str"
  res=$?
  #indicator "$res"
  if [ $res -eq 1 ];then
    broadcast1 "sub-menu" &
    print color 33 recursive call in order to extract by subject
    eval "menu_subject \"$str\""
  else

    broadcast1 "command" &
print color 33 "[ACTION] $str"
#    str1="$( echo $str )"
    if [ "$MODE_CONFIRM" = true ];then
      dialog_confirm "$str" &
    else
 #     echo "$str"
#      local cmd_final=$( "$str" )
commander "$str" &
    fi
  fi
}

trap_err(){
  broadcast1 trap err
  local str="$( caller )"
  #gxmessage "$str"

  local cmd="gvim +${str}"
  echo "$cmd"
  if [ -s /tmp/err ];then
    cat /tmp/err
    cmd=$( gxmessage -file /tmp/err -title trap_err -entrytext "$cmd" )
    echo $cmd
    eval "$cmd"
  fi
  exit 0
}


parse_parent_menus(){
  cat $file_menu | shyaml keys > /tmp/parents
}
parse_subject_menus(){
  cat $file_menu | shyaml get-value $menu_name > /tmp/subject
}
parse_record(){
  local str="$@"
  local cmd=$( cat $file_menu | shyaml get-value "$str" )
  echo "$cmd"
  #> /tmp/subject
}

set_env(){
  export dir_self=$(where_am_i $0)
  export file_menu=$dir_self/menu.yaml
  export dir_shyaml=$dir_self/shyaml
  #PYTHON_ENV/MAKE_ENV/env/bin/
  export    PATH=$PATH:$dir_shyaml
  source $dir_self/match_name.cfg
  export dir_gist=SCRIPT/LIBRARY/BANK/GIST
}
validate_list(){
  assert file_exist $file_menu
  echo cat1 $file_menu true
}
intro(){
  xcowsay pilot &
  flite -t pilot &

  broadcast1 "$time" &
  every 10 "broadcast1 \"$date_ws\"" &
}
validate_no_errors(){
  print_color 33 $FUNCNAME
  ( gxmessage1 /tmp/err ) 
  ( gxmessage1 /tmp/out_long )
}

steps(){
  using
  set_env
  validate_list
  commander "menu_subject $first_menu"
#  validate_no_errors
}

MODE_CONFIRM=false
exports
first_menu=${1:-MAIN}
#if [ $# -eq 0 ];then
  steps
#else
#  echo set_env
#  echo  parse_record "$@"
#fi

cat1 /tmp/err true
#gxmessage -file /tmp/err
#popd >/dev/null
