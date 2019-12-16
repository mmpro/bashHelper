const _ = require('lodash')
const async = require('async')

const AWS = require('aws-sdk')

const sqs = new AWS.SQS({
  region: 'eu-central-1'
})

const s3 = new AWS.S3({
  region: 'eu-central-1'
})

const sourceQueue //= 'https://sqs.eu-central-1.amazonaws.com/xxxx'
const targetQueue // = 'https://sqs.eu-central-1.amazonaws.com/xxxx'
const messageGroupId // = 'XXX'
const bucket // = 'xxx'
const batchSize = 1 // max 10
const maxIterations = 1

let messages 
let waiting = 1
let iterations = 0


async.whilst(
  function test(cb) { cb(null, waiting > 0 && iterations <= maxIterations ) },
  function iter(callback) {
    iterations += 1

    async.series({
      fetchMessages: (done) => {
    
        let awsParams = {
          QueueUrl: sourceQueue,
          MaxNumberOfMessages: batchSize
        }
        sqs.receiveMessage(awsParams, (err, result) => {
          if (err) return done(err)
          if (!_.size(result)) {
            waiting = 0
            return done(900)
          }
          messages = _.map(_.get(result, 'Messages'), item => {
            try {
              item.Body = JSON.parse(item.Body)
            }
            catch(e) {
              console.log(e)
            }
            return item
          })
 
          return done()
        })
      },
      checkSize: (done) => {
        async.eachSeries(messages, (message, itDone) => {
          console.log(_.repeat('-', 80))
          console.log('CustomerId', _.get(message, 'Body.customerId'))
          console.log('MediaContainerId', _.get(message, 'Body.mediaContainerId'))
          console.log(_.get(message, 'Body.metadata'))
          let length = JSON.stringify(_.get(message, 'Body')).length
          console.log('Length ', length)
          if (length < 250000) return itDone()
          
          // TODO: HANDLE THE NEXT SECTION WITH CARE - CHECK API HOW s3 Payload shoud look like
          // transfer message to s3 and change message
          let awsParams = {
            Bucket: bucket,
            Key: _.get(message, 'MessageId'),
            Body: Buffer.from(JSON.stringify(_.get(message, 'Body')), 'utf-8'),
            ContentType: 'text/plain'
          }
          s3.putObject(awsParams, (err) => {
            if (err) return itDone(err)
            _.set(message, 'Body.data', 's3:' + _.get(awsParams, 'key'))
            console.log('>>>>>>> UPDATED BODY AFTER S3 UPLOAD >>>>', message.Body.data)
            return itDone()
          })
        }, done)
      },
      sendMessages: (done) => {
      
        let awsParams = {
          QueueUrl: targetQueue,
          Entries: _.map(messages, item => {
          return {
              Id: _.get(item, 'MessageId'),
              MessageBody: JSON.stringify(_.get(item, 'Body')),
              MessageGroupId: messageGroupId,
              MessageDeduplicationId: _.get(item, 'MessageId'),
            }
          })
        }
        sqs.sendMessageBatch(awsParams, (err, data) => {
          if (err) return done(err)
          if (_.size(_.get(data, 'Successful')) === _.size(_.get(awsParams, 'Entries'))) return done()
          console.log('Sending failed', data)
          return done('sending failed')
        });
    
      },
      deleteMessages: (done) => {
        let awsParams = {
          QueueUrl: sourceQueue,
          Entries: _.map(messages, item => {
            return {
                Id: _.get(item, 'MessageId'),
                ReceiptHandle: _.get(item, 'ReceiptHandle')   
              }
            })
          }
          console.log("Delete SQS at origin")
          sqs.deleteMessageBatch(awsParams, done)
        }
    }, err => {
      if (err) console.log(err)
      else console.log('BATCH SUCCESS')
      return callback(err)
    })    
  },
  (err) => {
    console.log('87 WHILST END', err)  
  }
)

