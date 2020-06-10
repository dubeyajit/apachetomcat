FROM dubeyajit/ubuntu-gnuhealth:v01

RUN apt update && apt install default-jdk -y
RUN apt-get install nano -y

RUN groupadd tomcat
RUN useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
#RUN useradd -rm -d /home/gnuhealth -s /bin/bash -g root -G sudo -u 1000 gnuhealth

USER tomcat
WORKDIR /home/tomcat/

USER root
#WORKDIR /tmp
ENV APACHE_FILE="apache-tomcat-9.0.36.tar.gz"
RUN wget https://mirrors.estointernet.in/apache/tomcat/tomcat-9/v9.0.36/bin/$APACHE_FILE
#RUN curl -o ${APACHE_FILE} -SL "https://ftp.gnu.org/gnu/health/$APACHE_FILE"
RUN mkdir /opt/tomcat
RUN tar zxvf ${APACHE_FILE} -C /opt/tomcat --strip-components=1

WORKDIR /opt/tomcat

RUN chgrp -R tomcat /opt/tomcat
RUN chmod -R g+r conf
RUN chmod g+x conf
RUN chown -R tomcat webapps/ work/ temp/ logs/
#RUN update-java-alternatives -l
ADD tomcat.service /etc/systemd/system/tomcat.service
ADD tomcat-users.xml /opt/tomcat/conf/tomcat-users.xml
ADD context.xml /opt/tomcat/webapps/host-manager/META-INF/context.xml
ADD context.xml /opt/tomcat/webapps/manager/META-INF/context.xml

RUN wget https://sourceforge.net/projects/openmrs/files/releases/OpenMRS_Platform_2.3.0/openmrs.war


#CMD ["./bin/catalina.sh", "start", "&"]
CMD ["bash"]
