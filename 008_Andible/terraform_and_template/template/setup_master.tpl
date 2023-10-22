#! /bin/bash
set -e -x
sudo apt update 
sudo apt upgrade -y 
sudo apt install ${jdk_pkg} -y
curl -fsSL https://pkg.jenkins.io/debian-stable/${jenkins_key}.key | sudo tee \
/usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/${jenkins_list_type} binary/ | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get install jenkins
sudo systemctl restart jenkins