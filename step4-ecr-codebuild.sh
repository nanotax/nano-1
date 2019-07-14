#!/bin/bash
# Check for first argument, a name of first service.
if [ -z "$1" ]
  then
    echo "Need to provide a path of the service."
    echo "./step4-ecr-codebuild.sh <Path>"
    exit 
fi
cd $1

serviceName=$(basename $1)

echo "version: 0.2
env:
  variables:
    JAVA_HOME: \"/usr/lib/jvm/java-8-openjdk-amd64\"
phases:
  install:
    runtime-versions:
      java: openjdk8
  pre_build:
    commands:
    - echo Logging in to Amazon ECR...
    - \$(aws ecr get-login --no-include-email --region \$AWS_REGION)
  build:
    commands:
    - echo Building Source
    - gradle clean
    - gradle build
    - echo Packaging Docker containers
    - ./buildDockerImage.sh
    finally:
    - echo Finished
  post_build:
    commands:
    - docker tag hello:latest \$AWS_ACCOUNT_ID.dkr.ecr.\$AWS_REGION.amazonaws.com/$serviceName:latest
    - docker push \$AWS_ACCOUNT_ID.dkr.ecr.\$AWS_REGION.amazonaws.com/$serviceName:latest
    finally:
    - echo Finished
cache:
  paths:
  - '/root/.m2/**/*'
" > buildspec.yml

# print out list of current repositories
echo "`date '+%Y-%m-%d %H:%M:%S'` | Current list of repositories:"
echo "----------------------------------"
aws ecr describe-repositories
echo "----------------------------------"

# add new repository
echo "`date '+%Y-%m-%d %H:%M:%S'` | Add repository $serviceName"
newRepository=$(aws ecr create-repository --repository-name "$serviceName")

# ask user to specify GITHUB Personal Access Token
echo "`date '+%Y-%m-%d %H:%M:%S'` | Add GITHUB source"
echo -n "`date '+%Y-%m-%d %H:%M:%S'` | Please provide GITHUB Personal Access Token: "
read token

# import security credentials from GITHUB
echo "`date '+%Y-%m-%d %H:%M:%S'` |   importing source credentials"
credentials=$(aws codebuild import-source-credentials --token $token --server-type GITHUB --auth-type PERSONAL_ACCESS_TOKEN)

# extract aws account id from the resulting JSON, to be used later
awsAccountId=`echo $credentials | cut -d ":" -f 6`

# ask the user to provide Source URL for the GITHUB project
echo -n "`date '+%Y-%m-%d %H:%M:%S'` | Please provide GITHUB source URL: "
read sourceUrl

# ask the user to provide the AWS-Region, default will be provided if nothing is entered
defaultRegion=$(aws configure get region)
echo -n "`date '+%Y-%m-%d %H:%M:%S'` | Please provide AWS Code Build runner role [$defaultRegion]: "
read awsRegion

# check if user did not provide any input
if [ -z "$AWS_REGION" ]
then
  # set default role name
  awsRegion="$defaultRegion"
  echo "`date '+%Y-%m-%d %H:%M:%S'` |   defaulting to: $awsRegion"
fi

# ask the user to provide the name of the Code Build project, default will be provided if nothing is entered
echo -n "`date '+%Y-%m-%d %H:%M:%S'` | Please provide new Code Build Project Name [$serviceName-build]: "
read projectName

# check if user did not provide any input
if [ -z "$projectName" ]
then
  # set default project name
  projectName="$serviceName-build"
  echo "`date '+%Y-%m-%d %H:%M:%S'` |   defaulting to: $projectName"
fi

# ask the user to provide the AWS role that will be running Code Build projects, default will be provided if nothing is entered
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
newProject=$(aws codebuild create-project --name "$projectName" --source "type=GITHUB,location=$sourceUrl" --artifacts "type=NO_ARTIFACTS" --environment "type=LINUX_CONTAINER,image=aws/codebuild/standard:2.0,privilegedMode=true,computeType=BUILD_GENERAL1_SMALL,environmentVariables=[{name=AWS_ACCOUNT_ID,value=$awsAccountId,type=PLAINTEXT},{name=AWS_REGION,value=$awsRegion,type=PLAINTEXT}]" --service-role "$role")

# add WebHook to trigger project build on any changes to the GITHUB source
echo "`date '+%Y-%m-%d %H:%M:%S'` | Setup Webhook for $sourceUrl"
newWebhook=$(aws codebuild create-webhook --project-name "$projectName")
