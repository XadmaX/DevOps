#! /bin/bash
set -e -x
sudo apt update 
sudo apt upgrade -y 
sudo apt install ${jdk_pkg} -y