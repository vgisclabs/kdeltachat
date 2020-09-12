cmake_minimum_required(VERSION 3.14)

project(kdeltachat LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Widgets Quick REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Widgets Quick REQUIRED)

include(ExternalProject)
ExternalProject_Add(
  deltachat-core-rust
  SOURCE_DIR "${CMAKE_SOURCE_DIR}/../deltachat-core-rust"
  BUILD_IN_SOURCE 1
  BUILD_COMMAND env PREFIX=<INSTALL_DIR> cargo build -p deltachat_ffi -j 1
  BUILD_ALWAYS 1
  BUILD_BYPRODUCTS <SOURCE_DIR>/target/debug/libdeltachat.a
  CONFIGURE_COMMAND ""
  INSTALL_COMMAND cp <SOURCE_DIR>/target/debug/libdeltachat.a <INSTALL_DIR>/libdeltachat.a
  COMMAND cp <SOURCE_DIR>/deltachat-ffi/deltachat.h <INSTALL_DIR>/deltachat.h
)

add_executable(kdeltachat
  main.cpp
  message.cpp
  context.cpp
  accounts_model.cpp
  chatlist.cpp
  contact.cpp
  chat.cpp
  eventemitter.cpp
  lot.cpp
  dcevent.cpp
  qml.qrc
)

add_dependencies(kdeltachat deltachat-core-rust)
find_package(Threads REQUIRED)
find_package(KF5Kirigami2)

target_compile_definitions(kdeltachat
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(kdeltachat
  PRIVATE Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Quick Qt${QT_VERSION_MAJOR}::Widgets
  PRIVATE Threads::Threads
  PRIVATE KF5::Kirigami2
  PRIVATE "${CMAKE_BINARY_DIR}/deltachat-core-rust-prefix/libdeltachat.a"
  m dl)
target_include_directories(kdeltachat
  PRIVATE "${CMAKE_BINARY_DIR}/deltachat-core-rust-prefix/")
