FROM centos:7

USER root 

# installation de Java8
RUN yum -y install java-1.8.0-openjdk which openssh openssh-server openssh-clients

# installation de wget
RUN yum install -y wget

# installation de sudo
RUN yum install -y sudo

# On télécharge le fichier hdp.repo et on l ecopie dans yum.repos.d
RUN wget -nv http://public-repo-1.hortonworks.com/HDP/centos7/2.x/updates/2.6.2.0/hdp.repo -O /etc/yum.repos.d/hdp.repo

# Création du groupe hadoop
RUN groupadd hadoop

# création de l'utilisateur kafka
RUN useradd -g hadoop -G wheel kafka

# En root 
RUN mkdir -p /var/data/kafka
RUN chown -R kafka:hadoop /var/data/kafka
RUN sudo echo '1' >> /var/data/kafka/myid

USER kafka

# On rajoute java_home dans le bashrc
 RUN echo "export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk" >> ~/.bashrc
 RUN source ~/.bashrc

USER root

# installation de kafka
RUN yum install -y kafka

RUN mkdir -p /usr/hdp/2.6.2.0-205/kafka/.ssh/
RUN chown -R kafka:hadoop /usr/hdp/2.6.2.0-205/kafka/.ssh

USER kafka

RUN ssh-keygen -t rsa -P '' -f /usr/hdp/2.6.2.0-205/kafka/.ssh/id_rsa
RUN cat /usr/hdp/2.6.2.0-205/kafka/.ssh/id_rsa.pub >> /usr/hdp/2.6.2.0-205/kafka/.ssh/authorized_keys
RUN chmod 0600 /usr/hdp/2.6.2.0-205/kafka/.ssh/authorized_keys

USER root

# on remplace le fichier server.properties , ça stop kafka
# COPY ./kafka/conf/server.properties usr/hdp/current/kafka-broker/conf/server.properties

# Creation répertoire pour entrypoint kafka
RUN mkdir -p /opt/kafka

# On copie l'entrypoint local vers docker
COPY ./kafka/scripts/entrypoint.sh /opt/kafka

ENTRYPOINT ["bash", "-c", "/opt/kafka/entrypoint.sh"]