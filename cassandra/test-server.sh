sleep 5
# check cqlsh
dockerRun cqlsh <<EOF
CREATE KEYSPACE test WITH REPLICATION = { 'class' : 'SimpleStrategy',  'replication_factor' : 1 };
CREATE TABLE test.client ( id UUID PRIMARY KEY, lastname text,  firstname text );
INSERT INTO test.client (id, lastname, firstname) VALUES (6ab09bec-e68e-48d9-a5f8-97e6fb4c9b47, 'DOE','John');
SELECT * from test.client;
EOF

