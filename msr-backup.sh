   dtr-notary-signer-000000000001
#!/usr/bin/env bash
source /home/ec2-user/msrbackup.env

[[ -z $UCP_URL ]] && error_exit "you must specify a UCP URL to backup from"
[[ -z $UCP_ADMIN ]] && error_exit "you must specify a UCP URL to backup from
[[ -z $UCP_PASSWORD ]] && error_exit "you must specify a UCP URL to backup from

echo "calling backup against ${MKE_URL} with replica ${MSR_REPLICA_ID} and MSR:${MSR_VERSION} image..."

DTR_VERSION=$(docker container inspect $(docker container ps -f name=dtr-registry -q) | \
  grep -m1 -Po '(?<=DTR_VERSION=)\d.\d.\d'); \
REPLICA_ID=$(docker ps --format '{{.Names}}' -f name=dtr-rethink | cut -f 3 -d '-'); \
docker run --log-driver none -i --rm \
  --env UCP_PASSWORD=$UCP_PASSWORD \
  mirantis/dtr:$DTR_VERSION backup \
  --ucp-username $UCP_ADMIN \
  --ucp-url $UCP_URL \
  --ucp-insecure-tls \
  --existing-replica-id $REPLICA_ID > /tmp/dtr-metadata-${DTR_VERSION}-backup-$(date +%Y%m%d-%H_%M_%S).tar
