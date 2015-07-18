rm -rf root.tar.xz
pushd root &> /dev/null
tar cvJf ../root.tar.xz .
popd &> /dev/null

docker build -t ndslabs/owncloud:8.0.2 .
