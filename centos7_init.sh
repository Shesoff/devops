#!/usr/bin/env bash
yum update -y
yum install -y mc nmap vim sed htop telnet 
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce
systemctl enable --now docker
