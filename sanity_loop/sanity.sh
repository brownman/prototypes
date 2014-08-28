env -i
reset
set -o nounset
#set -x
set -e

export str_caller='$( caller )'
#export DISPLAY=:0
pushd $( dirname $0 ) >/dev/null
#aware of director  y
export dir_root="$PWD"

#update dir_root 
source $dir_root/CFG/init.cfg
source $dir_root/CFG/funcs.cfg
source $dir_root/CFG/load_once.cfg
#export dir_root=`where_am_i $0`

#select .cfg we want to use later
#ensure existance of file with the list of languages we want to learn




echo 1>&2 dir_root: $dir_root 
#alias set='trace set is locked'
#source $dir_root/init.cfg
exec 2> >( tee /tmp/err )



#about handling of SIGNALS
#type trap_err


#depend var file_language


#$cmd_trap_err


trap trap_exit SIGTERM
trap trap_exit EXIT
set -e

loop(){
#eval echo $str_caller
  local delay=60
  while :;do
commander     $builtin_commitment $delay
#    ( dialog_sleep "$delay" commitment ) || echo

  done
}
loop  

popd >/dev/null
