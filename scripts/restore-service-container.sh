#!/bin/bash
set -euo pipefail

read -p "Which environment are you restoring? 'development'/'pre-production'/'production': " env
if [ !"$env" = "development" ] || [ !"$env" = "pre-production" ] || [ !"$env" = "production" ]; then
  echo "Please enter a valid environment";
  exit 1;
fi

read -p "Which service you want to restore? 'dns'/'dhcp': " service
if [ !"$service" = "dns" ] || [ !"$service" = "dhcp" ]; then
  echo "Please enter 'dns' or 'dhcp'.";
  exit 1;
fi

aws ecr describe-images \
  --query 'reverse(sort_by(imageDetails,& imagePushedAt))[:5]' \
  --repository-name staff-device-"$env"-"$service" --no-paginate --output json | jq '.[] | {imageDigest: .imageDigest, imagePushedAt: .imagePushedAt, imageTags: .imageTags[0]}'

read -p "Copy and paste the imageDigest to re-tag as latest: " imageDigest
MANIFEST=$(aws ecr batch-get-image --repository-name staff-device-"$env"-"$service" --image-ids imageDigest="$imageDigest" --query images[].imageManifest --output text)
aws ecr put-image --repository-name staff-device-"$env"-"$service" --image-tag latest --image-manifest "$MANIFEST"
echo "Successfully re-tagged image: $imageDigest as latest"
exit
