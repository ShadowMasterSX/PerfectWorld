# PerfectWorld  up to 1.7.8 by Sranus (C) 2025
works on Debian 11 12  and ubuntu 22 24
## How to install on  Debian 11 12  and Ubuntu 22 24

1. add the 32bit Libery and update your Server
````
  dpkg --add-architecture i386; apt update; apt upgrade -y
````
2. install the base liberies and software
````
apt-get install -y mc screen htop default-jdk mono-complete exim4 p7zip-full libpcap-dev curl wget ipset net-tools tzdata ntpdate mariadb-server mariadb-client
````
````
apt-get install -y make gcc g++ libssl-dev:i386 libssl-dev libcrypto++-dev libpcre3 libpcre3-dev libpcre3:i386 libpcre3-dev:i386 libtesseract-dev libx11-dev:i386 libx11-dev gcc-multilib libc6-dev:i386 build-essential gcc-multilib g++-multilib libtemplate-plugin-xml-perl libxml2-dev libxml2-dev:i386 libxml2:i386 libstdc++6:i386 libmariadb-dev-compat libmariadb-dev
````
````
apt-get install -y libdb++-dev libdb-dev libdb5.3 libdb5.3++ libdb5.3++-dev libdb5.3-dbg libdb5.3-dev
````
2.1. setup MariaDB

````
mysql_secure_installation
````

3. (Optional) apache and php
````
apt-get install -y apache2 php  php-cli php-fpm php-json php-pdo php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath php-cgi php-mysqli php-common php-phpseclib php-mysql
````
4. (optional) phpmyadmin (not secure for Live Server)
````
apt-get install phpmyadmin
````
## Only if you have the Source
# Compile
````cd /root/ ````
````nano build.sh```` 
````#!/bin/bash

BASE="/root/"
GS="/root/cgame"
NET="/root/cnet/"
SKILL="/root/cskill/"
PWI="/home/"
LOG_DIR="/root/logs/"

mkdir -p $LOG_DIR

function setup_net {
  echo "\n=========================== Setting up $NET ===========================\n"
  cd $NET || exit 1
  rm -f common io perf mk storage rpc rpcgen lua
  ln -s $BASE/share/{common,io,perf,mk,storage,rpc,rpcgen,lua} .
  cd ..
}

function setup_iolib {
  echo "\n=========================== Setting up iolib ===========================\n"
  mkdir -p iolib/inc
  cd iolib/inc || exit 1
  rm -f *
  ln -s $NET/gamed/{auctionsyslib.h,sysauctionlib.h,factionlib.h,gsp_if.h,mailsyslib.h,privilege.hxx,sellpointlib.h,stocklib.h,webtradesyslib.h,kingelectionsyslib.h,pshopsyslib.h} .
  ln -s $NET/{common/glog.h,io/luabase.h,gdbclient/db_if.h} .
  cd $BASE || exit 1
  rm -f lib*
  ln -s $NET/{io/libgsio.a,gdbclient/libdbCli.a,gamed/libgsPro2.a,logclient/liblogCli.a} .
  ln -s $SKILL/libskill.a .
  cd ..
}

function modify_rules {
  echo "\n======================== Modifying Rules.make =======================\n"
  EPWD=$(pwd | sed -e 's/\//\\\//g')
  cd $GS || exit 1
  sed -i -e "s|IOPATH=.*$|IOPATH=$EPWD/iolib|" -e "s|BASEPATH=.*$|BASEPATH=$EPWD/$GS|" Rules.make
}

function build_rpcgen {
  echo "\n========================== Building rpcgen ============================\n"
  cd $NET || exit 1
  ./rpcgen rpcalls.xml > "$LOG_DIR/rpcgen.log" 2>&1
}

function build_libs {
  echo "\n======================== Building Libraries =========================\n"
  for lib in logclient gamed gdbclient; do
    echo "Building $lib..."
    cd $NET/$lib || exit 1
    make -j$(nproc) > "$LOG_DIR/${lib}_build.log" 2>&1
  done
  echo "\nBuilding shared libraries..."
  cd $GS/libgs || exit 1
  mkdir -p io gs db sk log
  make > "$LOG_DIR/libgs_build.log" 2>&1
}

