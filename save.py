from pyspark.sql import SparkSession
sparkSession = SparkSession.builder.appName("example-pyspark-read-and-write").getOrCreate()
data = [('First', 1), ('Second', 2), ('Third', 3), ('Fourth', 4), ('Fifth', 5)]
df = sparkSession.createDataFrame(data)
df.write.csv("hdfs://master:9000/user/hdfs/test/new")