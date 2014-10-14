dir_self=`where_am_i $0`
dir_target=$dir_workspace/MAIL
mkdir -p $dir_target
commander "cp -ri $dir_self/TXT/* $dir_target"
