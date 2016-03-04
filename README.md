# aws-bootstrap

## Credentials

AWS CLI Profile for Credentials
http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-multiple-profiles

Are looked up from AWS cli file. Located in ~/.aws/credentials 

Ideally you'll have a separate 'profile' for your provisioning credentials.
So when you run the script below you can use and deploy the correct credentials.

## How To

1. Setup Credentials using the AWS CLI Configure Command. See Credentials above.
2. Ensure Ansible >= 2.0 is installed
3. Ensure Terraform is installed
4. Copy settings-example to settings.yml and then correctly set all variables in setup/settings.yml
5. execute ./setup (this will create a hidden .bootstrap folder)
6a. execute ./run
6b. the script will ask you for the name of the credentials profile. if you just hit enter, it'll use the default profile that you setup in step 1. Otherwise, type in the named profile to use when it asks.
7. ensure it's working and then go get a snack or coffee or something... it'll take a bit
