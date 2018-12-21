#!/bin/sh

function _setup {
  [[ -f .setup ]] && return
  if [[ -z $FILEBEAT_LOG ]]; then
    echo "FILEBEAT_LOG is empty. Nothing to collect"
    exit 1
  fi
  
  (cat >filebeat.yml)<<EOF
filebeat.autodiscover:
  providers:
    - type: docker
      templates:
        - condition:
            or:
EOF

  for img in $(echo $FILEBEAT_LOG | sed 's/,/ /g'); do
    echo "              - contains:
                  docker.container.image: $img" >>filebeat.yml
  done

  (cat >>filebeat.yml)<<EOF
          config:
            - type: docker
              json.keys_under_root: true
              json.add_error_key: true

output.elasticsearch:
  hosts: "elastic:9200"
  index: filebeat

setup.template.enabled: false
#setup.template.name: filebeat
#setup.template.pattern: "filebeat-*"

logging.metrics.enabled: false
EOF

  touch .setup
}

function _start {
  # _setup
  exec ./filebeat -e -d autodiscover,docker
}


case $1 in
  start) _start;;
  *)       exec $@;;
esac

