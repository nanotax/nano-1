#!/bin/bash
# Check for first argument, a name of first service.
if [ -z "$1" ]
  then
    echo "Need to provide a name of first service."
    exit 
fi

# print out list of current repositories
echo "`date '+%Y-%m-%d %H:%M:%S'` | Current list of repositories:"
echo "----------------------------------"
aws ecr describe-repositories
echo "----------------------------------"

# add new repository
echo "`date '+%Y-%m-%d %H:%M:%S'` | Add repository $1"
echo "----------------------------------"
aws ecr create-repository --repository-name $1
echo "----------------------------------"

# ask user to specify GITHUB Personal Access Token
echo "`date '+%Y-%m-%d %H:%M:%S'` | Add GITHUB source"
echo -n "`date '+%Y-%m-%d %H:%M:%S'` | Please provide GITHUB Personal Access Token: "
read token

# import security credentials from GITHUB
echo "`date '+%Y-%m-%d %H:%M:%S'` |   importing source credentials"
echo "----------------------------------"
credentials=$(aws codebuild import-source-credentials --token $token --server-type GITHUB --auth-type PERSONAL_ACCESS_TOKEN)
echo $credentials
echo "----------------------------------"

# extract aws account id from the resulting JSON, to be used later
awsAccountId=`echo $credentials | cut -d ":" -f 6`

# ask the user to provide Source URL for the GITHUB project
echo -n "`date '+%Y-%m-%d %H:%M:%S'` | Please provide GITHUB source URL: "
read sourceUrl

# ask the user to provide the name of the Code Build project, default will be provided if nothing is entered
echo -n "`date '+%Y-%m-%d %H:%M:%S'` | Please provide new Code Build Project Name [$1-build]: "
read projectName

# check if user did not provide any input
if [ -z "$projectName" ]
then
  # set default project name
  projectName="$1-build"
  echo "`date '+%Y-%m-%d %H:%M:%S'` |   defaulting to: $projectName"
fi

# as the user to provide the AWS role that will be running Code Build projects, default will be provided if nothing is entered
echo -n "`date '+%Y-%m-%d %H:%M:%S'` | Please provide AWS Code Build runner role [ecr-codebuild-runner-role]: "
read role

# check if user did not provide any input
if [ -z "$role" ]
then
  # set default role name
  role="ecr-codebuild-runner-role"
  echo "`date '+%Y-%m-%d %H:%M:%S'` |   defaulting to: $role"
fi

# create Code Build project
# AWS Account ID will be passed to the Code Build project as an ENV parameter "AWS_ACCOUNT_ID"
echo "`date '+%Y-%m-%d %H:%M:%S'` |   creating Code Build Project"
echo "----------------------------------"
aws codebuild create-project --name "$projectName" --source "type=GITHUB,location=$sourceUrl" --artifacts "type=NO_ARTIFACTS" --environment "type=LINUX_CONTAINER,image=aws/codebuild/standard:2.0,privilegedMode=true,computeType=BUILD_GENERAL1_SMALL,environmentVariables=[{name=AWS_ACCOUNT_ID,value=$awsAccountId,type=PLAINTEXT}]" --service-role "$role"
echo "----------------------------------"

# start Code Build project
echo "`date '+%Y-%m-%d %H:%M:%S'` | Start build for $projectName"
echo "----------------------------------"
aws codebuild start-build --project-name $projectName
echo "----------------------------------"

# add WebHook to trigger project build on any changes to the GITHUB source
echo "`date '+%Y-%m-%d %H:%M:%S'` | Setup Webhook for $sourceUrl"
echo "----------------------------------"
aws codebuild create-webhook --project-name $projectName
echo "----------------------------------"