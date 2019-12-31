# Update AWS securitygroups
This bash script helps you to update an array of securitygroups with your current IP address.

# Usage
Create a file named config.txt and add make it look like this:
```
description="DESCRIBE WHY YOU ADD THIS IP"
securitygroups=(
  [sg-abc123]="default 22" // first entry is your AWS profile, the following are ports
  [sg-bcf555]="development 22 80 443"
  ...
)
```