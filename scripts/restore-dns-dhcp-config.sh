#!/bin/bash
set -euo pipefail

read -p "Which environment are you restoring? 'development'/'pre-production'/'production': " env
if [ !"$env" = "development" ] || [ !"$env" = "pre-production" ] || [ !"$env" = "production" ]; then
   echo "Please enter a valid environment";
   exit 1;
fi

read -p "Which service you want to restore? 'dns'/'dhcp': " service
case $service in
   ("dns") key=named.conf;;
   ("dhcp") key=config.json;;
   (*) echo "Please enter either 'dns' or 'dhcp'"; exit 1;;
esac

aws s3api list-object-versions --bucket staff-device-$env-$service-config-bucket | jq '[.Versions [] | {VersionId: .VersionId, LastModified: .LastModified}][:5]'

read -p "Copy and paste the VersionId to roll back to: " version
aws s3api get-object --bucket staff-device-$env-$service-config-bucket --key $key --version-id $version $key > /dev/null
aws s3api put-object --bucket staff-device-$env-$service-config-bucket --key $key --body $key > /dev/null
rm -f $key
echo "Succesfully rolled back $service to version: $version"
exit
