#!/bin/bash

PKG="apache-karaf"
VERSION="4.0.4"
TARBALL="$PKG-$VERSION.zip"

echo "Building RPM for $PKG-$VERSION"

if [ ! -f $TARBALL ]
then
	curl http://www.eu.apache.org/dist/karaf/$VERSION/$TARBALL > $TARBALL
fi

sed -i.bak s/__PKG/${PKG}/g apache-karaf.spec
sed -i.bak s/__VERSION/${VERSION}/g apache-karaf.spec

yum -y install rpmdevtools && rpmdev-setuptree
cp -v apache-karaf.spec ~/rpmbuild/SPECS/
#cp -v apache-karaf.init ~/rpmbuild/SOURCES/
# Custom files to include
cp -v karaf-wrapper ~/rpmbuild/SOURCES/
cp -v karaf-service ~/rpmbuild/SOURCES/
cp -v karaf.service ~/rpmbuild/SOURCES/
cp -v karaf-wrapper.conf ~/rpmbuild/SOURCES/
cp -v libwrapper.so ~/rpmbuild/SOURCES/
cp -v karaf-wrapper.jar ~/rpmbuild/SOURCES/
cp -v karaf-wrapper-main.jar ~/rpmbuild/SOURCES/

cp -v $TARBALL ~/rpmbuild/SOURCES/
rpmbuild -bb ~/rpmbuild/SPECS/apache-karaf.spec
if [ $? -eq 0 ]
then
        cp -v /root/rpmbuild/RPMS/noarch/apache-karaf-*.rpm .
		rm -f *.bak
fi

