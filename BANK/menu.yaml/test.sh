(
exec -c;
source /tmp/library.cfg;
use commander 

set -u
set +u
set -o | grep nounset
source ./ENV/MAKE_ENV/env/bin/activate;

command shyaml
)

