Apache tomcat is java based and is a web server container for web applications

## Server Setup in VM
ec2 instance: t2.micro

since this java based, java is a pre-requisite

download tomcat tar file, I've used tomcat 9:
```
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.86/bin/apache-tomcat-9.0.86.tar.gz
```
extract the tar file:
```
tar xvzf apache-tomcat-9.0.86.tar
```
rename for convinience: 
```
mv apache-tomcat-9.0.86.tar tomcat
```
enter the tomcat foler where these files are seen among others
```
bin : has files related to start, stop services, etc
conf : has configuration files including server.xml to change port
webapps : this is where the web applications are deployed
```
go to bin directory and enable `startup.sh` file, this enables the tomcat server in port 8081, enable this in security settings
```
sh startup.sh
```
![files](https://github.com/guycalledavinash/apache-tomcat/assets/90386560/1a59cd0c-ba8d-488a-9de8-3adaba613840)

This fires up the server:
![1](https://github.com/guycalledavinash/apache-tomcat/assets/90386560/1218c900-6176-4270-a663-b5161c289cf8)

But we can't access it yet, it won't let us:
![2](https://github.com/guycalledavinash/apache-tomcat/assets/90386560/6f8fbf0e-1287-45a4-bac2-a7b0312d75b0)

## Enable the Service 
To enable the service, we should allow all users and configure their credentials. 

1. Allow all users to access the portal by configuring the details in `context.xml` file in this directory
```
webapps\manager\META-INF\
```
find and edit that file
```
vi context.xml
```
this is how the default script look like:
![3](https://github.com/guycalledavinash/apache-tomcat/assets/90386560/43fd7294-4dd2-4bda-a2a1-a27700f225f5)
under `<value ` section, allow all users by changing it to this:
```
allow=".*"
```
It should look like this:
![4](https://github.com/guycalledavinash/apache-tomcat/assets/90386560/280bcfb7-1d3c-4dd6-b979-0aebed5ab5fe)
