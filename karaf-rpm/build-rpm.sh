#!/bin/bash

PKG="apache-karaf"
VERSION="4.0.4"
TARBALL="$PKG-$VERSION.zip"

echo "Building RPM for $PKG-$VERSION"

# Remove downloaded tar since we've modify it to contain service wrapper
if [ $TARBALL ]
then
	rm $TARBALL
fi

# Always start with a newly downloaded tarball
if [ ! -f $TARBALL ]
then
	curl http://www.eu.apache.org/dist/karaf/$VERSION/$TARBALL > $TARBALL
fi

sed -i.bak s/__PKG/${PKG}/g apache-karaf.spec
sed -i.bak s/__VERSION/${VERSION}/g apache-karaf.spec

yum -y install rpmdevtools && rpmdev-setuptree
cp -v apache-karaf.spec ~/rpmbuild/SPECS/

unzip -q $TARBALL

# Custom files to include
# These should be updated for each release
cp -v karaf-wrapper $PKG-$VERSION/bin
cp -v karaf-service $PKG-$VERSION/bin
cp -v karaf.service $PKG-$VERSION/bin
cp -v karaf-wrapper.conf $PKG-$VERSION/etc
mkdir -p $PKG-$VERSION/lib/wrapper
cp -v libwrapper.so $PKG-$VERSION/lib/wrapper
cp -v karaf-wrapper.jar $PKG-$VERSION/lib/wrapper
cp -v karaf-wrapper-main.jar $PKG-$VERSION/lib/wrapper

# Remove original
rm $TARBALL

# Package patched version as tarball
zip -rq $TARBALL $PKG-$VERSION
rm -rf $PKG-$VERSION

cp -v $TARBALL ~/rpmbuild/SOURCES/
rpmbuild -bb ~/rpmbuild/SPECS/apache-karaf.spec
if [ $? -eq 0 ]
then
        cp -v /root/rpmbuild/RPMS/x86_64/apache-karaf-*.rpm .
	rm -f *.bak
fi

