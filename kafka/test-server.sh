dockerRun kafka-topics.sh --zookeeper kafka:2181 --create --topic mytopic --partitions 1 --replication-factor 1
dockerRun kafka-json.py --count 1 kafka:9092 mytopic '{"uuid":"%UUID","key":"STR3","val":%INT99}'



