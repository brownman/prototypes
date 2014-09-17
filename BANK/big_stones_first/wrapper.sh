#env -i
reset
set -o nounset
#set -x
set -e

export str_caller='$( caller )'
pushd $( dirname $0 ) >/dev/null
#aware of director  y
export dir_root="$PWD"

#update dir_root 
source $dir_root/CFG/init.cfg
source $dir_root/CFG/funcs.cfg
source $dir_root/using.cfg
#export dir_root=`where_am_i $0`
#echo 1>&2 dir_root: $dir_root 
exec 2> >( tee /tmp/err )

trap trap_exit SIGTERM
trap trap_exit EXIT
#set -e
 $dir_root/run.sh 

popd >/dev/null
