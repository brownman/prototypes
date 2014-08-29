set -e
loop(){
  local delay=${1:-60}
  while :;do
    commander     $builtin_commitment $delay
  done
}

loop ${@:-}

