#!/bin/bash 
print color 34 'example:\nsendEmail -f advance.linux2@gmail.com -t
advance.linux2@gmail.com -u "this is the test subject" -m "this is a test
message" -s "smtp.gmail.com" -o tls=yes -xu advance.linux2 -xp "\$BASHRC_PASSWORD"'
print ok
#debug: http://danielthat.blogspot.co.il/2012/10/how-to-send-email-from-command-line.html
#bug: A temporary workaround is to edit the file /usr/bin/sendemail on line 1907 by changing 'SSLv3 TLSv1'in  to 'SSLv3',
#sendEmail -f from@gmail.com -t to@domain.com -u "This is my subject"  -m "Body of my message" -s smtp.gmail.com -o tls=yes -xu username -xp password


#url: https://packages.debian.org/unstable/mail/sendemail
#depend_package: sendemail libio-socket-ssl-perl libnet-ssleay-perl
#source: http://caspian.dotconf.net/menu/Software/SendEmail/sendEmail-v1.56.tar.gz
#extra:
# Define CC to (Note: for multiple CC use ,(comma) as seperator )
# CC_TO="loginrahul90@gmail.com"

#set -o nounset
#trap trap_err ERR
#set -x

set_vars(){
#`MSG`
set -e
use dialog_show_args
use update_clipboard
use indicator
str_from="$@"
str_to="From_Mail To_Mail Sndr_Uname Sndr_Passwd Subject textArea Attachment"
dialog_show_args "$str_to" "$str_from"
#Attachment="" 
local cmd="str_to_vars \"$str_to\" \"$str_from\""

#breakpoint
#echo "$cmd"
commander_fallback 'exit 1'  "$cmd" 

#echo "$str_to"  | xargs test -v
#echo "RES: $?"
# Define mail server for sending mail [ IP:PORT or HOSTNAME:PORT ]
RELAY_SERVER="smtp.gmail.com:587"

#RELAY_SERVER="smtp.gmail.com"
Log_File=/tmp/log
#/var/log/sendmail.log
CC_TO=''
tls=auto

                     #-cc '${CC_TO}' \
#auto/yes
}


send(){
   # set -x
set -o nounset
use commander
    util=/usr/bin/sendEmail
    local cmd=""
    if  [ -f "$Attachment" ];then
cmd="$util -v \
                     -f ${From_Mail} \
                     -t ${To_Mail}  \
                     -u '${Subject}' \
                     -m '${textArea}'  \
                     -a ${Attachment} \
                     -xu ${Sndr_Uname} \
                     -xp ${Sndr_Passwd} \
                     -o tls=${tls} \
                     -s ${RELAY_SERVER} \
                     -l ${Log_File}"
       
    else
        flite -t "no attachment"
        notify-send "no attachment"
cmd="$util -v \
                     -f ${From_Mail} \
                     -t ${To_Mail}  \
                     -u '${Subject}' \
                     -m '${textArea}'  \
                     -xu ${Sndr_Uname} \
                     -xp ${Sndr_Passwd} \
                     -o tls=${tls} \
                     -s ${RELAY_SERVER} \
                     -l ${Log_File}"

    fi
print color 33 "[cmd] $cmd"

commander "$cmd"
}
step(){
  use commander
echo $@
commander "$@" || { print error; exit 1; }
}
ping_google(){
ping -c 3 8.8.8.8 || { print error "network is down";exit 1; }
}
steps(){
#type arr_print &>/dev/null  && { arr_print; } 
step set_vars "${arr[@]}"
step ping_google
step send
}
arr=( $@ )
steps
