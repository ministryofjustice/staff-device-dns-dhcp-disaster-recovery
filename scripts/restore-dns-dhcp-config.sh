#!/bin/bash
set -euo pipefail

export AWS_PROFILE=moj-staff-device-production
export PAGER=cat

read -p "Which service you want to restore? 'dns'/'dhcp': " service
case $service in
   ("dns") key=named.conf;;
   ("dhcp") key=config.json;;
   (*) echo "Please enter 'dns' or 'dhcp'."; exit 1;;
esac

aws s3api list-object-versions --bucket staff-device-production-$service-config-bucket | jq '[.Versions [] | {VersionId: .VersionId, LastModified: .LastModified}][:5]'

read -p "Copy and paste the VersionId to roll back to: " version
aws s3api get-object --bucket staff-device-production-$service-config-bucket --key $key --version-id $version $key
aws s3api put-object --bucket staff-device-production-$service-config-bucket --key $key --body $key
rm -f $key
echo "Succesfully rolled back $service to version: $version"
exit