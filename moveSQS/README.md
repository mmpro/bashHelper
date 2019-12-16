Move messages between 2 AWS SQS queues.

# Usage
```
node index.js
```

# Configuration
Set the following variables in the script

Variable | Type | Notes/Example
---|---|---|
sourceQueue | URL to source SQS list | https://sqs.eu-central-1.amazonaws.com/xxxx
targetQueue | URL to target SQS list | https://sqs.eu-central-1.amazonaws.com/xxxx
messageGroupId | SQS messageGroupId |
bucket | S3 bucket | Big messages are stored in S3 as SQS only processes messages <256kb
batchSize | | Number of messages per batch
maxIterations | | How many messages should be processed


### AWS
Also make sure that you have AWS CLI configured. If not, set accessKeyId and accessSecret in AWS.SQS and AWS.S3