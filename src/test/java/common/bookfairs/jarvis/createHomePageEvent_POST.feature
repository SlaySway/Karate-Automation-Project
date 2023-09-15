#Author: Ravindra Pallerla
@createHomePageEventsTest
Feature: HomePageEvents POST API automation tests

  Background: Set config
    * string currentFairUrl = "/bookfairs-jarvis/api/user/fairs/current/homepage/events"
    * def getDate =
      """
      function() {
      
      var SimpleDateFormat = Java.type('java.text.SimpleDateFormat');
      var sdf = new SimpleDateFormat('yyyy-MM-dd');
      var date = new java.util.Date();
      return sdf.format(date);
      }
      """
    * def currentDate = getDate()

  Scenario Outline: Validate http response code 204
    * def reqBody =
      """
      [
      {
      "scheduleDate": "2023-10-10",
      "eventCategory": "Family Event",
      "eventName": "Family fun day",
      "startTime": "06:30:00",
      "endTime": "07:30:00",
      "description": "Family fun day.."
      },
      {
      "scheduleDate": "2023-11-10",
      "eventCategory": "Kids Event",
      "eventName": "Kis fun day",
      "startTime": "06:30:00",
      "endTime": "07:30:00",
      "description": "Kids play time.."
      }
      ]
      """
    * def Response = call read('classpath:utils/JarvisRunnerHelper.feature@createHomePageEventRunnerHelper'){userId : '<USER_NAME>', pwd : '<PASSWORD>', jsonInput : '#(reqBody)', FairID : '<FAIRID>'}
    Then match Response.HttpStatusCd == 204
    And print Response.ResponseString

    Examples: 
      | USER_NAME                           | PASSWORD | FAIRID  |
      | sdevineni-consultant@scholastic.com | passw0rd | 5387380 |
