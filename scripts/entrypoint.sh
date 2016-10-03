#!/bin/bash

echo "--------------------------------------"
echo "- AQWest Maven test runner -----------"
echo "--------------------------------------"
mvn -verion
echo "--------------------------------------"

cd /workspace

MODE=$1

# Run sonar
if [[ $MODE == "--sonar" ]]
then
  mvn install sonar:sonar -DskipTests -Dsonar.jdbc.url=jdbc:h2:tcp://sonarqube:9092/sonar -Dsonar.host.url=http://sonarqube:9000 -Dsonar.svn.username=jenkinsci -Dsonar.svn.password.secured=Password1
  exit $?
fi

# generate Allure report
if [[ $MODE == "--run" ]]
then
  echo ""
  echo "cleanup previous build"
  echo ""
  if [ -d "./out/images" ]; then
    rm -R -f "./out/images"
  fi
  if [ -d "./media" ]; then
    rm -R -f "./media"
  fi
  if [ -d "./test-output" ]; then
    rm -R -f "./test-output"
  fi
  if [ -d "./target" ]; then
    rm -R -f "./target"
  fi
  PROJECT=$2  
  if [[ "x${PROJECT}" == "x" ]]; then
   echo "Usage Error :  --run [PROJECT] [CAMPAIGN]";
   exit 1;
  fi
  CAMPAIGN=$3
  if [[ "x${CAMPAIGN}" == "x" ]]; then
   echo "Usage Error :  --run [PROJECT] [CAMPAIGN]";
   exit 1;
  fi
  echo ""
  echo "Running QA "
  echo "- Project  : $PROJECT"
  echo "- Campaign : $CAMPAIGN"
  echo "- Profile  : $AQW_PROFILE"
  echo "- Thread   : $AQW_THREAD_NUMBER"
  echo ""
  mvn clean install exec:java  -DskipTests -Dexec.mainClass="com.west.qa.automation.framework.testrunner.TestNGRunner" -DAQW_PROJECT=$PROJECT -DAQW_CAMPAIGNS=$CAMPAIGN -DAQW_PROFILE=$AQW_PROFILE -DAQW_THREAD_NUMBER=$AQW_THREAD_NUMBER 
  exit $?
fi


# default action : shell
/bin/bash