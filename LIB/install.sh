#the helpers function: use() assume the library folder is linked to /tmp/LIBRARY_PROTO
#http://superuser.com/questions/196572/check-if-two-paths-are-pointing-to-the-same-file
clear
#pushd `dirname $0` >/dev/null
dir_self=`dirname $0`
steps(){
  set -o nounset
  #set -e
  source $dir_self/BANK/where_am_i.cfg
  local dir_self=`where_am_i $0`

  local file_library_proto="$dir_self/library_proto.cfg"
  local file_target=/tmp/library_proto.cfg
  local str str1 str2

  if [ -f $file_library_proto ];then
    if [ ! -L $file_target ];then
      ln -s $file_library_proto $file_target

    else
      echo "[symlink already exist ] $file_target "
      #      if [ ! -e $file_target ] ; then
      #        echo "[but it is broken !]"
      #      fi
      str1=$(      ls -l $file_target | cut -d'>' -f2 )
      str2=$(      ls -1 $file_library_proto )

      
      if  [ "$str1" -ef "$str2" ]; then # $1 and $2 are different files

        echo but it is invalid
        echo press enter to fix it
        read
        rm $file_target
        echo press enter to run this script again
        $0
        exit 0
      fi



    fi

  else
    return 1
  fi

}
#set +e
steps
res=$?
if [ $res -eq 0 ];then
  #echo NOW
  #echo you can source /tmp/library_prot.cfg 
  #echo then: you can run: use\(\) for loading library files
  #echo
  echo DONE!
else
  echo ERROR
fi

#popd >/dev/null
