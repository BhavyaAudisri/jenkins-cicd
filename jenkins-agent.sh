#!/bin/bash

#resize disk from 20GB to 50GB
#=================================
growpart /dev/nvme0n1 4

lvextend -L +10G /dev/mapper/RootVG-homeVol
lvextend -L +10G /dev/mapper/RootVG-varVol
lvextend -l +100%FREE /dev/mapper/RootVG-varTmpVol

xfs_growfs /home
xfs_growfs /var/tmp
xfs_growfs /var

#install java-17
#========================
yum install java-17-openjdk -y

# install nslookup
#========================
yum install -y yum-utils

# install terraform
#=================
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum -y install terraform

#install nodejs
#===================
dnf module disable nodejs -y
dnf module enable nodejs:20 -y
dnf install nodejs -y

# install zip
#================
yum install zip -y

# docker
#==============
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# Helm
#====================
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh