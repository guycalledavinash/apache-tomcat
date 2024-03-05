Apache tomcat is java based and is a web server container for web applications

##Server Setup in VM
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

bin : has files related to start, stop services, etc
conf : has configuration files including server.xml to change port
webapps : this is where the web applications are deployed

go to bin directory and enable `startup.sh` file, this enables the tomcat server in the server 8081
```
sh startup.sh
```
