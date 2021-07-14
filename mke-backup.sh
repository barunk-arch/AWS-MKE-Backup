#!/usr/bin/env bash
source /home/ec2-user/backup.env
# set -x
function error_exit {
  echo "$1" >&2   ## Send message to stderr. Exclude >&2 if you don't want it that way.
  exit "${2:-1}"  ## Return a code specified by $2 or 1 by default.
}

[[ -z $MKE_URL ]] && error_exit "you must specify a UCP URL to backup from"


echo "Performing UCP backup against cluster at $MKE_URL"

docker container run \
    --rm \
    --log-driver none \
    --security-opt label=disable \
    --name mke-backup \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    mirantis/ucp:3.4.2 backup \
    --no-passphrase  > "/var/$(date --iso-8601)-$(hostname)-mke-backup.tar"

# TODO: Rotate backups
