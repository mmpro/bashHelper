#!/usr/bin/env bash
# Move PM2 logs to S3
# Author: Mark Poepping, mmpro https://github.com/mmpro
#
# Please consult README for details
#


source config.txt
aws configure set default.region $REGION


echo "Starting moving PM2 logs to AWS S3"
find $LOGPATH -mtime $MTIME -size +0 | while read line
do

FILENAME="${line##*/}"

MONTH=$(echo $FILENAME | grep -Eo '[[:digit:]]{4}-[[:digit:]]{2}')
if [ -z $MONTH ]; then
MONTH="MISC"
fi

SERVICE=`expr match "$FILENAME" '\(\w*\)'`
REMOTE=$(echo $HOSTNAME-$FILENAME)
S3PATH=$BUCKET/$FOLDER/$MONTH/$SERVICE/$REMOTE
echo "Moving file $line to $S3PATH"
aws s3 cp $line s3://$S3PATH

if [[ $? -eq 0 ]] && [ $CLEANUP == 1 ]; then
rm $line
fi

echo ""
done
