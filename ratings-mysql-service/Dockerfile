FROM mysql:5.7.20

#ENV MYSQL_ALLOW_EMPTY_PASSWORD=yes \
#    MYSQL_PASSWORD=secret

COPY ratings.sql /docker-entrypoint-initdb.d/

RUN if [ -z $(cat /etc/mysql/conf.d/docker.cnf | grep default_time_zone) ]; then echo "default_time_zone='+5:30'" >> /etc/mysql/conf.d/docker.cnf; fi