
clear
set -u
set -e


set_env(){

source /tmp/library.cfg

use where_am_i
use commander
use print
use assert


dir_self=`where_am_i ${0:-$BASH_SOURCE}`
dir_BANK=$dir_self/BANK

source $dir_BANK/config.cfg
source $dir_BANK/user.conf
}

run(){

set -u
$dir_BANK/scrap.sh HI 3
}
set_env
run
