#!/bin/sh
cmake -B build .
cmake --build build
sudo cp build/kdeltachat /usr/bin/kdeltachat
