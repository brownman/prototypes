#!/bin/bash
notify-send pilot 
gvim -f ~/idea.yaml 
#info:   parse a menu which described in yaml
#YAML VALIDATOR: http://yamllint.com/
#shopt -s expand_aliases
exec -c
#set -e
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin:/usr/games
TERM=xterm
DISPLAY=:0 
LOGNAME=paretech
#

exec 2> >( tee /tmp/err )
#set -x
#set -e
#shopt -s expand_aliases

pushd `dirname $0` >/dev/null
source_pyenv(){
 # set +u
 set +o nounset
 set -o | grep nounset
#exiting 

    #test -f $file_python
    #assert file_exist "$file_python"
#    ls -l $file_python
#  commander  source $file_python

  #set -u
#  commander command shyaml && ( print ok we have shyaml loaded ) || { print error;  exiting ; }
  
}

ensure_anchor(){
    file_self=$(who_am_i $0 )
    if [ ! /tmp/pilot.sh -ef "$file_self" ];then
      rm1 /tmp/pilot.sh
    commander ln -s $file_self /tmp 
    fi
}

using(){
    use where_am_i
    use dialog_confirm
    use rm1
    use exiting
    use dialog_menu
    use commander
    use print
    use assert
    use cat1
    use dialog_menu
    use who_am_i

}
broadcast1(){
    echo xcowsay "$@"
}

act_on_list1 () 
{ 
    local file=$1;
    local cmd=${2:-source};
    while read line; do
        local         cmd1="$cmd $line";
        echo "$cmd1";
        eval "$cmd1"
    done < $file
}

test_type(){
    str="$1"
    #trap trap_err ERR
    #  text="${(type $str):-$(echo $str)}"
    text=$(type $str)
    ( gxmessage "$text" )
}


menu_subject(){

    set -o nounset
    #set -e
    #trap trap_err ERR
    local menu_name="$1"
    commander assert string_has_content "$menu_name"
    #print ok $FUNCNAME 
    local cmd="parse_subject_menus '$menu_name'"
    commander  "$cmd"

    local  str=$( dialog_menu_multiple /tmp/subject menu.yaml )
    #log1 "$str"
    [ -z "$str" ]  && { print error 'got empty string';exit 0; }

    match_name "$str"
    local res=$?
    #indicator "$res"
    if [ $res -eq 1 ];then
        broadcast1 "sub-menu" &
        eval "menu_subject \"$str\""
    else

        broadcast1 "command" &
        echo "[ACTION] $str"
        str1="$( echo $str )"
        if [ $MODE_CONFIRM = true ];then
            dialog_confirm "$str1"
        else
            echo "$str"
            local cmd_final=$( eval echo "$str" )
            dialog_confirm  "$cmd_final"
        fi
    fi
}
source_lib(){
    trap trap_err ERR
    MODE=0
    shopt -s expand_aliases
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

update_env(){
    exec 2> >( tee -a /tmp/err )
    exec 1> >( tee -a /tmp/out_long )
    echo
}
set_env(){

    dir_self=`where_am_i $0`
    file_menu=$dir_self/menu.yaml
    dir_python=$dir_self/PYTHON_ENV/MAKE_ENV/env/bin/
#    file_python=$dir_self/PYTHON_ENV/MAKE_ENV/env/bin/activate

    #file_python=$dir_python/python2.7
    #file_shyaml="$dir_python/shyaml"
export    PATH=$PATH:$dir_python

    source $dir_self/match_name.cfg
}
validate_list(){
    assert file_exist $file_menu
    #commander cat1 $file_menu true
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
    #rm1 /tmp/err
    #rm1 /tmp/out_long
    #source libs



    source /tmp/library.cfg

    using
    set_env



    ensure_anchor
    validate_list


    source_pyenv
    #intro
    #detect: user is cron/hotkey/shell
    menu_subject main

}

MODE_CONFIRM=false
if [ $# -eq 0 ];then
    steps
else
    echo set_env
    echo  parse_record "$@"
fi

cat1 /tmp/err true
gxmessage -file /tmp/err
popd >/dev/null
