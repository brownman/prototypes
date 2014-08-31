set -o nounset
clear
source /tmp/library.cfg
read_tag(){
local file=$1
local tag=$2
cat $file | grep "^$tag" -m1 | cut -d':' -f2-
}
use dialog_confirm
use expose_var
use trace
use cat1
use pv1
use shyaml1
use python1
python_activate &>/tmp/python_out
use ps1
use vars
#use read_tag

file=task.yaml
subject=${1:-ex$(cat current)}

file_subject=/tmp/subject
shyaml_key $file "$subject"  > $file_subject


cat1 $file_subject true
print line
# || (  shyaml_keys $file )
str_cmd=$( read_tag $file_subject cmd )
str_desc=$( read_tag $file_subject desc )
url=$( read_tag $file_subject url )
commander "eval echo ${str_cmd}"
cmd_final=$( eval echo "$str_cmd" )

expose_var cmd_final
dialog_confirm  "$cmd_final" "$str_desc"   || ( gvim task.yaml )