function clean_all {
  echo "\n======================== Cleaning All Builds =========================\n"
  for lib in logclient gamed gdbclient; do
    echo "Cleaning $lib..."
    cd $NET/$lib || exit 1
    make clean > "$LOG_DIR/${lib}_clean.log" 2>&1
  done
  echo "Cleaning shared libraries..."
  cd $GS/libgs || exit 1
  make clean > "$LOG_DIR/libgs_clean.log" 2>&1
  echo "Cleaning skills..."
  
  make clean > "$LOG_DIR/skill_clean.log" 2>&1
  echo "Cleaning game..."
  cd $BASE || exit 1
  make clean > "$LOG_DIR/game_clean.log" 2>&1
}

function build_skill {
  echo "\n========================== Building Skill ===========================\n"
  mkdir -p skills buffcondition
  cd $BASE || exit 1
  make -j$(nproc) > "$LOG_DIR/skill_build.log" 2>&1
}

function build_game {
  echo "\n========================== Building Game ===========================\n"
  cd $BASE || exit 1
  make -j$(nproc) > "$LOG_DIR/game_build.log" 2>&1
}

function make_bin {
  echo "\n========================== Creating Binaries =======================\n"
  mkdir -p $BASE/build
  cp -rf $BASE/cgame/gs/{gs,libtask.so} $BASE/build/
  cp -rf $SKILL/libskill.so $BASE/build/
  cp -rf $NET/{gacd/gacd,gamedbd/{gamedbd,cashstat},gauthd/gauthd,gdeliveryd/gdeliveryd,gfaction/gfactiond,glinkd/glinkd,uniquenamed/uniquenamed} $BASE/build/
}

function install_binaries {
  echo "\n======================== Installing Binaries ========================\n"
  declare -A install_map
  install_map["$BASE/build/gs"]="$PWI/gamed/"
  install_map["$BASE/build/libtask.so"]="$PWI/gamed/"
  install_map["$BASE/build/libskill.so"]="$PWI/gamed/"
  install_map["$BASE/build/libtask.so"]="/usr/lib/"
  install_map["$BASE/build/libskill.so"]="/usr/lib//"
  install_map["$BASE/build/gacd"]="$PWI/gacd/"
  install_map["$BASE/build/gamedbd"]="$PWI/gamedbd/"
  install_map["$BASE/build/cashstat"]="$PWI/gamedbd/"
  install_map["$BASE/build/gauthd"]="$PWI/gauthd/"
  install_map["$BASE/build/gdeliveryd"]="$PWI/gdeliveryd/"
  install_map["$BASE/build/gfactiond"]="$PWI/gfactiond/"
  install_map["$BASE/build/glinkd"]="$PWI/glinkd/"
  install_map["$BASE/build/uniquenamed"]="$PWI/uniquenamed/"

  for source in "${!install_map[@]}"; do
    dest="${install_map[$source]}"
    if [ ! -d "$dest" ]; then
        echo "Creating directory: $dest"
      mkdir -p "$dest"
      if [ $? -ne 0 ]; then
        echo "Failed to create directory: $dest"
        return 1
      fi
    fi
    echo "Copying $source to $dest"
    cp -rf "$source" "$dest" || { echo "Failed to copy $source to $dest"; return 1; }
  done
}

function rebuild_all {
  echo "\n========================== Full Rebuild =============================\n"
  build_rpcgen
  setup_net
  setup_iolib
  modify_rules
  build_libs
  build_skill
  build_game
  make_bin
  install_binaries
}

function display_menu {
  echo "\nPlease select an option:\n"
  echo "1) Deliver"
  echo "2) GS"
  echo "3) Rebuild All"
  echo "4) Create Binaries"
  echo "5) Install Binaries"
  echo "6) Clean All"
  echo "0) Exit"
  read -rp "Enter your choice: " choice

  case $choice in
    1)
      build_rpcgen
      build_libs
      ;;
    2)
      modify_rules
      build_libs
      ;;
    3)
      rebuild_all
      ;;
    4)
      make_bin
      ;;
    5)
      install_binaries
      ;;
    6)
      clean_all
      ;;
    0)
      echo "Exiting..."
      exit 0
      ;;
    *)
      echo "Invalid option. Please try again."
      display_menu
      ;;
  esac
}

if [ $# -eq 0 ]; then
  display_menu
else
  case "$1" in
    "deliver")
      build_rpcgen
      build_libs
      ;;
    "gs")
      modify_rules
      build_libs
      ;;
    "all")
      rebuild_all
      ;;
    "bin")
      make_bin
      ;;
    "install")
      install_binaries
      ;;
    "clean")
      clean_all
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
fi 
````


````chmod +x build.sh````

````sh build.sh````
    
