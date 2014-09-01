set -u

list=$( ls -l1 $dir_common/BANK/ | egrep -h .cfg\|.sh | cut -d'>' -f2 )
for item in $list;do
  cp $item $dir_common/READONLY/
done

chmod u-w $dir_common/READONLY/*
