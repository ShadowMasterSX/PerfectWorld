# PerfectWorld  1.7.6 by Dragonheart (C) 2024
Only works on ubuntu 22.04
## How to install on  ubuntu 22.04

1. add the 32bit Libery and update your Server
````
  dpkg --add-architecture i386; apt update; apt upgrade -y
````

2. install the base liberies
````
apt -y install mc screen htop openjdk-11-jre mono-complete exim4 p7zip* libpcap-dev curl wget ipset net-tools tzdata ntpdate mariadb-server mariadb-client
````
````
apt -y install make gcc g++ libssl-dev:i386 libssl-dev libcrypto++-dev libpcre3 libpcre3-dev libpcre3:i386 libpcre3-dev:i386 libtesseract-dev libx11-dev:i386 libx11-dev gcc-multilib libc6-dev:i386 build-essential gcc-multilib g++-multilib libtemplate-plugin-xml-perl libxml2-dev libxml2-dev:i386 libxml2:i386 libstdc++6:i386 libmariadb-dev-compat libmariadb-dev
````
````
apt -y install libdb++-dev libdb-dev libdb5.3 libdb5.3++ libdb5.3++-dev libdb5.3-dbg libdb5.3-dev
````
````
mysql_secure_installation
````

 3. (Optional) apache and php
````
apt install -y php libapache2-mod-php php-cli php-fpm php-json php-pdo php-zip php-gd  php-mbstring php-curl php-xml php-pear php-bcmath php-cgi php-mysqli php-common php-phpseclib php-mysql
````
4. (optional) phpmyadmin
````
apt install -y phpmyadmin
````

# Compile
````cd /root/share/ ````
````make clean```` 
````make ````

````cd /root/share/io/ ````
````make lib````

````cd /root/cnet/gamed````
````make clean```` 
````make```` 

````cd /root/cnet/gdbclient````
````make clean```` 
````make```` 

````cd /root/cnet/logclient````
````make clean```` 
````make -f Makefile.gs clean````
````make -f Makefile.gs````

````cd /root/cskill````
````make clean````
````make````

````cd /root/cgame/libcm```` 
````make clean````
````make````

````cd /root/cgame````
````make clean````
````make````
    
