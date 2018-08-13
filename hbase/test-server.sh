
# check hbase shell and thrift API 
dockerRun shell <<EOF
create_namespace 'test_ns'
create 'test_ns:test_table','C'
put 'test_ns:test_table','1234','C:a','aaaa'
put 'test_ns:test_table','1234','C:b','bbbbbb'
put 'test_ns:test_table','1234','C:e','eee'
scan 'test_ns:test_table'

EOF

# check Master web UI 
echo "Master web UI:"
dockerRun curl -s http://hbase:16010/master-status | grep test_ns:test_table

# Check Rest API
echo "Rest API:"
dockerRun curl -si http://hbase:8080/test_ns:test_table/1234/C:a

echo
