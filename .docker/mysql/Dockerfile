FROM mysql:8.0


ENV MYSQL_ROOT_PASSWORD=somewordpress
ENV MYSQL_DATABASE=wordpress
ENV MYSQL_USER=wordpress
ENV MYSQL_PASSWORD=wordpress

COPY wait-for-mysql.sh /usr/local/bin/
COPY dump.sql /docker-entrypoint-initdb.d/