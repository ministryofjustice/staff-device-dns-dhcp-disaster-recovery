# Staff device DNS DHCP disaster recovery
This repo contains an interactive script which can be used to roll back a corrupt config file for the [DNS](https://github.com/ministryofjustice/staff-device-dns-server) or [DHCP](https://github.com/ministryofjustice/staff-device-dhcp-server) services. This script will directly publish the config file into the production s3 bucket, any subsequent admin portal updates will override this restored file.

## Prerequisites:
- Docker
- Production [AWS credentials](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) configured locally.
- Profile name must be `moj-staff-device-production`

## How to run this script
1. Clone this repo locally.
2. Run `make run`
3. Select the service, either 'dns' or 'dhcp'. Do not include the quotes.
4. Select the version of the configuration based on the timestamp.
5. When prompted, copy and paste the selected version id that you would like to roll back to.