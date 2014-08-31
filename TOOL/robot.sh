
clear
../../record.sh false 60 &

dir=$PWD
#cmd_run=${1:-installation}
cmd_run=${1:-installation}

file_list=$dir/DEPLOY/PRESENT/${cmd_run}.txt

source /tmp/library.cfg
use where_am_i
use commander
use disown1
use assert

pushd `where_am_i $0` >/dev/null
typer(){
  assert left_bigger $# 1
  local window_name=$1
  shift
  local item
  local foo="${@}"
  commander echo $foo
  for (( i=0; i<${#foo}; i++ )); do
    item=$( echo ${foo:$i:1})
    [ "$item" = '' ] && {  item=space; }
    wmctrl -a "$window_name"
commander     xdotool key \"$item\"
    sleep .1
  done
}

use pv1
use print
use cat1 force

echo gvim $file_list | xsel --clipboard
while read line;do
  [ -n "$line" ] || { breaking 2>/tmp/err; }
  eval "$line" #|| ( print error $line )
done < $file_list
sleep 2
kill 0
popd >/dev/null
