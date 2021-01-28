#!/bin/bash
set -euo pipefail

export AWS_PROFILE=moj-pttp-dev
export PAGER=cat

aws ecr describe-images \
    --query 'reverse(sort_by(imageDetails,& imagePushedAt))[:5]' \
    --repository-name staff-device-development-dns-docker --no-paginate --output json | jq '.[] | {imageDigest: .imageDigest, imagePushedAt: .imagePushedAt, imageTags: .imageTags[0]}'

read -p "Copy and paste the imageDigest to roll back to: " imageDigest
MANIFEST=$(aws ecr batch-get-image --repository-name staff-device-development-dns-docker --image-ids imageDigest=$imageDigest --query images[].imageManifest --output text)
aws ecr put-image --repository-name staff-device-development-dns-docker --image-tag latest --image-manifest "$MANIFEST"
echo "Succesfully rolled back to version: $imageDigest"
exit