docker run --name master --net hadoop -itd -p 8088:8088 -p 8042:8042 -p 8085:8080 -p 4040:4040 -p 7077:7077 -p 2022:22  -v //c/Users/sparkvol:/sparkvol -h master myspark:tamajit bash
docker run --name slave1 --net hadoop -itd -h slave1 myspark:tamajit bash
docker run --name slave2 --net hadoop -itd -h slave2 myspark:tamajit bash