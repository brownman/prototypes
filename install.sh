#the helpers function: use() assume the library folder is linked to /tmp/LIBRARY_PROTO
clear
pushd `dirname $0` >/dev/null
steps(){
  set -o nounset
  set -e
  source ./COMMON/BANK/where_am_i.cfg
  dir_root=`where_am_i $0`
  file_library_proto="$dir_root/COMMON/library_proto.cfg"
  file_target=/tmp/library_proto.cfg
  if [ -f $file_library_proto ];then
    if [ ! -L $file_target ];then
    ln -s $file_library_proto $file_target

    else
      echo "$file_target already exist"
    fi

  else
    return 1
  fi

}
set +e
(steps)
res=$?
if [ $res -eq 0 ];then
  echo DONE
else
  echo ERROR
fi

popd >/dev/null
