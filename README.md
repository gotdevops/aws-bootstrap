# aws-bootstrap

# New Bootstrap Repo

To create a new bootstrap repo:
* create git repo / folder
* cd to_new_repo
* run: git submodule add git@github.com:gotdevops/aws-bootstrap aws-bootstrap
* follow the "How To" below

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
4. Copy aws-bootstrap/bootstrap-settings-example to ../bootstrap-settings.yml and then correctly set all variables 

Then
```
$ cd aws-bootstrap
$ ./setup 
$ ./run
> Which AWS Credentials Profile to use (default): [Enter]
... off it goes

```

** setup creates a hidden .generated folder in the root that contains the bootstrap scripts
