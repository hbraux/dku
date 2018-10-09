import random
import pyspark
def inside(p):
    x, y = random.random(), random.random()
    return x*x + y*y < 1

n = 10000000
sc = pyspark.SparkContext(appName="py-test")
count = sc.parallelize(xrange(0, n)).filter(inside).count()
print "Pi is roughly %f" % (4.0 * count / n)
