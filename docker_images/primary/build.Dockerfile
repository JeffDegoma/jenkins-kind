FROM jenkins/jenkins:2.235.5-lts-centos
USER root
#docker
RUN dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
RUN dnf install docker-ce-3:18.09.1-3.el7 -y
RUN dnf clean all
RUN usermod -a -G docker jenkins
RUN usermod -a -G root jenkins
RUN yum install sudo -y

#jenkins
RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER jenkins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
ENV JENKINS_USER admin 
ENV JENKINS_PASS admin
ENV CASC_JENKINS_CONFIG /usr/share/jenkins/ref/jenkins.yml

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt