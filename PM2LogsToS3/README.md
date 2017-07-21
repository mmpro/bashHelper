This script moves old pm2 log files to S3. PM2 is a great tool for managing NodeJS processes - https://github.com/Unitech/pm2

Use this script on every server to make sure logfiles are moved to S3 after a while

##Prerequisites
Install pm2 module for log rotation with "pm2 install pm2-logrotate" and optionally configure rotation parameters:
```
pm2 install pm2-logrotate

pm2 set pm2-logrotate:max_size 100M
pm2 set pm2-logrotate:compress true
```

Install AWS CLI and configure it: http://docs.aws.amazon.com/cli/latest/userguide/installing.html

Last but not least make the script executable, create a config.txt file and test the script.
```
chmod a+x pm2ToS3.sh
```

If the script is working fine, add it to your crontab service.

```
EXAMPLE:
0 3 * * * bash /opt/pm2ToS3.sh
```

##Configuration
Create a config.txt file and put the following information in it (adjust them to your needs)
```
LOGPATH=/.pm2/logs
MTIME=+3 // move files after 3 days
BUCKET=log-bucket-name-on-aws-s3
FOLDER=myAppLogs
REGION=eu-central-1 // AWS region identifier
CLEANUP=1 // 1 = files are deleted on local after upload is complete
```

