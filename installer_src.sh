#!/bin/bash

echo ""
echo "AWS Custom Metrix Installer"
echo ""

if [ "$USER" != "root" ]; then
    echo "This script is required to be run as root."
    exit 1
fi

# instanceId=$(curl -m 3 -s 'http://169.254.169.254/latest/meta-data/instance-id')

# if [ "$instanceId" == "" ]; then
#     echo "Unable to check instanceId.  Please note that this script only works directly on an AWS EC2 instance"
#     exit 1
# fi

if [ ! -d "./aws-scripts" ]; then
    # Create destination folder
    DESTINATION="$PWD/aws-scripts"
    mkdir -p ${DESTINATION}

    echo "Extracting archive ..."

    # Find __ARCHIVE__ maker, read archive content and decompress it
    ARCHIVE=$(awk '/^__ARCHIVE__/ {print NR + 1; exit 0; }' "${0}")
    tail -n+${ARCHIVE} "${0}" | tar xvz -C ${DESTINATION}

    echo "Extracting archive ... done."
fi

if [ -e "./aws-scripts/cloudwatch/.credential" ]; then
    . ./aws-scripts/cloudwatch/.credential
fi

if [ "$AWSAccessKeyId" == "" ] || [ "$AWSSecretKey" == "" ]; then
    echo "Some AWS credentials are found missing. These are required."
    
    while [ "$AWSAccessKeyId" == "" ]; do read -p 'AWSAccessKeyId: ' AWSAccessKeyId ; done
    while [ "$AWSSecretKey" == "" ]; do read -p 'AWSSecretKey: ' AWSSecretKey ; done

    [ ! -e "./aws-scripts/cloudwatch" ] && mkdir -p ./aws-scripts/cloudwatch

    echo "AWSAccessKeyId=$AWSAccessKeyId" > ./aws-scripts/cloudwatch/.credential
    echo "AWSSecretKey=$AWSSecretKey" >> ./aws-scripts/cloudwatch/.credential
fi

if [ ! -e "./aws-scripts/cloudwatch/.ec2_region" ]; then
    echo "Please provide ec2-region for this cloudwatch."

    while [ "$EC2_REGION" == "" ]; do read -p 'EC2_REGION: ' EC2_REGION ; done

    custom_metrics_script=$(cat ./aws-scripts/cloudwatch/custom_metrics_orig.sh)
    custom_metrics_script=$(echo "$custom_metrics_script" | sed -e "s/__EC2_REGION__/$EC2_REGION/g")

    echo "$custom_metrics_script" > ./aws-scripts/cloudwatch/custom_metrics.sh

    chmod u+x aws-scripts/cloudwatch/custom_metrics.sh

    echo "$EC2_REGION" > ./aws-scripts/cloudwatch/.ec2_region
fi

echo ""
echo "Installation complete."
echo ""

exit 0

__ARCHIVE__
