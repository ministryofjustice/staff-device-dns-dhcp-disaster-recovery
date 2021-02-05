#!/bin/bash
set -euo pipefail

read -pr "Which environment are you restoring? 'development'/'pre-production'/'production': " env
if [ ! "$env" = "development" ] || [ ! "$env" = "pre-production" ] || [ ! "$env" = "production" ]; then
   echo "Please enter a valid environment";
   exit 1;
fi

read -pr "Which service you want to restore? 'dns'/'dhcp': " service
if [ ! "$service" = "dns" ] || [ ! "$service" = "dhcp" ]; then
  echo "Please enter 'dns' or 'dhcp'.";
  exit 1;
fi

aws ecr describe-images \
    --query 'reverse(sort_by(imageDetails,& imagePushedAt))[:5]' \
    --repository-name staff-device-"$env"-"$service"-docker --no-paginate --output json | jq '.[] | {imageDigest: .imageDigest, imagePushedAt: .imagePushedAt, imageTags: .imageTags[0]}'

read -pr "Copy and paste the imageDigest to roll back to: " imageDigest
MANIFEST=$(aws ecr batch-get-image --repository-name staff-device-"$env"-"$service"-docker --image-ids imageDigest="$imageDigest" --query images[].imageManifest --output text)
aws ecr put-image --repository-name staff-device-"$env"-"$service"-docker --image-tag latest --image-manifest "$MANIFEST"
echo "Succesfully rolled back to version: $imageDigest"
exit
