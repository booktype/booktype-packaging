#/bin/sh
# Script for generating nightly Booktype snapshot packages
# Set GITPATH to the directory containg the Booktype source

VERSION=2.0.0~$(date "+%Y%m%d")
REVISION=1
GITPATH=../booktype/
BUILDDEST=/tmp/booktype-${VERSION}/
ORIGBALL=/tmp/booktype_${VERSION}.orig.tar.gz

echo "cleaning up previous build..."

rm -rf /tmp/booktype-*
mkdir ${BUILDDEST}

echo "copying files to temporary directory..."

cp -a debian ${BUILDDEST} || exit

cd ${GITPATH}
git checkout 2.0
git pull origin 2.0
cp -a * ${BUILDDEST} || exit

echo "creating the source tarball..."
tar -cvzf ${ORIGBALL} ${GITPATH}

cd ${BUILDDEST} || exit

# Build the documentation then move it out of the way

python setup.py build_sphinx
mv build/ _build/
rm -r docs/_build/
mv _build/ docs/

# Strip the bundled Awesome font, it is a dependency
rm -r lib/booktype/apps/core/static/core/css/font-awesome/css/
rm -r lib/booktype/apps/core/static/core/css/font-awesome/font/

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
# scp /tmp/booktype_${VERSION}_all.deb apt.sourcefabric.org:/var/www/apt/snapshots/

# copy the build log too
# scp /tmp/booktype_${VERSION}_amd64.build apt.sourcefabric.org:/var/www/apt/snapshots/
