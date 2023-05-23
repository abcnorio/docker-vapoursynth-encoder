#!/bin/bash
set -e
set -o pipefail


git-shallow-clone "5.15.2" "https://code.qt.io/qt/qt5.git" /src/qt5
pushd /src/qt5
mkdir b
pushd b
../configure -verbose -prefix /usr -confirm-license -release -no-shared -static -mp -ltcg \
-linker lld -pch -platform linux-clang \
-ccache -pkg-config -opensource -no-warnings-are-errors \
-no-iconv -no-icu -qt-freetype -no-zlib -no-harfbuzz \
-no-gif -no-ico -no-libpng -no-libjpeg \
-no-libudev -no-evdev -no-bundled-xcb-xinput -no-libinput -no-mtdev -no-tslib \
-no-xcb -no-linuxfb -no-kms -no-gbm -no-eglfs -no-directfb -no-xcb-xlib \
-no-egl -no-opengl -no-vulkan -no-qpa -no-gtk -no-cups -no-ssl -no-openssl -no-inotify -no-eventfd -no-glib -qt-sqlite \
-no-sql-db2 -no-sql-ibase -no-sql-mysql -no-sql-oci \
-no-sql-odbc -no-sql-psql -no-sql-sqlite -no-sql-sqlite2 -no-sql-tds \
-no-widgets -no-xkbcommon \
-no-feature-accessibility -no-feature-testlib \
-qt-doubleconversion -qt-pcre \
-nomake examples -nomake tests \
-skip qt3d -skip qtactiveqt -skip qtcanvas3d -skip qtconnectivity -skip qtdatavis3d -skip qtdoc \
-skip qtgamepad -skip qtgraphicaleffects -skip qtlocation -skip qtnetworkauth -skip qtpurchasing \
-skip qtquickcontrols -skip qtquickcontrols2 -skip qtremoteobjects -skip qtscxml -skip qtsensors \
-skip qtserialbus -skip qtserialport -skip qtspeech -skip qtvirtualkeyboard -skip qtwebview \
-skip qtscript -skip qtwebengine -skip qtdoc \
-skip qtactiveqt -skip qtmacextras  \
-skip qtwebsockets -skip qtwinextras -skip qtwebchannel -skip qtdeclarative \
-skip qtimageformats -skip qtx11extras -skip qttranslations
make -j$(nproc)
make install