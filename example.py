from pyspark import SparkContext
from pyspark import sql, SparkConf, SparkContext
sc = SparkContext()

sqlContext = sql.SQLContext(sc)

#df = sqlContext.read.csv("file:///c:/temp/superstore.csv", inferSchema = True, header = True)
df = sqlContext.read.csv("hdfs://master:9000/user/hdfs/store/input/superstore.csv", inferSchema = True, header = True)

df.show(10)
df.registerTempTable('superstore_table')
# sqlContext.sql('select * from superstore_table').show()
#sqlContext.sql('select category,count(category) from superstore_table group by category').show()
sqlContext.sql('select category,count(category) from superstore_table group by category').write.csv("hdfs://master:9000/user/hdfs/store/output")
