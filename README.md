# Staff device DNS DHCP disaster recovery

This repo contains an interactive script which can be used to roll back a corrupt config file for the [DNS](https://github.com/ministryofjustice/staff-device-dns-server) or [DHCP](https://github.com/ministryofjustice/staff-device-dhcp-server) services.

## Prerequisites

- (AWS Vault)[https://github.com/99designs/aws-vault#installing] configured for the corrupted environment
- (jq)[https://stedolan.github.io/jq/] 

## Recovering from a Disaster
In the event that Grafana has alerted on a disaster scenario, find the correct section and follow the steps provided.

### Corrupt Config 
1. Identify the broken service (dns/dhcp) and environment (development/pre-production/production)
2. Run:
   1. `aws-vault exec CORRUPT_ENVIRONMENT_VAULT_PROFILE_NAME -- make restore-dns-dhcp-config`
   2. At the prompt, enter the environment name (development/pre-production/production)
   3. At the second prompt, enter the corrupt service name (dns/dhcp)
   4. You will be given an output of the last five published configs with their `VersionId` and `LastModified`
   5. Copy the `VersionId` of the config you wish to restore to
   6. At the final prompt, paste the `VersionId`
   7. The terminal will exit with the following command: `Successfully rolled back dhcp to version: VersionId`

### Corrupt Container
1. Identify the broken service (dns/dhcp) and environment (development/pre-production/production)
2. Run:
   1. `aws-vault exec CORRUPT_ENVIRONMENT_VAULT_PROFILE_NAME -- make restore-service-container`
   2. At the prompt, enter the environment name (development/pre-production/production)
   3. At the second prompt, enter the corrupt service name (dns/dhcp)
   4. You will be given an output of the last five pushed containers with their `imageDigest` and `imagePushedAt`
   5. Copy the `imageDigest` of the container you wish to re-tag as latest
   6. At the final prompt, paste the `imageDigest`
   7. The terminal will exit with the following command: `Successfully re-tagged image: imageDigest as latest`

