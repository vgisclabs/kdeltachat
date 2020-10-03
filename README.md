# KDeltaChat

KDeltaChat is a [Delta Chat](https://delta.chat/) client using [Kirigami](https://develop.kde.org/frameworks/kirigami/) framework.

# Dependencies

## Debian

Build time dependencies:
- `qtdeclarative5-dev` (for `/usr/lib/x86_64-linux-gnu/cmake/Qt5Quick/Qt5QuickConfig.cmake`)
- `kirigami2-dev`

Runtime dependencies:
- `qml-module-qtquick-controls`
- `qml-module-qtquick-dialogs` - used for account import file dialog
- `qml-module-qtquick-layouts`

## Arch Linux

Install FileDialog:
- `pacman -S qt5-quickcontrols`

Install kirigami2:
- `pacman -S kirigami2`

## OpenSUSE

OpenSUSE Leap 15.2:
```
# Install Rust core dependencies
zypper install -y curl
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain none
zypper install -y libopenssl-devel perl-FindBin-Real

# Install KDeltaChat dependencies
zypper install -y cmake gcc-c++
zypper install -y libqt5-qtbase-devel libQt5QuickControls2-devel kirigami2-devel
```

# Building

```
mkdir build
cd build
cmake ..
make
```

# Running

Run `./kdeltachat`. Import existing account from backup and start IO in the main menu to connect.

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
