dockerRun shell <<EOF
use test
db.clients.insert({ _id: "10001", "name":"john","age":45,"coord":[ -72.95,40.77]})
db.clients.insert({ _id: "10002", "name":"doe","age":25,"coord":[ 12.95,80.70]})
EOF

# Check Restheart status
echo "REST API:"
curl -s http://$DOCKER_HOST:27000/test/clients/10002





