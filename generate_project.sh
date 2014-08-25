set -o nounset

source $dir_root/init.cfg
use commander
use assert
dir_self=`where_am_i $0`
dir_BANK=$dir_self/BANK
assert dir_exist $dir_BANK

while read line;do
 echo $line 
 file=$( commander finder $line )
 assert file_exist $file
 filename=`basename $file`
 file_target=$dir_BANK/$filename
 [ -f $file_target ] || ( commander "cp $file $file_target"  )
 
done < required.txt
