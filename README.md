# KDeltaChat

KDeltaChat is a [Delta Chat](https://delta.chat/) client using [Kirigami](https://develop.kde.org/frameworks/kirigami/) framework.

# Dependencies

KDeltaChat build depends on Rust for core building, Kirigami framework and several QML modules.

## Rust

Install Rust from https://rustup.rs/ with
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain none
```

Clone [`deltachat-core-rust` repository](https://github.com/deltachat/deltachat-core-rust/) alongside
`kdeltachat` repository, for example into `~/src/deltachat-core-rust/` if `kdeltachat` is checked out at `~/src/kdeltachat`:
```
git clone https://github.com/deltachat/deltachat-core-rust.git
```

## Kirigami and Qt

Install Kirigami and required QML modules from your distribution repositories.

### Debian

Build time dependencies:
- `qtdeclarative5-dev` (for `/usr/lib/x86_64-linux-gnu/cmake/Qt5Quick/Qt5QuickConfig.cmake`)
- `kirigami2-dev`

Runtime dependencies:
- `qml-module-qtquick-controls`
- `qml-module-qtquick-dialogs` - used for account import file dialog
- `qml-module-qtquick-layouts`

### Arch Linux

Install FileDialog:
- `pacman -S qt5-quickcontrols`

Install kirigami2:
- `pacman -S kirigami2`

### OpenSUSE

OpenSUSE Leap 15.2:
```
# Install Rust core dependencies
zypper install -y curl
zypper install -y libopenssl-devel perl-FindBin-Real

# Install KDeltaChat dependencies
zypper install -y cmake gcc-c++
zypper install -y libqt5-qtbase-devel libQt5QuickControls2-devel kirigami2-devel libqt5-quickcontrols
```

### Building with upstream Kirigami

If you want to use upstream Kirigami, for example to avoid bugs fixed
upstream but not in the packaged version, you can use
[kdesrc-build](https://kdesrc-build.kde.org/).

Install it with:
```
mkdir -p ~/kde/src
cd ~/kde/src
git clone https://invent.kde.org/sdk/kdesrc-build.git
cd kdesrc-build
./kdesrc-build-setup
./kdesrc-build kirigami
```

Then, run
```
source ~/.config/kde-env-master.sh
```
in your shell and rebuild the app, starting with a complete removal of
the `build` directory.

The source of Kirigami will be available in `~/kde/src/kirigami` then.

# Building

In `kdeltachat` directory, run:
```
mkdir build
cd build
cmake ..
make
```

This will build `deltachat-core-rust` and install core library into
build directory automatically.

# Running

Run `./kdeltachat`. Import existing account from backup or setup a
new one. Start IO in the main menu to connect.

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
