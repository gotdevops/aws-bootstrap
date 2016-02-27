# aws-bootstrap

## Credentials

```
aws_bootstrap_aws_access_key
aws_bootstrap_aws_secret_key
```

AWS CLI Profile for Credentials
http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-multiple-profiles

Are looked up from AWS cli file. Located in ~/.aws/credentials 

## How To

1. Setup Credentials using the AWS CLI Configure Command. See Credentials above.
2. Ensure Ansible >= 2.0 is installed
3. Correctly set all variables in setup/settings.yml
4. execute ./run-setup (this will create a hidden .bootstrap folder)
5. execute ./run
6. go get a snack or coffee or something... it'll take a bit
