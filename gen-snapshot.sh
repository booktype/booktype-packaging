#/bin/sh
# Script for generating nightly Booktype snapshot packages
# Set GITPATH to the directory containing the Booktype source
# Set PKGPATH to the directory containing the packaging scripts

UPSTREAM=2.4.0
VERSION=2.4.0~$(date "+%Y%m%d")
REVISION=1
GITPATH=/opt/booktype/
PKGPATH=/opt/booktype-packaging/
BUILDDEST=/tmp/booktype-${VERSION}/
ORIGBALL=/tmp/booktype_${VERSION}.orig.tar.gz

echo "cleaning up previous build..."

rm -rf /tmp/booktype*
mkdir ${BUILDDEST}

echo "fetching the latest packaging files..."

cd ${PKGPATH}
git checkout sourcefabric
git pull origin sourcefabric

echo "fetching the latest Booktype files..."

cd ${GITPATH}
git checkout master
git pull origin master

echo "copying Booktype files to temporary directory..."

cp -a * ${BUILDDEST} || exit

echo "making fixes for Booktype 2.4.0..."

cd ${BUILDDEST} || exit

# moved to debian/copyright
rm LICENSE.txt
rm lib/booktype/apps/edit/static/edit/js/aloha/plugins/common/align/LICENSE
rm lib/booktype/apps/edit/static/edit/js/aloha/plugins/extra/flag-icons/img/flags/LICENSE

# fix permissions
chmod -x lib/booktype/apps/core/static/vendor/bootstrap-3.3.7/js/affix.js
chmod -x lib/booktype/apps/core/static/vendor/bootstrap-3.3.7/fonts/glyphicons-halflings-regular.woff
chmod -x lib/booktype/apps/core/static/vendor/bootstrap-3.3.7/fonts/glyphicons-halflings-regular.svg
chmod -x lib/booktype/apps/core/static/vendor/bootstrap-3.3.7/js/carousel.js
chmod -x lib/booktype/apps/core/static/vendor/bootstrap-3.3.7/js/modal.js
chmod -x lib/booktype/apps/core/static/vendor/bootstrap-3.3.7/js/tooltip.js
chmod -x lib/booktype/apps/core/static/vendor/bootstrap-3.3.7/js/tab.js
chmod -x lib/booktype/apps/core/static/vendor/bootstrap-3.3.7/js/alert.js
chmod -x lib/booktype/apps/core/static/vendor/bootstrap-3.3.7/fonts/glyphicons-halflings-regular.eot
chmod -x lib/booktype/apps/core/static/vendor/bootstrap-3.3.7/fonts/glyphicons-halflings-regular.woff2
chmod -x lib/booktype/apps/core/static/vendor/bootstrap-3.3.7/js/collapse.js
chmod -x lib/booktype/apps/core/static/vendor/bootstrap-3.3.7/js/scrollspy.js
chmod -x lib/booktype/apps/core/static/vendor/bootstrap-3.3.7/js/popover.js
chmod -x lib/booktype/apps/core/static/vendor/bootstrap-3.3.7/js/dropdown.js
chmod -x lib/booktype/apps/core/static/vendor/bootstrap-3.3.7/js/button.js
chmod -x lib/booktype/apps/core/static/vendor/bootstrap-3.3.7/fonts/glyphicons-halflings-regular.ttf
chmod -x lib/booktype/apps/core/static/vendor/clipboardjs-1.6.1/js/clipboard.min.js
chmod -x lib/booktype/apps/core/static/vendor/bootstrap-3.3.7/js/transition.js
chmod -x lib/booktype/apps/core/static/vendor/bootstrap-3.3.7/css/bootstrap.min.css.map
chmod -x lib/booktype/apps/core/static/vendor/bootstrap-3.3.7/css/bootstrap.min.css

echo "creating the source tarball..."
tar -cvzf ${ORIGBALL} *

echo "copying the packaging files..."
cp -a ${PKGPATH}debian ${BUILDDEST} || exit

# Set the version of the snapshot package

sed -i "1s:(${UPSTREAM}-${REVISION}):(${VERSION}-${REVISION}):g" debian/changelog

#############################

echo "running the build..."

debuild -d -i -uc -us -b $@ || exit

# copy the new package to the public server
# scp /tmp/booktype_${VERSION}-${REVISION}_all.deb apt.sourcefabric.org:/var/www/apt/snapshots/

# copy the build log and changes too
# scp /tmp/booktype_${VERSION}-${REVISION}_amd64.build apt.sourcefabric.org:/var/www/apt/snapshots/
# scp /tmp/booktype_${VERSION}-${REVISION}_amd64.changes apt.sourcefabric.org:/var/www/apt/snapshots/
