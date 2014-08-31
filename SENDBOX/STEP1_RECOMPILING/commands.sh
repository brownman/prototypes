 echo sudo apt-get install build-essential fakeroot dpkg-dev
 mkdir build
 cd build
 sudo apt-get cowsay foo
 sudo apt-get build-dep cowsay 
 dpkg-source -x cowsay*.dsc
 #foo_version-revision.dsc
 dpkg-buildpackage -rfakeroot -b
 DEB_BUILD_OPTIONS="--enable-gui --enable-radio" fakeroot debian/rules binary
 CC=gcc-3.4 DEB_BUILD_OPTIONS="--enable-gui --enable-radio" fakeroot debian/rules binary
