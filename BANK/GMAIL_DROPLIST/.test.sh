set -o nounset
step1(){


dir_self=`dirname $0`
file_script="$dir_self/steps.sh"
if [ -f "$file_script" ];then
#echo "bash -e $file_script"
#cmd="$file_script"
#eval "$cmd" || { pushd $dir_self; }

cmd="pushd $dir_self"
echo $cmd
update_clipboard "$cmd"

else
ls -1 $dir_self/*
file_self=`where_am_i $0`
cmd="vi $file_self/.test.sh"
update_clipboard "$cmd"
fi




}
step1
