#depend: yad gxmessage
#info: make a commitment - write it down.
#set -e
#set -x
set -o nounset
#update_file(){
#   local     file=$1
#  local     line="$2"
# echo -e "$line" >> $file
#}
use assert
use flite1
use pipe_translate
use file_update
use trap_err
#$cmd_trap_err
#assert file_exist "$file_language"

update_commitment(){
    local line="${line:-}"
    local time1=`date | tr -s ' ' | cut -d' ' -f4 | cut -d':' -f1,2 `
    local cmd=""
    export GXMESSAGE='-ontop -sticky -wrap -timeout 10'
        while [ -z "$line" ];do
flite1 "next easy mission"

    #notify-send 'Condition: I want X + I give Y'

    title="Easy For Robot"
    cmd="gxmessage -entrytext \"$line\" -title \"$title\" -file \"$file_done\" $GXMESSAGE"

    local     line=$(    eval "$cmd" 2>/dev/null  )
    #  [ -z "$line" ] && ( random 5 ) ||  { print error 'empty string? try again'; update_commitment; }
          done

    if [ "$line" = exit ];then
        xcowsay exiting
        exit 1
    elif [ "$line" = delete ];then
         echo -n fresh start > $file_done  
         return 0
    else

        #local line_new="\${color yellow} $time1\t \${color blue} $line"

        local line_new="$time1\t $line"
        file_update "$file_done" "$line_new"
        [ -n "$line" ] && {  pipe_translate "$line"; } || echo
        if [ "$delay" -ne 0 ];then
            dialog_sleep  "$delay" "$line"
        fi
        echo "$line"
    fi
}
intro(){
    xcowsay 'describe your wish - what you want to get'
    xcowsay '+ what u do for others!! on suspension'
}
#unlocker

#[ ! -f $file_done ] && { touch $file_done ;}
#touch1 $file_done
#assert file_exist "$file_done"


#intro

file_done=/tmp/done
delay=${1:-0}
touch $file_done
#subject="${1:-commitment}"
#seconds=${1:-}
#line="${2:-}"

#if [ -z "$seconds" ];then
#    level=$( dialog_scale )
#    let "seconds=level*60"
#fi
#delay=${seconds:-60}

#if [ -z "$line" ];then
#use assert
assert file_exist "$file_done"

    #assert file_exist "$file_done"
update_commitment
#else

#    dialog_sleep "$delay" "$line"
#fi


