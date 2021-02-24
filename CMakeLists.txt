cmake_minimum_required(VERSION 3.14)

project(kdeltachat LANGUAGES CXX)

find_package(ECM REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH} ${ECM_MODULE_DIR})
include(KDEInstallDirs)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Widgets Quick REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Widgets Quick REQUIRED)
find_package(PkgConfig REQUIRED)

add_executable(kdeltachat
  main.cpp
  message.cpp
  context.cpp
  accounts.cpp
  chatlist.cpp
  contact.cpp
  chat.cpp
  eventemitter.cpp
  lot.cpp
  dcevent.cpp
  qml.qrc
)

find_package(Threads REQUIRED)
find_package(KF5Kirigami2)
pkg_check_modules(DeltaChat IMPORTED_TARGET deltachat)

target_compile_definitions(kdeltachat
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(kdeltachat
  PRIVATE Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Quick Qt${QT_VERSION_MAJOR}::Widgets
  PRIVATE Threads::Threads
  PRIVATE KF5::Kirigami2
  PRIVATE PkgConfig::DeltaChat
  m dl)

install(TARGETS kdeltachat ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
