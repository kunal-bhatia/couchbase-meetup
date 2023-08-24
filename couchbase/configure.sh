#!/usr/bin/env bash
set -m

/entrypoint.sh couchbase-server &

# track if setup is complete so we don't try to setup again
FILE=/opt/couchbase/init/setupComplete.txt

sleep 4

echo "Waiting for CouchBase service to start up so we can provision it ";

if ! [ -f "$FILE" ]; then
  echo $COUCHBASE_ADMINISTRATOR_USERNAME ":"  $COUCHBASE_ADMINISTRATOR_PASSWORD

    sleep 10s
    /opt/couchbase/bin/couchbase-cli cluster-init -c 127.0.0.1 \
    --cluster-username $COUCHBASE_ADMINISTRATOR_USERNAME \
    --cluster-password $COUCHBASE_ADMINISTRATOR_PASSWORD \
    --services data,index,query \
    --cluster-ramsize $COUCHBASE_RAM_SIZE \
    --cluster-index-ramsize $COUCHBASE_INDEX_RAM_SIZE \
    --index-storage-setting default

    sleep 2s


  # used to auto create the bucket based on environment variables
  # https://docs.couchbase.com/server/current/cli/cbcli/couchbase-cli-bucket-create.html

  /opt/couchbase/bin/couchbase-cli bucket-create -c localhost:8091 \
  --username $COUCHBASE_ADMINISTRATOR_USERNAME \
  --password $COUCHBASE_ADMINISTRATOR_PASSWORD \
  --bucket $COUCHBASE_BUCKET \
  --bucket-ramsize $COUCHBASE_BUCKET_RAMSIZE \
  --bucket-type couchbase

  sleep 2s

  # used to auto create the sync gateway user based on environment variables
  # https://docs.couchbase.com/server/current/cli/cbcli/couchbase-cli-user-manage.html#examples

  /opt/couchbase/bin/couchbase-cli user-manage \
  --cluster http://127.0.0.1 \
  --username $COUCHBASE_ADMINISTRATOR_USERNAME \
  --password $COUCHBASE_ADMINISTRATOR_PASSWORD \
  --set \
  --rbac-username $COUCHBASE_RBAC_USERNAME \
  --rbac-password $COUCHBASE_RBAC_PASSWORD \
  --roles mobile_sync_gateway[*] \
  --auth-domain local

  sleep 2s

  create indexes using the QUERY REST API
  /opt/couchbase/bin/curl -v http://localhost:8093/query/service \
  -u $COUCHBASE_ADMINISTRATOR_USERNAME:$COUCHBASE_ADMINISTRATOR_PASSWORD \
  -d 'statement=CREATE PRIMARY INDEX idx_persons_id ON persons'


# create file so we know that the cluster is setup and don't run the setup again
  #touch $FILE
fi
  # docker compose will stop the container from running unless we do this
  # known issue and workaround
  tail -f /dev/null
