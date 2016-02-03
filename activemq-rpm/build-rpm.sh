#!/bin/bash

PKG="apache-activemq"
VERSION="5.13.0"
TARBALL="$PKG-$VERSION-bin.tar.gz"

echo "Building RPM for $PKG-$VERSION"

if [ ! -f $TARBALL ]
then
	curl http://apache.mirrors.spacedump.net/activemq/$VERSION/$TARBALL > $TARBALL

fi

sed -i.bak -e s/__PKG/${PKG}/g -e s/__VERSION/${VERSION}/g apache-activemq.spec

yum -y install rpmdevtools && rpmdev-setuptree
cp -v apache-activemq.spec ~/rpmbuild/SPECS/

cp -v $TARBALL ~/rpmbuild/SOURCES/
rpmbuild -bb ~/rpmbuild/SPECS/apache-activemq.spec
if [ $? -eq 0 ]
then
        cp -v /root/rpmbuild/RPMS/x86_64/apache-activemq-*.rpm .
	rm -f *.bak
fi

