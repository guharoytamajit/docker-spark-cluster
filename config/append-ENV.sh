echo "export JAVA_HOME=/usr/lib/java" >> .bashrc
echo "export HADOOP_HOME=/usr/local/hadoop" >> .bashrc
echo "export SPARK_HOME=/usr/local/spark" >> .bashrc
echo "export PATH=$PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$SPARK_HOME/bin:$SPARK_HOME/sbin" >> .bashrc
echo "export LD_LIBRARY_PATH=$HADOOP_HOME/lib/native" >> .bashrc
source .bashrc