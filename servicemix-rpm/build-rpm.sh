#!/bin/bash

PKG="apache-servicemix"
VERSION="6.0.0"
TARBALL="$PKG-$VERSION.zip"

echo "Building RPM for $PKG-$VERSION"

if [ ! -f $TARBALL ]
then
	curl http://www.eu.apache.org/dist/servicemix/servicemix-6/$VERSION/$TARBALL > $TARBALL
fi

sed -i.bak -e s/__PKG/${PKG}/g -e s/__VERSION/${VERSION}/g apache-servicemix.spec
sed -i.bak -e s/__PKG/${PKG}/g -e s/__VERSION/${VERSION}/g apache-servicemix.init

yum -y install rpmdevtools && rpmdev-setuptree
cp -v apache-servicemix.spec ~/rpmbuild/SPECS/
cp -v apache-servicemix.init ~/rpmbuild/SOURCES/
cp -v $TARBALL ~/rpmbuild/SOURCES/
rpmbuild -bb ~/rpmbuild/SPECS/apache-servicemix.spec
if [ $? -eq 0 ]
then
        cp -v /root/rpmbuild/RPMS/noarch/apache-servicemix-*.rpm .
		rm -f *.bak
fi

