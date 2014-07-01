#/bin/sh
# Script for generating nightly Booktype snapshot packages
# Set GITPATH to the directory containg the Booktype source

VERSION=2.0.0~$(date "+%Y%m%d")
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
tar -cvzf ${ORIGBALL} ${GITPATH}

cd ${BUILDDEST} || exit

# Build the documentation then move it out of the way

python setup.py build_sphinx
mv build/ _build/
rm -r docs/_build/
mv _build/ docs/

# Set the version of the snapshot package

sed -i "1s:(2.0.0-1):(${VERSION}):g" debian/changelog

# Fixes for 2.0.0  #############

# moved to debian/copyright
rm LICENSE.txt
rm lib/booktype/apps/edit/static/edit/js/aloha/plugins/common/align/LICENSE
rm lib/booktype/apps/edit/static/edit/js/aloha/plugins/extra/flag-icons/img/flags/LICENSE

# fix permissions
chmod +x scripts/cron_reports.sh.original
chmod +x scripts/cron_reports_weekly.sh.original
chmod -x lib/booktype/apps/edit/static/edit/js/aloha/plugins/oer/format/nls/it/i18n.js
chmod -x lib/booktype/apps/edit/static/edit/js/aloha/plugins/oer/format/nls/pl/i18n.js
chmod -x lib/booktype/apps/edit/static/edit/js/aloha/plugins/oer/format/lib/format-plugin.js
chmod -x lib/booktype/apps/edit/static/edit/js/aloha/plugins/oer/format/nls/i18n.js
chmod -x lib/booktype/apps/edit/static/edit/js/aloha/plugins/booktype/styling/lib/styling-plugin.js
chmod -x lib/booktype/apps/edit/static/edit/js/aloha/plugins/oer/format/nls/de/i18n.js
chmod -x lib/booktype/apps/edit/static/edit/js/aloha/plugins/oer/format/nls/eo/i18n.js
chmod -x lib/booktype/apps/edit/static/edit/js/aloha/plugins/oer/format/nls/fi/i18n.js
chmod -x lib/booktype/apps/edit/static/edit/js/aloha/plugins/oer/format/nls/ru/i18n.js
chmod -x lib/booktype/apps/edit/static/edit/js/aloha/plugins/oer/format/nls/fr/i18n.js

# delete left-over gitignore file
rm lib/booktype/apps/edit/static/edit/js/aloha/plugins/extra/draganddropfiles/demo/.gitignore

#############################

echo "running the build..."

debuild -uc -us $@ || exit

# copy the new package to the public server
# scp /tmp/booktype_${VERSION}_all.deb apt.sourcefabric.org:/var/www/apt/snapshots/

# copy the build log too
# scp /tmp/booktype_${VERSION}_amd64.build apt.sourcefabric.org:/var/www/apt/snapshots/
