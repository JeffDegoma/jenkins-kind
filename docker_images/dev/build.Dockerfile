FROM jenkins/jenkins:2.263.3-lts-centos
USER root
#docker
RUN dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
RUN dnf install docker-ce --nobest -y
RUN dnf clean all
RUN usermod -a -G docker jenkins
RUN usermod -a -G root jenkins
RUN yum install sudo -y

#docker-compose
# RUN sudo curl -L "https://github.com/docker/compose/releases/download/1.27.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
# RUN chmod +x /usr/bin/docker-compose

#allows jenkins user to use sudo
RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
#jenkins config
USER jenkins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt 
# COPY jenkins.yml /usr/share/jenkins/ref/jenkins.yml
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
ENV JENKINS_USER admin
ENV JENKINS_PASS admin
ENV CASC_JENKINS_CONFIG /usr/share/jenkins/ref/jenkins.yml
# map local development into jenkins.yml in container for quick testing
# fetch from url https://gist.githubusercontent.com/JeffDegoma/043c2193000c774380530a64a138c685/raw/jenkins.yml

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
# COPY default-user.groovy /usr/share/jenkins/ref/init.groovy.d/


#ENV JENKINS_USER gets passed into jenkins.yml file
#CASC_JENKINS_CONFIG variable native to the plugin to automate jenkins configuration and avoid UI