# KDeltaChat

KDeltaChat is a [Delta Chat](https://delta.chat/) client using [Kirigami](https://develop.kde.org/frameworks/kirigami/) framework.

# Dependencies

KDeltaChat build depends on
[libdeltachat](https://github.com/deltachat/deltachat-core-rust/),
Kirigami framework and several QML modules.

## libdeltachat

`libdeltachat` is not packaged for most distributions, so the easiest
way is to install it system-wide from the source.

Building `libdeltachat` requires Rust.
Install it from https://rustup.rs/ with
```
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain none
```

Then, clone the source, build `libdeltachat` and install it:
```
$ git clone https://github.com/deltachat/deltachat-core-rust.git
$ cd deltachat-core-rust
$ cmake -B build . -DCMAKE_INSTALL_PREFIX=/usr
$ cmake --build build
$ sudo cmake --install build
```

## Qt

Install QtQuick and required QML modules using your system package manager.

### Debian

Build time dependencies:
- `qtbase5-dev`
- `qtdeclarative5-dev` (for `/usr/lib/x86_64-linux-gnu/cmake/Qt5Quick/Qt5QuickConfig.cmake`)
- `qtwebengine5-dev`
- `cmake`
- `extra-cmake-modules`
- `pkg-config`

Runtime dependencies:
- `qml-module-qtquick-controls`
- `qml-module-qtquick-controls2`
- `qml-module-qtquick-dialogs` - used for account import file dialog
- `qml-module-qtquick-layouts`
- `qml-module-qtmultimedia`
- `qml-module-qtwebengine`
- `qt5-image-formats-plugins` - WebP support

### Arch Linux

Install Kirigami:
- `kirigami2`

Install FileDialog:
- `qt5-quickcontrols`

Install `extra-cmake-modules`(https://api.kde.org/ecm/manual/ecm-kde-modules.7.html):
- `extra-cmake-modules`

WebP support:
- `qt5-imageformats`

HTML view:
- `qt5-webengine`

Media player:
- `qt5-multimedia`

### OpenSUSE

OpenSUSE Leap 15.2:
```
# Install Rust core dependencies
zypper install -y curl
zypper install -y libopenssl-devel perl-FindBin-Real

# Install KDeltaChat dependencies
zypper install -y cmake gcc-c++
zypper install -y libqt5-qtbase-devel libQt5QuickControls2-devel libqt5-quickcontrols
```

## Kirigami

Install system package for Kirigami, such as `kirigami2-dev` on Debian
or Ubuntu, `kirigami2` on Arch Linux or `kirigami2-devel` on OpenSUSE.

# Building

In `kdeltachat` directory, run:
```
cmake -B build .
cmake --build build
```

# Running

Run `build/kdeltachat`. Import existing account from backup or setup a
new one.

# Using kdesrc-build

If your distribution does not package recent enough versions of the
Kirigami framework, or you don't want to install `libdeltachat`
system-wide, you can use [kdesrc-build](https://kdesrc-build.kde.org/).

Install it with:
```
mkdir -p ~/kde/src
cd ~/kde/src
git clone https://invent.kde.org/sdk/kdesrc-build.git
cd kdesrc-build
./kdesrc-build-setup
./kdesrc-build kirigami
```

Run
```
source ~/.config/kde-env-master.sh
```
in your shell to enter `kdesrc-build` environment.

To build `libdeltachat` with `kdesrc-build`,
add module into `~/.kdesrc-buildrc` as follows
```
module deltachat
   repository https://github.com/deltachat/deltachat-core-rust.git
end module
```
Then build `libdeltachat` with `kdesrc-build deltachat`.

Build Kirigami with `kdesrc-build kirigami`.

Then build `kdeltachat` as described above.

# Troubleshooting

## Button icons are replaced with black rectangles

On Debian/Ubuntu, run `apt purge libqt5quick5-gles`. When `apt` offers
to install `libqt5quick5` as a replacement, agree.

Debian bugreport: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=976389

## Buttons have no icons

If you are not using KDE or another desktop environment with Qt 5 integration,
you can install [qt5ct](https://sourceforge.net/projects/qt5ct/), configure
icon theme for Qt 5 there and set `QT_QPA_PLATFORMTHEME=qt5ct` or
`XDG_CURRENT_DESKTOP=qt5ct` environment variable.

Setting `XDG_CURRENT_DESKTOP=GNOME` environment variable has also been reported
to help in this case. This results in usage of Adwaita icon theme.

# License

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

In addition, as a special exception, the author of this program gives
permission to link the code of its release with the OpenSSL
project's "OpenSSL" library (or with modified versions of it that
use the same license as the "OpenSSL" library), and distribute the
linked executables. You must obey the GNU General Public License in
all respects for all of the code used other than "OpenSSL". If you
modify this file, you may extend this exception to your version of
the file, but you are not obligated to do so.  If you do not wish to
do so, delete this exception statement from your version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
