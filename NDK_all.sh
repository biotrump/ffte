#!/bin/bash
if [ $TARGET_ARCH == "all" ]; then
	./build_NDK_cmake.sh -abi armeabi -acc generic -c
	ret1=$?
	#echo "ret1=$ret1"
	#read
	./build_NDK_cmake.sh -abi armeabi-v7a -acc generic -c
	ret2=$?
	#echo "ret2=$ret2"
	#read
	./build_NDK_cmake.sh -abi arm64-v8a -acc generic -c
	ret3=$?
	#echo "ret3=$ret3"
	#read
	./build_NDK_cmake.sh -abi x86 -acc generic -c
	ret4=$?
	#echo "ret4=$ret4"
	#read
	./build_NDK_cmake.sh -abi x86_64 -acc generic -c
	ret5=$?
	#echo "ret5=$ret5"
	#read
	./build_NDK_cmake.sh -abi mips -acc generic -c
	ret6=$?
	#echo "ret6=$ret6"
	#read
	./build_NDK_cmake.sh -abi mips64 -acc generic -c
	ret7=$?
	#echo "ret7=$ret7"
	#read

	if [ "$ret1" != "0" -o \
		"$ret2" != "0" -o \
		"$ret3" != "0" -o \
		"$ret4" != "0" -o \
		"$ret5" != "0" -o \
		"$ret6" != "0" -o \
		"$ret7" != "0" ]; then
	#		echo "11111"
			exit -1
	fi
else
	./build_NDK_cmake.sh -abi $TARGET_ARCH -c
	ret1=$?
	#echo "ret1=$ret1"
	#read
	if [ "$ret1" != "0" ]; then
		exit -1
	fi
fi
#echo "00000"
exit 0
