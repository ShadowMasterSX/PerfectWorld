#!/bin/bash
GS=`echo *game`;
NET=`echo *net`;
SKILL=`echo *skill`;
echo ""
echo "=========================== setup $NET ==========================="
echo ""
cd $NET
rm common
rm io
rm mk
rm storage
rm rpc
rm lua
rm rpcgen
ln -s ~/share/common/ .
ln -s ~/share/io/ .
ln -s ~/share/mk/ .
ln -s ~/share/storage/ .
ln -s ~/share/rpc/ .
ln -s ~/share/lua/ .
ln -s ~/share/rpcgen .
cd ..
echo ""
echo "=========================== setup iolib ==========================="
echo ""
if [ ! -d iolib ]; then
	mkdir iolib
fi;
cd iolib;
if [ ! -d inc ]; then
	mkdir inc
fi;
cd inc
rm *
ln -s ../../$NET/gamed/auctionsyslib.h
ln -s ../../$NET/gamed/sysauctionlib.h 
ln -s ../../$NET/gdbclient/db_if.h
ln -s ../../$NET/gamed/factionlib.h
ln -s ../../$NET/common/glog.h
ln -s ../../$NET/gamed/gsp_if.h
ln -s ../../$NET/gamed/mailsyslib.h
ln -s ../../$NET/gamed/privilege.hxx
ln -s ../../$NET/gamed/sellpointlib.h
ln -s ../../$NET/gamed/stocklib.h
ln -s ../../$NET/gamed/webtradesyslib.h
ln -s ../../$NET/gamed/kingelectionsyslib.h
ln -s ../../$NET/gamed/pshopsyslib.h
ln -s ../../$NET/gdbclient/db_os.h
ln -s /root/share/io/luabase.h

cd ..
rm lib*
ln -s ../$NET/io/libgsio.a
ln -s ../$NET/gdbclient/libdbCli.a
ln -s /root/cskill/skill/libskill.a
ln -s ../$NET/gamed/libgsPro2.a
ln -s ../$NET/logclient/liblogCli.a
cd ..
echo ""
echo "======================== modify Rules.make ========================"
echo ""
EPWD=`pwd|sed -e 's/\//\\\\\//g'`;
cd $GS
sed -i -e "s/IOPATH=.*$/IOPATH=$EPWD\/iolib/g" -e "s/BASEPATH=.*$/BASEPATH=$EPWD\/$GS/g" Rules.make
echo ""
echo "====================== softlink libskill.so ======================="
echo ""
cd gs
rm libskill.so
ln -s ../../cskill/libskill.so 
cd ../../

buildrpcgen()
{
	echo ""
	echo "========================== $NET rpcgen ============================"
	echo ""
	cd $NET
	./rpcgen rpcalls.xml
	cd ..
}

buildrpcdata()
{
	echo ""
	echo "========================== $NET CP rpcdata ============================"
	echo ""
	#cp ./add/ec_sqlarenateammember /root/cnet/rpcdata/ec_sqlarenateammember
	#cp ./add/ec_sqlarenateam /root/cnet/rpcdata/ec_sqlarenateam
}


installfunc()
{
	echo ""
	echo "======================= Instalando as deamons ========================="
	echo ""
	cp ./cgame/gs/gs /home/gamed/gs
	cp ./cgame/gs/libtask.so /home/gamed/libtask.so
	cp ./cskill/libskill.so /home/gamed/libskill.so
	cp ./cnet/gfaction/gfactiond /home/gfactiond/gfactiond
	cp ./cnet/gauthd/gauthd /home/gauthd/gauthd
	cp ./cnet/uniquenamed/uniquenamed /home/uniquenamed/uniquenamed
	cp ./cnet/gamedbd/gamedbd /home/gamedbd/gamedbd
	cp ./cnet/gdeliveryd/gdeliveryd /home/gdeliveryd/gdeliveryd
	cp ./cnet/glinkd/glinkd /home/glinkd/glinkd
	cp ./cnet/gacd/gacd /home/gacd/gacd
	cp ./cnet/logservice/logservice /home/logservice/logservice
	echo ""
	echo "============================== Sucesso!! ==============================="
	echo ""

}

installprotectfunc()
{
	echo ""
	echo "======================= Movendo ========================="
	echo ""
	cp ./cgame/gs/gs /root/get_protects/gs
	cp ./cnet/gfaction/gfactiond /root/get_protects/gfactiond
	cp ./cnet/gauthd/gauthd /root/get_protects/gauthd
	cp ./cnet/uniquenamed/uniquenamed /root/get_protects/uniquenamed
	cp ./cnet/gamedbd/gamedbd /root/get_protects/gamedbd
	cp ./cnet/gdeliveryd/gdeliveryd /root/get_protects/gdeliveryd
	cp ./cnet/glinkd/glinkd /root/get_protects/glinkd
	echo ""
	echo "====================== Sucesso =========================="
	echo ""

}


