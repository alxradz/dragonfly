#!/bin/bash

ROOTDIR=`pwd`


#export SDK_DIR=/opt/arduino/arduino-1.0.x
export TOOLCHAIN=$ROOTDIR/tools/cmake_duino/ArduinoToolchain.cmake

function do_help() 
{
  echo -e "Usage:\t$0 (clean|cmake|make|remake) (Debug|Release|All)\n"
  exit 1		
}	

if [ "$#" != "2" ]; then
	do_help
fi

ACTION=$1
CONFIG=$2
TOOLS=gcc


function do_cmake()
{
	cd $ROOTDIR
	
	mkdir -p build/${TOOLS}/Release
	mkdir -p build/${TOOLS}/Debug	
	
	if [ "$TOOLS" = "clang" ]; then
		export CC=clang
		export CXX=clang++
	fi	

	if [ "$TOOLS" = "check" ]; then
		export CC=/usr/libexec/clang-analyzer/scan-build/ccc-analyzer
		export CXX=/usr/libexec/clang-analyzer/scan-build/c++-analyzer
	fi	
			
	if [ "$CONFIG" = "Debug" -o "$CONFIG" = "All" ]; then
		cmake -E chdir build/${TOOLS}/Debug \
			cmake -DCMAKE_BUILD_TYPE=Debug \
			-DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN \
			-G "Unix Makefiles" ../../..
	fi
	
	if [ "$CONFIG" = "Release" -o "$CONFIG" = "All" ]; then
		cmake -E chdir build/${TOOLS}/Release \
			cmake -DCMAKE_BUILD_TYPE=Release \
			-DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN \
			-G "Unix Makefiles" ../../..
	fi	
	
	cd $ROOTDIR	
}

function do_make()
{
	cd $ROOTDIR
	
	if [ "$CONFIG" = "Debug" -o "$CONFIG" = "All" ]; then
		cd build/${TOOLS}/Debug
		if [ "$TOOLS" = "check" ]; then
			scan-build -o check-report make -j4
		else
			make
		fi
	fi
	
	if [ "$CONFIG" = "Release" -o "$CONFIG" = "All" ]; then
		cd build/${TOOLS}/Release
		if [ "$TOOLS" = "check" ]; then
			scan-build -o check-report make -j4
		else
			make
		fi
	fi

	cd $ROOTDIR
}

function do_clean()
{
	cd $ROOTDIR

	if [ "$CONFIG" = "All" ]; then
		rm -fr build/${TOOLS}
		mkdir -p build/${TOOLS}/Release
		mkdir -p build/${TOOLS}/Debug
	fi

	if [ "$CONFIG" = "Debug" ]; then
		cd build/${TOOLS}/Debug
		make clean
	fi
			
	if [ "$CONFIG" = "Release" -o "$CONFIG" = "All" ]; then
		cd build/${TOOLS}/Release
		make clean
	fi

	cd $ROOTDIR
}


case "$1" in
"cmake")
	do_cmake
	;;	
"make")
	do_make
    ;;
"clean")
	do_clean
    ;;
"remake")
	do_clean
	do_cmake
	do_make
	;;
*)
	do_help
    ;;
esac

