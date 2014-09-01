#str="${1:-crontab}"
clear
#source /tmp/env
#dir_root=/tmp/nothing
str1=$0
str2=$BASH_SOURCE
if [ $str1 =  $str2 ];then
cowsay  please source me
exit 1 
fi
steps(){


#env -i bash
./wrapper.sh
#env -i
#source /tmp/env_simple
#( source ./sanity.sh )

echo
#./service.sh $str

}
( steps )
