Step #1: Install required packages

Type the following command
$ sudo apt-get install build-essential fakeroot dpkg-dev

Step #2: Install source code package

First, create a directory to store source package, enter:
$ mkdir build
$ cd build

Use apt-get command to install source code for a package called foo
$ sudo apt-get source foo

Install all build-dependencies, enter:
$ sudo apt-get build-dep foo

Unpacks Debian / Ubuntu source archives with Debian source package (.dsc) manipulation tool, enter:
$ dpkg-source -x foo_version-revision.dsc

To just compile the package, you need cd into foo-version directory and issue the command
$ dpkg-buildpackage -rfakeroot -b

If you want to pass custom additonal options to configure, you can set up the DEB_BUILD_OPTIONS environment variable. For instance, if you want pass option called --enable-radio --enable-gui, enter:
$ DEB_BUILD_OPTIONS="--enable-gui --enable-radio" fakeroot debian/rules binary

You can also pass some variables to the Makefile. For example, if you want to compile with gcc v3.4, enter:
$ CC=gcc-3.4 DEB_BUILD_OPTIONS="--enable-gui --enable-radio" fakeroot debian/rules binary

A complete example - mplayer

Let us see how to rebuild mplayer media player package with --enable-radio --disable-ivt options:
# sudo apt-get source mplayer
# sudo apt-get build-dep mplayer
# dpkg-source -x mplayer_version-revision.dsc
# DEB_BUILD_OPTIONS="--enable-gui --enable-radio --disable-ivt" fakeroot debian/rules binary

Now wait for some time as compile procedure going to take its own time. To install the newly-built package, enter:
# dpkg -i ../mplayer_version-revision_arch.deb
