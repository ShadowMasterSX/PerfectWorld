# PerfectWorld  1.7.4 - 1.7.8 by Ragezone
works on Debian 11 and ubuntu 22
## How to install on  Debian and Ubuntu
---------------------------------------------------------------------------------------------------------------------------------------
## Automatic
---------------------------------------------------------------------------------------------------------------------------------------
### 0.0 Use pw_install.sh (Thanks to Talolan on Ragezone)

### 0.1 Download the Server
````
cd /home/; wget https://akranis-games.de/share/PW-Server-1.7.4-fixed.tgz
````
0.2 Extract the Server
````
cd /home/; tar -xvf PW-Server-1.7.4-fixed.tgz
````
### 0.3 Setup your Server Database
### 0.4 Copy libskill.so & libtask.so 
````
cp /home/gamed/libskill.so /usr/lib/
````
````
cp /home/gamed/libtask.so /usr/lib/
````
---------------------------------------------------------------------------------------------------------------------------------------
2. Use pw-build.sh to build the server
---------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------
## Manual Setup (not sure its works °_°)
---------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------
1. add the 32bit Libery and update your Server 
---------------------------------------------------------------------------------------------------------------------------------------
````
  dpkg --add-architecture i386; apt update; apt upgrade -y
````
---------------------------------------------------------------------------------------------------------------------------------------
2. install the base liberies and software
---------------------------------------------------------------------------------------------------------------------------------------
````
apt-get install -y mc screen htop default-jdk mono-complete exim4 p7zip-full libpcap-dev curl wget ipset net-tools tzdata ntpdate mariadb-server mariadb-client
````
````
apt-get install -y make gcc g++ libssl-dev:i386 libssl-dev libcrypto++-dev libpcre3 libpcre3-dev libpcre3:i386 libpcre3-dev:i386 libtesseract-dev libx11-dev:i386 libx11-dev gcc-multilib libc6-dev:i386 build-essential gcc-multilib g++-multilib libtemplate-plugin-xml-perl libxml2-dev libxml2-dev:i386 libxml2:i386 libstdc++6:i386 libmariadb-dev-compat libmariadb-dev
````
````
apt-get install -y libdb++-dev libdb-dev libdb5.3 libdb5.3++ libdb5.3++-dev libdb5.3-dbg libdb5.3-dev
````
---------------------------------------------------------------------------------------------------------------------------------------
2.1. setup MariaDB
---------------------------------------------------------------------------------------------------------------------------------------
````
mysql_secure_installation
````
---------------------------------------------------------------------------------------------------------------------------------------
3. (Optional) apache and php
---------------------------------------------------------------------------------------------------------------------------------------
````
apt-get install -y apache2 php  php-cli php-fpm php-json php-pdo php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath php-cgi php-mysqli php-common php-phpseclib php-mysql
````
4. (optional) phpmyadmin (not secure for Live Server)
````
apt-get install -y phpmyadmin
````
---------------------------------------------------------------------------------------------------------------------------------------

    
