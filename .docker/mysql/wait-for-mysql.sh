#!/bin/sh
# Wait until a specific MySQL table is exists
max_wait=600

start=$(date +%s)
wait=1
while ! mysql -u"$MYSQL_USER" -p"$MYSQL_ROOT_PASSWORD" $MYSQL_DATABASE -Be 'show tables' 2>/dev/null | grep -q 'zipcodes_co' ; do
    sleep 5
    wait=$(expr $wait + 5)
    if [ $wait -gt $max_wait ]; then
        >&2 echo "We have been waiting for MySQL too long already; failing."
        exit 1
    fi;
done
end=$(date +%s)

echo "Waited $(expr $end - $start) seconds for MySQL."
