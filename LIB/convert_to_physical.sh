source /tmp/library.cfg
use commander
use print
use ensure
use assert

trap 'echo ERROR; caller;exit' ERR
set -u

dir_READONLY=READONLY
dir_SYMLINK=SYMLINK
[ -d $dir_READONLY ] && ( commander "mv READONLY /tmp/READONLY$(date +%s)" ;)
mkdir1 $dir_READONLY
print color 33 generating new files from symlinks
list=$( ls -l1 $dir_SYMLINK | egrep -h .cfg\|.sh | cut -d'>' -f2 )
for item in $list;do
  assert file_exist $item
cp $item $dir_READONLY/
done

chmod u-w $dir_READONLY/*

du $dir_READONLY
ls -l BANK
