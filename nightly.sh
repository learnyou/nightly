#!/bin/sh
# 
# Publishes nightly builds of LYSA: http://learnyou.org/lysa.html
# 
# For a list of dependencies, see
# https://github.com/learnyou/lysa/blob/master/en/README.md
# 
# Copyright (c) 2015 Peter Harpending. <peter@harpending.org>
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# This will be the name of this nightly build
FNOM=`date -u +"lysa-%Y-%m-%d.pdf"`

# The directory from which the nighlies are served
LYSADIR=/var/www/nightly.learnyou.org/lysa

# Start in home directory
cd

# Clone the lysa repo
git clone git://github.com/learnyou/lysa.git
cd lysa/en
git submodule init
git submodule update
cd ..

# If nothing has changed from a day ago, exit:
[[ `git diff --since 24h` == "" ]] && exit 0

# Build LYSA
make

# Publish the nightly

# English
cp lysa-en.pdf ${LYSADIR}/en/${FNOM}
cd $LYSADIR/en
ln -sf ${FNOM} lysa-latest.pdf

# Clean up
cd
rm -rf lysa
