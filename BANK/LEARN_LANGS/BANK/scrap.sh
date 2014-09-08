#set -e
  #(xdg-open "http://www.goethe-verlag.com/book2/EN/EN${lang}/EN${lang}0${num}.HTM" &)



scrap_page(){

  use commander
  use print
  use expose_var
  print func

set -u
#depend xmlint

  local lang_to=${1:-RU}

  local num=${2:-1}
 
  let 'num+=2'
  #    local str_num=$( str_num_get $num )

  local str_num=$( string_change $num )

  local filename_html="EN${lang_to}${str_num}.HTM"

  expose_var filename_html

  local url="http://www.goethe-verlag.com/book2/EN/EN${lang_to}/${filename_html}"
  use update_clipboard
update_clipboard 'website: learn_langs' "$BROWSER $url"
  # assert network_alive
  #(    assert url_alive "$url" ) 
  #res=$?
  #$res && ( commander "wget -P /tmp \"$url\"" ) || ( gxmessage2 "$BROWSER $url" )
  commander wget -P /tmp $url
echo   commander  xmllint --html /tmp/$filename_html

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
