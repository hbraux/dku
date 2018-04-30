# check hbase shell and thrift API 
dockerRun shell <<EOF
create_namespace 'test_ns'
create 'test_ns:test_table','C'
put 'test_ns:test_table','1234','C:a','aaaa'
put 'test_ns:test_table','1234','C:b','bbbbbb'
put 'test_ns:test_table','1234','C:e','eee'
EOF

# check Master web UI
curl -s http://hbase:16010/master-status | grep test_ns:test_table

# Check Rest API
curl -s http://$DOCKER_HOST:16000/test_ns:test_table/1234/C:a
