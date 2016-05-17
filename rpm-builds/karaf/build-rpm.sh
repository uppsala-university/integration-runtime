#!/bin/bash

PKG="apache-karaf"
MAJOR_MINOR="4.0"
PATCH="5"
VERSION="$MAJOR_MINOR.$PATCH"
TARBALL="$PKG-$VERSION.zip"
ARCHITECTURE="x86_64"
RESOURCE="http://www.eu.apache.org/dist/karaf"
SPEC="$PKG.spec"

echo "Building RPM for $PKG-$VERSION ($ARCHITECTURE)"

# Remove downloaded tar since we've modify it to contain service wrapper
if [ $TARBALL ]
then
	rm $TARBALL
fi

# Always start with a newly downloaded tarball
if [ ! -f $TARBALL ]
then
	curl $RESOURCE/$VERSION/$TARBALL > $TARBALL
fi

echo -n "Patching specification..."
sed -i.bak -e s/__PKG/${PKG}/g -e s/__VERSION/${VERSION}/g $SPEC
echo " Done."

yum -y install rpmdevtools zip && rpmdev-setuptree
cp -v $SPEC ~/rpmbuild/SPECS/

unzip -q $TARBALL

# Patch downloaded package with service wrapper
cp -R $MAJOR_MINOR.x/* $PKG-$VERSION/

# Remove original
rm $TARBALL

# Package patched version as tarball
zip -rq $TARBALL $PKG-$VERSION
rm -rf $PKG-$VERSION

cp -v $TARBALL ~/rpmbuild/SOURCES/
rpmbuild -bb ~/rpmbuild/SPECS/$SPEC
if [ $? -eq 0 ]
then
        cp -v /root/rpmbuild/RPMS/$ARCHITECTURE/$PKG-$VERSION-*.rpm .
fi

echo -n "Cleaning up..."
if [ -f $SPEC.bak ]; then
        rm $SPEC
        mv $SPEC.bak $SPEC
        echo " Done."
else
        echo " Nothing to do."
fi
if [ -f $PKG-$VERSION.zip ]; then
	rm $PKG-$VERSION.zip
fi
