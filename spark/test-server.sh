docker cp $DockerDir/pi.py spark:/data
dockerRun spark-submit /data/pi.py --master spark://spark:7077

