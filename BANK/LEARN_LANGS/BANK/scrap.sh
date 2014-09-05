#set -e
  #(xdg-open "http://www.goethe-verlag.com/book2/EN/EN${lang}/EN${lang}0${num}.HTM" &)



scrap_page(){

  let num=${1:-1}
  let lang_to=${2:-RU}

  use commander
  use print
  use expose_var
  print func
  #use figlet1
set -u
$cmd_trap_err
  

  
  let 'num+=2'
  #    local str_num=$( str_num_get $num )

  local str_num=$( string_change $num )
  local filename_html="EN${lang_to}${str_num}.HTM"

  expose_var filename_html

  confirm
  local url="http://www.goethe-verlag.com/book2/EN/EN${lang_to}/${filename_html}"
  echo commander "$BROWSER $url"
  confirm
  # assert network_alive
  #(    assert url_alive "$url" ) 
  #res=$?
  #$res && ( commander "wget -P /tmp \"$url\"" ) || ( gxmessage2 "$BROWSER $url" )
  commander "wget -P /tmp \"$url\""
  commander  xmllint --html /tmp/$filename_html

  return
  res=$?
  if [ $res -eq 0 ];then
    #figlet1 "SCRAPPING"
    local url0="http://www.goethe-verlag.com/book2/EN/EN${lang_to}/EN${lang_to}002.HTM"
    local url="${1:-$url0}"
    local file=/tmp/learn_langs

    scrap_dump "$url" | grep -v http 1>$file
    assert file_exist "$file"
    cat1 $file
    #conky: 
    #        ( pipe_wallpaper learn_langs 200 200 0 )
    #( dialog_optional  "google-chrome-stable $url"  'read transcript' 'read it and gain more points' )
  fi 
}

scrap_page $@
