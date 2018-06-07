sleep 5
# check that logstash is runnning
dockerRun curl -s -XGET http://logstash:9600/?pretty

# check that plugin port is opened
dockerRun nc -vz logstash 5000

# check that Elastic is running
dockerRun curl -s  http://elastic:9200

# send a JSON message 
echo '{"MESSAGE":"TEST"}' | dockerRun nc logstash 5000

# wait for index to setup
sleep 5
# check index
dockerRun curl -s http://elastic:9200/logstash/logs/_search
echo



