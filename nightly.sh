#!/bin/bash
# 
# Publishes nightly builds of LYSA: http://learnyou.org/lysa.html
# 
# For a list of dependencies, see
# https://github.com/learnyou/lysa/blob/master/en/README.md

# This will be the name of this nightly build
FNOM=`date -u +"lysa-%Y-%m-%d.pdf"`

# The directory from which the nighlies are served
LYSADIR=/var/www/nightly.learnyou.org/lysa

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
cp lysa-en.pdf ${LYSADIR}/en/${FNOM}
cd $LYSADIR/en
ln -sf ${FNOM} lysa-latest.pdf

cleanup
