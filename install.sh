clear
pushd `dirname $0` >/dev/null

breaking(){
    echo
    echo '[B]'
    break
}
install_ppa(){
    type yad &>/dev/null || yes | (  
    sudo apt-get install python-software-properties
    sudo add-apt-repository ppa:webupd8team/y-ppa-manager 
    sudo apt-get update 
    sudo apt-get install yad 
    )
}
install_depend(){
    echo do we have everthing we need ?
    echo
    echo we have: 
    while read line;do
        [ -n "$line" ] || breaking
        (  exec &>/dev/null;  dpkg -L $line ) && ( echo -n "$line, " ) || (    sudo apt-get install -y $line )
    done < $file_list
    echo

}
dir_root=.
file_list=$dir_root/depend.txt
test -f $file_list
install_depend
install_ppa

popd >/dev/null
