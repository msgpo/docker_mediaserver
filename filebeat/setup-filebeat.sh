#!/bin/bash
echo "Starting Filebeat custom startup script"

set -euo pipefail

until curl -s "${KIBANA_HOST}/login" | grep "Loading Kibana" > /dev/null; do
      echo "Waiting for kibana..."
      sleep 1
done

echo "Setting up dashboards..."
# https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-template.html#load-template-manually
filebeat setup \
    --index-management \
    --pipelines \
    --modules ${FILEBEAT_MODULES} \
    -E output.logstash.enabled=false \
    -E 'output.elasticsearch.hosts=["${ELASTIC_HOST}"]'