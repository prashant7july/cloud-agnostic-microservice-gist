FROM mysql:5.7.20

# If you write ENV here is rase security issues, so dont write ENV here specially credintial
#ENV MYSQL_ALLOW_EMPTY_PASSWORD=yes \
#    MYSQL_PASSWORD=secret

COPY scripts/* /docker-entrypoint-initdb.d/

RUN if [ -z $(cat /etc/mysql/conf.d/docker.cnf | grep default_time_zone) ]; then echo "default_time_zone='+5:30'" >> /etc/mysql/conf.d/docker.cnf; fi
