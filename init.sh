#!/bin/bash
set -e

PORT=${PORT:-"3306"}
USER=${USER:-"root"}

if [ ! -d /var/cloudstack/management/.ssh ]; then
        mknod /dev/loop6 -m0660 b 7 6
fi
sleep 5

mysql -P"${PORT}" -u"${USER}" -p"${PASSWORD}" -h"${MYSQL}" \
   -e "show databases;"|grep -q cloud
   
case $? in
  1)
        echo "deploying new cloud databases"
        cloudstack-setup-databases cloud:"${PASSWORD}"@"${MYSQL}":"${PORT}" \
        --deploy-as="${USER}":"${PASSWORD}"
    ;;
  0)
        echo "using existing databases"
        cloudstack-setup-databases cloud:"${PASSWORD}"@"${MYSQL}":"${PORT}"
    ;;
  *)
        echo "cannot access database"
        exit 12
    ;;
esac

service cloudstack-management start
tail -f /var/log/cloudstack/management/catalina.out
