#url_mindmap='http://drichard.org/mindmaps/'

#url_android='http://developer.android.com/training/index.html'

#( wmctrl -a mindmap ) || ( google-chrome-stable $url_mindmap )
set -o nounset
str="$1"
file=/tmp/hotkey.txt
exec 2>/tmp/err

edit1(){
  xcowsay 'error: hotkey'
  gxmessage -file /tmp/err -title hotkey -timeout 10  
}
commander(){
  local cmd="$@"
  echo "[cmd] $cmd"
  eval "$cmd"
}

if [ -f $file ];then
  if [ "$str" = edit ];then
    #cowsay "`ls -l $file`"
    commander    gvim $file
  else
    cmd=$( cat $file | grep '^hotkey:' -m1 | cut -d':' -f2 )
    test $? -eq 0  && (   commander "$cmd" ) || ( edit1 )
  fi
else
  xcowsay "[file] not found: $file";
  /tmp/service.sh crontab
fi

