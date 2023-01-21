#!/bin/bash
set -e

if [[ $# -ne 2 ]]; then
	echo "Usage: $0 <build_dir> <console_dump>"
	exit
fi

if [ -n "${CROSS_COMPILE}" ]; then
	GCOV=${CROSS_COMPILE}/gcov
else
	GCOV=$(which gcov)
fi

if [ -z "$GCOV" ]; then
	echo "$0: Could not find gcov"
	exit
fi

BUILD_DIR=$(realpath $1)
CONSOLE_DUMP=$(realpath $2)
GCOV_DIR=${BUILD_DIR}/libembeddedgcov/origin/ # FIXME assumes path to gcov

cd ${GCOV_DIR}/scripts

rm -rf ../objs/*
rm -rf ../results/*

# FIXME causes warning about same files
find $BUILD_DIR -name \*.gcno -exec cp {} ../objs/ \;

lcov --gcov-tool ${CROSS_COMPILE}gcov --capture --initial \
     --directory ../objs/ -o ../results/baseline.info

./gcov_convert.sh $CONSOLE_DUMP
./lcov_newcoverage.sh
./lcov_combine_new_base.sh
./genhtml_report.sh

echo -e "\nlcov report in file://$(realpath ../results/html)/index.html\n"
