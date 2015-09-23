#!/bin/bash
# 
# Publishes nightly builds of LYSA: http://learnyou.org/lysa.html
# 
# For a list of dependencies, see
# https://github.com/learnyou/lysa/blob/master/en/README.md

# This will be the name of this nightly build
FNOM_EBOOK=`date -u +"lysa-%Y-%m-%d-ebook.pdf"`
FNOM_PRINT=`date -u +"lysa-%Y-%m-%d-print.pdf"`

# The directory from which the nighlies are served
LYSADIR=/usr/share/nginx/nightly.learnyou.org/lysa

cleanup () {
    cd
    rm -rf lysa
}

# Start in home directory
cd

# Clone the lysa repo
git clone git://github.com/learnyou/lysa.git
cd lysa/en
git submodule init
git submodule update
cd ..

# If nothing has changed from a day ago, exit:
if [[ `git whatchanged --since='24 hours ago'` == "" ]] ; then
    cleanup
    exit 0
fi

# Build LYSA
make

# Publish the nightly

# English
cp lysa-en-ebook.pdf ${LYSADIR}/en/${FNOM_EBOOK}
cp lysa-en-print.pdf ${LYSADIR}/en/${FNOM_PRINT}
cd $LYSADIR/en
ln -sf ${FNOM_EBOOK} lysa-latest-ebook.pdf
ln -sf ${FNOM_PRINT} lysa-latest-print.pdf

cleanup
