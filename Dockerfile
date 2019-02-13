FROM ubuntu:14.04

MAINTAINER Tamajit <guharoytamajit@gmail.com>

WORKDIR /root

COPY config/* /tmp/
COPY hadoop-2.7.2.tar.gz /root
COPY spark-2.4.0-bin-hadoop2.7.tgz /root
COPY java.tar /root
COPY Python-2.7.2.tgz /root


# install openssh-server, openjdk ,wget ,build-essential(for python), checkinstall(for python)
RUN  apt-get update && apt-get install -y openssh-server wget build-essential checkinstall

#install java
RUN    tar -xf java.tar && \
    mv jdk1.8.0_171 /usr/local/java && \
    rm java.tar

# install hadoop 2.7.2
#RUN  wget https://github.com/kiwenlau/compile-hadoop/releases/download/2.7.2/hadoop-2.7.2.tar.gz && \
RUN    tar -xzvf hadoop-2.7.2.tar.gz && \
    mv hadoop-2.7.2 /usr/local/hadoop && \
    rm hadoop-2.7.2.tar.gz

#install spark 2.4.0	
#RUN  wget  http://apache.claz.org/spark/spark-2.4.0/spark-2.4.0-bin-hadoop2.7.tgz && \	
RUN    tar -xzvf spark-2.4.0-bin-hadoop2.7.tgz && \
    mv spark-2.4.0-bin-hadoop2.7 /usr/local/spark && \
    rm spark-2.4.0-bin-hadoop2.7.tgz

# set environment variable
ENV JAVA_HOME=/usr/local/java
ENV HADOOP_HOME=/usr/local/hadoop 
ENV SPARK_HOME=/usr/local/spark
ENV PATH=$PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$SPARK_HOME/bin:$SPARK_HOME/sbin 
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop

RUN echo "export JAVA_HOME=/usr/local/java" >> .bashrc && \
    echo "export HADOOP_HOME=/usr/local/hadoop " >> .bashrc && \
	echo "export SPARK_HOME=/usr/local/spark" >> .bashrc && \
	echo "export PATH=$PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$SPARK_HOME/bin:$SPARK_HOME/sbin" >> .bashrc  && \
    echo "export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop" >> .bashrc


#install python
RUN    tar -xzvf Python-2.7.2.tgz && \
    cd Python-2.7.2 && \
    sudo ./configure --enable-optimizations && \
	cd .. && \
	rm -rf Python-2.7.2 && \
	rm Python-2.7.2.tgz

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

RUN mkdir -p ~/hdfs/namenode && \ 
    mkdir -p ~/hdfs/datanode && \
    mkdir $HADOOP_HOME/logs



RUN mv /tmp/ssh_config ~/.ssh/config && \
    mv /tmp/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \ 
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves && \
    mv /tmp/start-hadoop.sh ~/start-hadoop.sh && \
    mv /tmp/run-wordcount.sh ~/run-wordcount.sh

RUN chmod +x ~/start-hadoop.sh && \
    chmod +x ~/run-wordcount.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh 

# format namenode
RUN sudo chmod -R a+rwx $JAVA_HOME $SPARK_HOME $HADOOP_HOME && \
    sudo $HADOOP_HOME/bin/hdfs namenode -format

CMD [ "sh", "-c", "service ssh start; bash"]

