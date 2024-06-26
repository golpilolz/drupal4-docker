:warning: DO NOT USE FOR PRODUCTION SITE :warning:  
Drupal 4 is an old and unmaintained version with many security breaches  
Installed packages are also unmaintained versions  
:warning: DO NOT USE FOR PRODUCTION SITE :warning:  

## Init project
 
Copy .env.dist to .env and edit it  
Build and up docker image

````bash
docker compose up --build
````

On first run, you need to init database  

### MySQL

Read the [MySQL file](website/INSTALL.mysql.txt) for instructions on how to install the database.

#### Init Database

````bash
mysql -u root -e "CREATE DATABASE drupal;"
mysql -u root drupal < /var/www/drupal/database/database.4.1.mysql
````

#### Setup debian-sys-maint default password

````bash
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'debian-sys-maint'@'localhost' IDENTIFIED BY '${MYSQL_DEBIAN_SYS_MAINT_PASSWORD}';"
````

#### Destroy Database

````bash
mysql -u root -e "DROP DATABASE drupal;"
````

## Drupal
Edit your host file and ENJOY !  
Website is available at http://drupal4.local or http://127.0.0.1

## Mailhog
By default sendmail is configured to use mailhog.  
Mailhog is available at http://127.0.0.1:8025