buildgslib()
{
	# Build rpcgen
	# Comments in buildgslib()
	# No compilation for libgsio.a, it's in the shared library, compiled once and doesn't change
	# No compilation for libTrace.a, it's in qgame_dev/qgame/collision, compiled once and doesn't change
	echo "======================= build liblogCli.a ========================="
	echo ""
	cd $NET
	cd logclient
	make clean
	make -f Makefile.gs clean
	make -f Makefile.gs -j32
	cd ..
	echo ""
	echo "======================== build libgsPro2.a ========================="
	echo ""
	cd gamed
	make clean
	make lib -j32
	cd ..
	echo ""
	echo "======================== build libdbCli.a =========================="
	echo ""
	cd gdbclient
	make clean
	make lib -j32
	cd ..
	cd ..
	echo ""
	echo "============================ make libgs ============================"
	echo ""
	cd $GS
	cd libgs
	mkdir -p io
	mkdir -p gs
	mkdir -p db
	mkdir -p sk
	mkdir -p log
	make
	cd ../../
}

buildskill()
{
	echo ""
	echo "============================= ant gen =============================="
	echo ""
	cd cskill/skill
	cd gen
	if [ ! -d skills ]; then
		mkdir skills
	fi
	if [ ! -d buffcondition ]; then
		mkdir buffcondition
	fi
	ant
	echo ""
	echo "========================== gen skils =============================="
	echo ""
	chmod a+x gen
#	./gen
	echo ""
	echo "======================= build libskills.o ========================="
	echo ""
	make clean
	make -j32
	cd ../
}

buildgame()
{

	echo ""
	echo "======================= build cgame ========================="
	echo ""
	cd ~/cgame
#	cvs up
	make clean
	make -j32	
	cd ../
}

buildtask()
{

	echo ""
	echo "======================= build libtask.o ========================="
	echo ""
	cd ~/
	cd $GS
	cd gs
	cd task
	make clean
	make lib -j32
	cd ../../../
}

builddeliver() # Ã‡Â°Â¸Ãºrpcgen
{
	cd $NET

	echo ""
	echo "========================== build licenseclient =============================="
	echo ""
	cd licenseclient
	make clean
	make -j32
	make lib
	cd ..

	echo ""
	echo "========================== build gauthd =============================="
	echo ""
	cd gauthd
	make clean
	make -j32
	cd ..

	echo ""
	echo "========================== build logservice =============================="
	echo ""
	cd logservice
	make clean
	make -j32
	cd ..

	echo ""
	echo "========================== build gacd =============================="
	echo ""
	cd gacd
	make clean
	make -j32
	cd ..

	echo ""
	echo "========================== build glinkd =============================="
	echo ""
	cd glinkd
	make clean
	make -j32
	cd ..

	echo ""
	echo "========================== build gdeliveryd =============================="
	echo ""
	cd gdeliveryd
	make clean
	make -j32
	cd ..

	echo ""
	echo "========================== build gamedbd =============================="
	echo ""
	cd gamedbd
	make clean
	make -j32
	cd ..

	echo ""
	echo "========================== build uniquenamed =============================="
	echo ""
	cd uniquenamed
	make clean
	make -j32
	cd ..

	echo ""
	echo "========================== build libgsio =============================="
	echo ""
	cd $NET
	cd io
	make lib -j32
	cd ..

	echo ""
	echo "========================== build gfaction =============================="
	echo ""
	cd gfaction
	make clean
	make -j32
	cd ..
}

builddeliveryd()
{
	cd $NET
	echo ""
	echo "========================== build gdeliveryd =============================="
	echo ""
	cd gdeliveryd
	make clean
	make -j32
	cd ..

	echo ""
	echo "========================== build gamedbd =============================="
	echo ""
	cd gamedbd
	make clean
	make -j32
	cd ..

	echo ""
	echo "========================== build uniquenamed =============================="
	echo ""
	cd uniquenamed
	make clean
	make -j32
	cd ..

	echo ""
	echo "========================== build libgsio =============================="
	echo ""
	cd $NET
	cd io
	make lib -j32
	cd ..

	echo ""
	echo "========================== build gfaction =============================="
	echo ""
	cd gfaction
	make clean
	make -j32
	cd ..

	echo ""
	echo "========================== build gacd =============================="
	echo ""
	cd gacd
	make clean
	make -j32
	cd ..

}


buildgs()
{
	echo ""
	echo "========================== build gs =============================="
	echo ""
	cd $GS
	cd gs
	make clean
	make -j32
	cd ../../
}

rebuilddeliver()
{
	rpcgen;
	#buildrpcdata;
	builddeliver;
}

rebuilddeliver2()
{
	builddeliver;
}

rebuildgs()
{
	#buildrpcdata;
	buildgslib;
}

rebuildall()
{
	echo ""
	echo "========================== build game all =============================="
	echo ""

	buildrpcgen;
	buildrpcdata;
	builddeliver;
	buildgslib;
	buildskill;
	buildgame;
	installfunc;
	installprotectfunc;
}

install()
{
	echo ""
	echo "========================== Installing.... =============================="
	echo ""

	installfunc;
	installprotectfunc;
}


if [ $# -gt 0 ]; then
	if [ "$1" = "deliver" ]; then
		rebuilddeliver;
	elif [ "$1" = "gs" ]; then
		rebuildgs;
	elif [ "$1" = "all" ]; then
		rebuildall;
	elif [ "$1" = "install" ]; then
		install;
	elif [ "$1" = "deliveryd" ]; then
		rebuilddeliver2;

	fi
fi
