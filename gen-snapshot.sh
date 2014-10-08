#/bin/sh
# Script for generating nightly Booktype snapshot packages
# Set GITPATH to the directory containing the Booktype source
# Set PKGPATH to the directory containing the packaging scripts

VERSION=2.0.0~$(date "+%Y%m%d")
REVISION=1
GITPATH=~/64studio/git/booktype/
PKGPATH=~/64studio/git/booktype-packaging/
BUILDDEST=/tmp/booktype-${VERSION}/
ORIGBALL=/tmp/booktype_${VERSION}.orig.tar.gz

echo "cleaning up previous build..."

rm -rf /tmp/booktype-*
mkdir ${BUILDDEST}

echo "copying Booktype files to temporary directory..."

cd ${GITPATH}
git checkout 2.0
git pull origin 2.0
cp -a * ${BUILDDEST} || exit

cd ${BUILDDEST} || exit

# Build the documentation then move it into place

python setup.py build_sphinx
rm -r docs/_build
mv build docs/_build

echo "creating the source tarball..."
tar -cvzf ${ORIGBALL} *

echo "copying the packaging files..."
cp -a ${PKGPATH}debian ${BUILDDEST} || exit

# Set the version of the snapshot package

sed -i "1s:(2.0.0-1):(${VERSION}-${REVISION}):g" debian/changelog

# Fixes for 2.0.0  #############

# moved to debian/copyright
rm LICENSE.txt
rm lib/booktype/apps/edit/static/edit/js/aloha/plugins/common/align/LICENSE
rm lib/booktype/apps/edit/static/edit/js/aloha/plugins/extra/flag-icons/img/flags/LICENSE

# fix permissions
chmod +x scripts/cron_reports.sh.original
chmod +x scripts/cron_reports_weekly.sh.original
chmod +x lib/booktype/skeleton/manage.py.original
chmod +x lib/sputnik/redis-backuo.py

#############################

echo "running the build..."

debuild -d -uc -us $@ || exit

# copy the new package to the public server
# scp /tmp/booktype_${VERSION}-${REVISION}_all.deb apt.sourcefabric.org:/var/www/apt/snapshots/

# copy the build log and changes too
# scp /tmp/booktype_${VERSION}-${REVISION}_amd64.build apt.sourcefabric.org:/var/www/apt/snapshots/
# scp /tmp/booktype_${VERSION}-${REVISION}_amd64.changes apt.sourcefabric.org:/var/www/apt/snapshots/
