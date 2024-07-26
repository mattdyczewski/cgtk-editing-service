#!/bin/bash

LAMBDA_FUNCTION_NAME="cgtk-editing-service"
REGION="us-east-2"

if [ -f "deployment_package.zip" ]; then
    rm "deployment_package.zip"
    if [ $? -eq 0 ]; then
        echo "Existing ZIP file removed successfully."
    else
        echo "Failed to remove existing ZIP file."
        exit 1
    fi
fi

if [ -f "deployment_package" ]; then
    rm -rf "deployment_package"
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

# Update Lambda function code
aws lambda update-function-code --function-name "$LAMBDA_FUNCTION_NAME" --zip-file fileb://"deployment_package.zip" --region "$REGION"

# Check if the update was successful
if [ $? -eq 0 ]; then
    echo "Lambda function code updated successfully."
else
    echo "Failed to update Lambda function code."
    exit 1
fi
