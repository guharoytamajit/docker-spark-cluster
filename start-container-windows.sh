#!/bin/bash

# the default node number is 3
N=${1:-3}


# start hadoop master container
  docker rm -f master &> /dev/null
echo "start hadoop-master container..."
  docker run -itd \
                --net=hadoop \
                -p 50070:50070 \
                -p 8088:8088 \
				-p 8042:8042 \
				-p 8080:8080 \
				-p 4040:4040 \
				-v //c/Users/sparkvol:/sparkvol \
                --name master \
                --hostname master \
                myspark:tamajit2 
				#&> /dev/null


# start hadoop slave container
i=1
while [ $i -lt $N ]
do
	 docker rm -f slave$i &> /dev/null
	echo "start hadoop-slave$i container..."
	 docker run -itd \
	                --net=hadoop \
	                --name slave$i \
					-v //c/Users/sparkvol:/sparkvol \
	                --hostname slave$i \
	                myspark:tamajit2 &> /dev/null
	i=$(( $i + 1 ))
done 

# get into hadoop master container
 docker exec -it master bash
