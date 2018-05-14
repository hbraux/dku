# check plugin port
dockerRun nc -vz logstash 5000

# check that logstash is runnning
dockerRun curl -s -XGET http://logstash:9600/?pretty

# check that Elastic is running
dockerRun curl -s  http://elastic:9200

# send a JSON message 
dockerRun bash -c 'echo "{\"MESSAGE\":\"TEST\"}" |nc -v logstash 5000'

# check index
dockerRun curl -s -XGET http://elastic:9200/logstash/logs/_count



