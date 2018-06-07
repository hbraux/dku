sleep 10
dockerRun cqlsh <<EOF
SELECT * from test.client;
EOF


