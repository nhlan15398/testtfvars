#!/bin/bash
yum update -y
amazon-linux-extras install epel -y
yum update -y
yum install git -y
yum install java-latest-openjdk.x86_64 -y
export JAVA_HOME=/usr/lib/jvm/java-18-openjdk-18.0.1.0.10-1.rolling.el7.x86_64
export PATH=$PATH:$JAVA_HOME/bin
curl -s https://get.sdkman.io | bash
source "/.sdkman/bin/sdkman-init.sh"
sdk install springboot
sdk install gradle
git clone https://github.com/pdcong/HelloWorld.git
git clone https://github.com/nhlan15398/nginx.git
spring init --build=gradle --dependencies=web --name=hello hello-world
cp /HelloWorld/HelloApp.java /hello-world/src/main/java/com/example/helloworld/HelloApplication.java
cd /hello-world/ && ./gradlew build && cd
touch /etc/systemd/system/helloworld.service
cp /nginx/helloworld.service /etc/systemd/system/helloworld.service
systemctl daemon-reload
systemctl enable helloworld
systemctl start helloworld
amazon-linux-extras install nginx1 -y
cp /nginx/nginx.conf /etc/nginx/nginx.conf
touch /etc/nginx/conf.d/nginx_reverse.conf
cp /nginx/nginx_reverse.conf /etc/nginx/conf.d/nginx_reverse.conf
systemctl restart nginx
systemctl restart helloworld