#yad.source: file.selection: http://code.google.com/p/yad/source/browse/trunk/src/file.c
#url.yad-examples: http://code.google.com/p/yad/wiki/Examples
#url.mail sending: http://www.cyberciti.biz/tips/linux-use-gmail-as-a-smarthost.html
#depend_package: xcowsay fortune

set -o nounset

source /tmp/library.cfg
use vars
use where_am_i
use print
use    str_to_arr
use commander
use dialog_confirm
use exiting
#use print_dialog

ensure_settings(){
  local file=$file_settings
  if [ -f $file ];then
    #gvim $file
    source $file ;
  else
    xcowsay 'create new settings file'
    cat > $file << FILE
export BASHRC_PASSWORD=password
export BASHRC_USER=usename
FILE
    commander "$EDITOR $file"
    print error update the gmail settings; 
    exiting; 
  fi

  commander source $file_param
}

more_sourcing(){
  source $dir_self/CFG/file_to_str.cfg
  source $dir_self/CFG/print_dialog.cfg
  source $dir_self/CFG/arr_print.cfg
}
exporting(){
  export dir_self=$( where_am_i $0 )
  export file_script=$dir_self/SH/gmail.sh
  export file_settings=$HOME/gmail.conf 
  export dir_txt=$dir_self/TXT
  export dir_cfg=$dir_self/CFG
  export dir_log=$dir_self/LOG
  export dir_conf=$dir_self/CONF
  export dir_ext=$dir_self/EXT
  ######compose a message: parameters
  export file_to=$dir_txt/to.txt
  export file_from=$dir_txt/from.txt
  export file_param=$dir_conf/vars.conf
}

act(){
  export arr=()
  str=`print_dialog`
  res=$?
  echo $res
  case $res in
    1)
      echo "[Good bye]"
      ;;
    2)
      gvim $dir_self
      ;;
    0)
      echo $str
      str_to_arr "$str"
      str=`echo "$str" | sed 's/(null)/xxx/g'`

      str_to_arr "$str"
      echo "${#arr[@]}"
      commander arr_print
      local cmd="$file_script ${arr[@]}"
#      echo  "[cmd] $cmd"
#      eval "$cmd" 
      commander $cmd
      ;;
    *)
      echo "[skipping] un-known code"
      ;;
  esac 
}
steps(){
  exporting
  ensure_settings
  more_sourcing
  act
}
steps
echo the end
