# PerfectWorld

## How to install on Debian 11 and ubuntu 22.04

1. add the 32bit Libery and update your Server
````
  dpkg --add-architecture i386; apt update
````

2. install the base liberies
````
apt-get install -y libstdc++6:i386 libxml2:i386
````

3. install Java and Mariadb
````
apt install -y default-jdk mariadb-server
````

 4. (Optional) apache and php
````
apt install -y apache2 php php-mysql php-mbsting php-curl php-soap php-intl php-gd
````
5. (optional) phpmyadmin
````
apt install -y phpmyadmin
````

    
