#!/bin/bash

cat > /etc/cron.hourly/ulos2 << EOF
#!/bin/bash

cd $PWD
./update.sh
EOF
