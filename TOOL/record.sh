source /tmp/library.cfg
use commander
exec &>/tmp/screencast.txt
commander use_sh screencast $@  &
