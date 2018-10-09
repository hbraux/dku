# extra time for server to start
sleep 10
dockerRun curl -s -XPUT http://$DockerContainer:9200/test_index

