#!/bin/bash

LAMBDA_FUNCTION_NAME="cgtk-editing-service"
REGION="us-east-2"
FILE_NAME="cgtk-editing-service-deployment-package.zip"
FOLDER_NAME="cgtk-editing-service-deployment-package"
BUCKET_NAME="ttcgtk-bucket"
S3_PATH="s3://$BUCKET_NAME/$FILE_NAME"

if [ -f "$FILE_NAME" ]; then
    rm "$FILE_NAME"
    if [ $? -eq 0 ]; then
        echo "Existing ZIP file removed successfully."
    else
        echo "Failed to remove existing ZIP file."
        exit 1
    fi
fi

if [ -f "$FOLDER_NAME" ]; then
    rm -rf "$FOLDER_NAME"
    if [ $? -eq 0 ]; then
        echo "Existing ZIP file removed successfully."
    else
        echo "Failed to remove existing ZIP file."
        exit 1
    fi
fi

# Create a directory for the deployment package
mkdir deployment_package
cp -r env/lib/python3.10/site-packages/* deployment_package/
cp lambda_function.py deployment_package/

# Zip the deployment package
cd deployment_package
zip -r ../deployment_package.zip .
cd ..

# Upload file to S3
echo "Uploading $FILE_NAME to $S3_PATH"
aws s3 cp $FILE_NAME $S3_PATH

if [ $? -eq 0 ]; then
    rm -rf "$FOLDER_NAME"
    rm "$FILE_NAME"
    echo "Upload successful."
else
    echo "Upload failed."
    rm -rf "$FOLDER_NAME"
    rm "$FILE_NAME"
    exit 1
fi

# Update Lambda function code
aws lambda update-function-code --function-name "$LAMBDA_FUNCTION_NAME" --s3-bucket "$BUCKET_NAME" --s3-key "$FILE_NAME" --region "$REGION"

# Check if the update was successful
if [ $? -eq 0 ]; then
    echo "Lambda function code updated successfully."
else
    echo "Failed to update Lambda function code."
    exit 1
fi
