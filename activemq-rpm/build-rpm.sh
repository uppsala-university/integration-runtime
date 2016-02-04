#!/bin/bash

PKG="apache-activemq"
VERSION="5.13.0"
TARBALL="$PKG-$VERSION-bin.tar.gz"
ARCHITECTURE="x86_64"
RESOURCE="http://apache.mirrors.spacedump.net/activemq"
SPEC="$PKG.spec"

echo "Building RPM for $PKG-$VERSION"

# Start with fresh source, remove previous if exists.
if [ -f $TARBALL ]
then
        rm $TARBALL
fi

if [ ! -f $TARBALL ]
then
	curl $RESOURCE/$VERSION/$TARBALL > $TARBALL

fi

echo -n "Patching specification..."
sed -i.bak -e s/__PKG/${PKG}/g -e s/__VERSION/${VERSION}/g $SPEC
echo " Done."

yum -y install rpmdevtools && rpmdev-setuptree
cp -v $SPEC ~/rpmbuild/SPECS/

cp -v $TARBALL ~/rpmbuild/SOURCES/
rpmbuild -bb ~/rpmbuild/SPECS/$SPEC
if [ $? -eq 0 ]
then
	cp -v /root/rpmbuild/RPMS/$ARCHITECTURE/$PKG-*.rpm .
fi

echo -n "Cleaning up..."
if [ $SPEC.bak ]; then
        rm $SPEC
        mv $SPEC.bak $SPEC
        echo " Done."
else
        echo " Nothing to do."
fi

