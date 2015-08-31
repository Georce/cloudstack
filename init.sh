if [ ! -d /var/cloudstack/management/.ssh ]; then
        mknod /dev/loop6 -m0660 b 7 6
fi
sleep 5

mysql -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" -h"$MYSQL_PORT_3306_TCP_ADDR" \
   -e "show databases;"|grep -q cloud

case $? in
  1)
        echo "deploying new cloud databases"
        cloudstack-setup-databases cloud:password@${MYSQL_PORT_3306_TCP_ADDR} \
        --deploy-as=root:${MYSQL_ENV_MYSQL_ROOT_PASSWORD} -i localhost
    ;;
  0)
        echo "using existing databases"
        cloudstack-setup-databases cloud:password@${MYSQL_PORT_3306_TCP_ADDR}
    ;;
  *)
        echo "cannot access database"
        exit 12
    ;;
esac

service cloudstack-management start
tail -f /var/log/cloudstack/management/catalina.out
