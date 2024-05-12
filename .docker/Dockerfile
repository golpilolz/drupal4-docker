FROM debian:12 as rootfsdl
RUN apt update && \
    apt install -y debootstrap xz-utils && \
    debootstrap --arch=i386 etch /var/tmp/rootfs http://archive.debian.org/debian/ && \
    rm -rf /var/tmp/rootfs/{dev,proc} && \
    mkdir -p /var/tmp/rootfs{dev,proc} && \
    mkdir -p /var/tmp/rootfs/etc && \
    cp /etc/resolv.conf /var/tmp/rootfs/etc/

FROM scratch
WORKDIR /
COPY --from=rootfsdl /var/tmp/rootfs .

ARG MYSQL_DEBIAN_SYS_MAINT_PASSWORD

COPY entrypoint.sh /sbin/entrypoint.sh

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y vim apache2 mysql-server-4.1 php4 libapache2-mod-php4 php4-mysql ssmtp cron wget \
 	&& ln -sf /dev/stdout /var/log/apache2/access.log \
 	&& ln -sf /dev/stderr /var/log/apache2/error.log \
 	&& chmod 755 /sbin/entrypoint.sh

# Setup Apache
RUN a2dissite 000-default
COPY apache/drupal /etc/apache2/sites-available/drupal
RUN a2ensite drupal \
    && a2enmod rewrite \
    && echo "ServerName 127.0.0.1" >> /etc/apache2/apache2.conf

# Setup MySQL
RUN /etc/init.d/mysql start \
    && sed -i "/password =/c\password = ${MYSQL_DEBIAN_SYS_MAINT_PASSWORD}" /etc/mysql/debian.cnf

# Setup PHP
RUN sed -i 's/;sendmail_path =/sendmail_path = \/usr\/sbin\/sendmail -t/g' /etc/php4/apache2/php.ini

# Setup SSMTP
COPY ssmtp/ssmtp.conf /etc/ssmtp/ssmtp.conf
COPY ssmtp/revaliases /etc/ssmtp/revaliases
RUN chmod 640 /etc/ssmtp/ssmtp.conf \
    && chown root:mail /etc/ssmtp/ssmtp.conf

# Setup CRON
ADD cron/drupal /etc/cron.d/drupal
RUN chmod 0644 /etc/cron.d/drupal \
    && crontab /etc/cron.d/drupal \
    && touch /var/log/drupal-cron.log \
    && ln -sf /dev/stdout /var/log/drupal-cron.log

# Clean up
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /var/www/drupal

# By default, simply start apache.
CMD ["/sbin/entrypoint.sh"]