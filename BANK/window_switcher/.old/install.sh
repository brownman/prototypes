#!/bin/bash
set -e
#author: ofer shaham
#info: installer
#date: 20-5-2014
#time: 7:47
#version: 1
pushd `dirname $0`>/dev/null
set -o nounset

#source struct.cfg
#[  -d $dir_workspace ] && { echo "[dir_workspace] already exist" ; } || { mkdir -p $dir_workspace ; }
create_anchor(){
    cat > /tmp/link << FILE
    shopt -s expand_aliases
    clear
    export dir_root="$dir_root"
    alias cdroot="cd \$dir_root"
    sleep 2
cmd="source \$dir_root/alias.cfg"
echo \$cmd

cmd="source \$dir_root/init.cfg"
echo \$cmd
alias step1="eval \$cmd"
FILE
cp -i /tmp/link $HOME/link
}


create_bashrc_link(){
    line="source ~/link"
    msg=" Appending 1 line  to .bashrc: $line"
    #echo "[line] $line"
    str=$( cat ~/.bashrc | grep "$line" )
    res=$?
    [ $res -eq 1  ] && { echo "$msg" ; echo "$line" >> ~/.bashrc; } || { echo "[bashrc Link] already Exist " ;}
}

create_workspace_for_user(){
    local dir_workspace="$dir_root/.config/$LOGNAME"
    local  dir="$dir_workspace"
    local dir_source="$dir_root/.config/.EXAMPLE"

    if [ -d "$dir" ];then
        echo "[ workspace ] already exist for user: $LOGNAME"
    fi

#    echo "[ generating workspace files] with basic configurations "
files=$( ls -1 $dir_source )
    for file in $files;do
        filename=`basename $file`
        file_dest="$dir_workspace/$filename" 
        file_source="$dir_source/$filename"
        [ -s "$file_dest" ] && ( echo "already exist: $file_dest" 1>/dev/null ) || ( cp  $file_source $file_dest )
    done
  #  ls -l $dir && { echo DONE!; } || { echo FAILED; }
}

single(){
    local str="$1"
    echo " [ step  ]  $str"
    eval "$str"
}

steps(){
clear
    export dir_root="$( pwd )"

    echo "[dir root] $dir_root"
    single    create_anchor
    single    create_bashrc_link
#    single    create_workspace_for_user
    # $dir_root/MENU/install_anchor.sh

}
steps

type steps | grep single--color=auto 
popd >/dev/null
