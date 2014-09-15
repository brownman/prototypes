#!/bin/bash
# about file:
# plugin:        take_photo.sh 
# description:   take a picture   
#. $TIMERTXT_CFG_FILE
#depend_package: ffmpeg video4linux2 flite xcowsay fortune

set -o nounset

dir1=/$HOME/Pictures
use ensure
depend xloadimage
depend ffmpeg
depend xcowsay

snap(){
    flite 'smile everyone'
    sleep 1
    flite 'say - cheeers!'
    sleep 1
    pic_file1=/tmp/monkey.jpeg
    pic_file2=$(echo $dir1/webcam-$(date +%m_%d_%Y_%H_%M).jpeg)
    ffmpeg -y -r 1 -t 3 -f video4linux2 -vframes 1 -s sxga -i /dev/video0 $pic_file1
    (/usr/bin/xterm -e xloadimage $pic_file1 &)
    fortune=`fortune`; 
    xcowfortune  --time=15 --think --at=0,0
    flite 'you ugly'
}

snap
