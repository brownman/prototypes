#yad.source: file.selection: http://code.google.com/p/yad/source/browse/trunk/src/file.c
#url.yad-examples: http://code.google.com/p/yad/wiki/Examples
#url.mail sending: http://www.cyberciti.biz/tips/linux-use-gmail-as-a-smarthost.html
#depend_package: xcowsay fortune

set -o nounset

source /tmp/library.cfg
use where_am_i
use print

print ok HELLO

set_env(){
  export dir_self=$( where_am_i $0 )
}

sourcing(){
  ### helper funcs
  use    str_to_arr
  source CFG/file_to_str.cfg
  source CFG/print_dialog.cfg
  source CFG/arr_print.cfg
  ### private params
  print ok "[LOADING PRIVATE PARAMS]"
  source $dir_conf/vars.conf

}
exporting(){
  export file_script=$dir_self/SH/gmail.sh
  export dir_txt=$dir_self/TXT
  export dir_cfg=$dir_self/CFG
  export dir_log=$dir_self/LOG
  export dir_conf=$dir_self/CONF
  export dir_ext=$dir_self/EXT
  ######compose a message: parameters
  export file_to=$dir_txt/to.txt
  export file_from=$dir_txt/from.txt
  export file_param=$dir_conf/vars.conf
  ######extensions:
  #monkey
  #translate
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
    3)
      str=`            cat $dir_txt/talk_to.txt`
      xcowsay "$str"
      ;;
    2)
      $dir_ext/print_monkey.sh 
      ;;
    0)
      echo $str
      str_to_arr "$str"
      str=`echo "$str" | sed 's/(null)/xxx/g'`

      str_to_arr "$str"
      echo "${#arr[@]}"
      #    ( set -e; show_args  )
      #arr_print > /tmp/arr
      #cat -n /tmp/arr
      arr_print
      # local str_res=$(   show_args  )
      # local num_res=$?
      # echo
      #echo "[RESULTS]"
      #echo "$str_res"
      #echo "$num_res"

      local cmd="$file_script ${arr[@]}"
      #( trap trap_err ERR;  "$cmd")

      echo  "[cmd] $cmd"
      #  trap trap_err ERR;
      eval  "$cmd" 
      ;;
    *)
      echo "[skipping] un-known code"
      ;;
  esac 
  #show_args 
}
reminder(){
  echo "[YAD EXAMPLES]"
  echo http://code.google.com/p/yad/source/browse/wiki/#wiki
}
steps(){
  set_env
  exporting
  sourcing
  act
  reminder
}
steps
echo the end