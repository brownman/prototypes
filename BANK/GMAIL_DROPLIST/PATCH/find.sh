str_num=$( cat -n sendEmail | grep TLSv1 | cut -d ' ' -f3 )
cmd="sudo gvim +${str_num} sendEmail"
echo "$cmd"
eval "$cmd" &

