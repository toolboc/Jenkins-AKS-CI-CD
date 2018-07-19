#!/bin/bash
set -e

#set permissions for jenkins user
#sudo chown -R jenkins:jenkins /var/lib/jenkins/.kube/

DEBIAN_FRONTEND=noninteractive

wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

sudo apt-get -y update

sudo apt-get -y install default-jre

sudo apt-get -y install jenkins

#Install Docker
if ! [ -x "$(command -v docker)" ]; then
    curl -sSL https://get.docker.com | sudo -E sh
    sudo usermod -aG docker jenkins
fi

#Restart jenkins
sudo service jenkins restart

#install kubectl
if ! [ -x "$(command -v kubectl)" ]; then
    sudo snap install kubectl --classic
fi

#Install Helm
if ! [ -x "$(command -v helm)" ]; then
    wget https://storage.googleapis.com/kubernetes-helm/helm-v2.9.1-linux-amd64.tar.gz
    tar -xzvf helm-v2.9.1-linux-amd64.tar.gz
    sudo mv linux-amd64/helm /usr/local/bin/helm
    sudo helm init
fi

