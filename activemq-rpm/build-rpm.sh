#!/bin/bash

PKG="apache-activemq"
VERSION="5.13.0"
TARBALL="$PKG-$VERSION-bin.tar.gz"

echo "Building RPM for $PKG-$VERSION"

# Remove downloaded tar since we've modify it to contain service wrapper
if [ $TARBALL ]
then
        rm $TARBALL
fi

if [ ! -f $TARBALL ]
then
	curl http://apache.mirrors.spacedump.net/activemq/$VERSION/$TARBALL > $TARBALL

fi

echo -n "Patching specification..."
sed -i.bak -e s/__PKG/${PKG}/g -e s/__VERSION/${VERSION}/g apache-activemq.spec
echo " Done."

yum -y install rpmdevtools && rpmdev-setuptree
cp -v apache-activemq.spec ~/rpmbuild/SPECS/

cp -v $TARBALL ~/rpmbuild/SOURCES/
rpmbuild -bb ~/rpmbuild/SPECS/apache-activemq.spec
if [ $? -eq 0 ]
then
        cp -v /root/rpmbuild/RPMS/x86_64/apache-activemq-*.rpm .
fi

echo -n "Cleaning up..."
if [ apache-activemq.spec.bak ]; then
        rm apache-activemq.spec
        mv apache-activemq.spec.bak apache-activemq.spec
        echo " Done."
else
        echo " Nothing to do."
fi

