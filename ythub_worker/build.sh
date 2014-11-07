#!/bin/bash

rm -rf aux
git init aux
pushd aux/ &> /dev/null
git remote add -f origin https://bitbucket.org/nds-org/yt_webapp.git
git config core.sparsecheckout true
echo "rest2/" >> .git/info/sparse-checkout
echo "supervisor/" >> .git/info/sparse-checkout
echo ".gitmodules" >> .git/info/sparse-checkout
git pull origin master
git submodule init
git submodule update
pushd rest2/backend/v1 &> /dev/null
git pull origin master
popd &> /dev/null
mv rest2 app
popd &> /dev/null

docker build -t ndslabs/ythub_worker:latest .
