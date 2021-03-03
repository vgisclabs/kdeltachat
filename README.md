# KDeltaChat

KDeltaChat is a [Delta Chat](https://delta.chat/) client using [Kirigami](https://develop.kde.org/frameworks/kirigami/) framework.

# Dependencies

KDeltaChat build depends on
[libdeltachat](https://github.com/deltachat/deltachat-core-rust/),
Kirigami framework and several QML modules.

## kdesrc-build

It's recommended to build KDeltaChat with [kdesrc-build](https://kdesrc-build.kde.org/).
This allows to avoid installing `libdeltachat` system-wide and use
upstream Kirigami instead of usually outdated packaged versions.

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

## Rust

Building `libdeltachat` requires Rust.
Install it from https://rustup.rs/ with
```
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain none
```

## libdeltachat

If you are using [`kdesrc-build`](https://kdesrc-build.kde.org/),
add module into `~/.kdesrc-buildrc` as follows
```
module deltachat
   repository https://github.com/deltachat/deltachat-core-rust.git
end module
```
Then build `libdeltachat` with `kdesrc-build deltachat`.

Alternatively, if you are not using `kdesrc-build`, install `libdeltachat` system-wide:
```
$ git clone https://github.com/deltachat/deltachat-core-rust.git
$ cd deltachat-core-rust
$ cmake -B build .
$ cmake --build build
$ sudo cmake --install build
```

## Qt

Install QtQuick and required QML modules using your system package manager.

### Debian

Build time dependencies:
- `qtdeclarative5-dev` (for `/usr/lib/x86_64-linux-gnu/cmake/Qt5Quick/Qt5QuickConfig.cmake`)

Runtime dependencies:
- `qml-module-qtquick-controls`
- `qml-module-qtquick-dialogs` - used for account import file dialog
- `qml-module-qtquick-layouts`

### Arch Linux

Install FileDialog:
- `pacman -S qt5-quickcontrols`

Install `extra-cmake-modules`(https://api.kde.org/ecm/manual/ecm-kde-modules.7.html):
- `pacman -S extra-cmake-modules`

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

Build Kirigami with `kdesrc-build kirigami`.

Alternatively, if you are not using `kdesrc-build`, install system package for Kirigami,
such as `kirigami2-dev` on Debian or Ubuntu, `kirigami2` on Arch Linux or `kirigami2-devel` on OpenSUSE.

# Building

In `kdeltachat` directory, run:
```
cmake -B build .
cmake --build build
```

# Running

Run `build/kdeltachat`. Import existing account from backup or setup a
new one. Start IO in the main menu to connect.

# Troubleshooting

## Buttons have no icons

On Debian/Ubuntu, run `apt purge libqt5quick5-gles`. When `apt` offers
to install `libqt5quick5` as a replacement, agree.

Debian bugreport: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=976389

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
