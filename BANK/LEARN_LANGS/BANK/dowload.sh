download_language(){
    #pending: validate file size with wget - use chksum / md5
    set -o nounset
    local filename="${lang_from}${lang_to}-all.zip"
    local dir_target=/tmp
    local dir_new="$dir_archive"
    local file="$dir_target/$filename"
    mkdir1 $dir_new
    if  [ ! -f "$dir_new/.complete" ] ;then
        ( 
        commander      wget -c -P "$dir_target" "http://www.50languages.com/book2/${lang_from}/${lang_from}${lang_to}/${filename}"; 
        unzip "$file" -d "$dir_new"
        touch1 $dir_new/.complete
        #print_color 33 "[ dir ] $dir_new"
        ls -l "$dir_new"
        )
    else
        echo "[assume] download accomplished and file extracted to: $dir_new"
        echo "[skipping downloading/unzipping]"
    fi
}

