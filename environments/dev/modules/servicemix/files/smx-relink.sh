#!/bin/bash

if [ $# -ne 2 ]
then
	exit 255
fi

ORGDIR=$1
DIR=$2

if [ $(readlink $ORGDIR) = "$DIR" ]
then
	exit 0
fi


if [ -d ${DIR} ]
then
	echo "Relinking ${ORGDIR} to existing directory ${DIR}"
	rm -rf ${ORGDIR}
	ln -s ${DIR} ${ORGDIR}
	exit 0
fi

if [ ! -d $(dirname $DIR) ]
then
	mkdir -p $(dirname $DIR)
fi

if [ ! -e ${DIR} ] && [ -d ${ORGDIR} ]
then
	echo "Moving ${ORGDIR} to ${DIR} and creating symlink to ${ORGDIR}"
	service apache-servicemix stop >/dev/null 2>&1
	sleep 5
	
	mv -v ${ORGDIR} ${DIR}
	ln -s ${DIR} ${ORGDIR}
else
	echo "Unable to relink ${ORGDIR} to ${DIR}"
	exit 255
fi