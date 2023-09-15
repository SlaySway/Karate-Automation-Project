#Author: Ravindra Pallerla

@currentFairTest
Feature: CurrentFair API automation tests

  Background: Set config
    * string currentFairUrl = "/bookfairs-jarvis/api/user/fairs/current"

  Scenario Outline: Validate http response code 204
    * def reqBody =
      """
      {
          "fairId": '<FAIR_ID>'
      }
      """
    * def Response = call read('classpath:utils/JarvisRunnerHelper.feature@currentFairRunnerHelper'){userId : '<USER_NAME>', pwd : '<PASSWORD>', jsonInput : '#(reqBody)'}
    Then match Response.HttpStatusCd == 204
    And print Response.ResponseString

		@QA
    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5387380 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5383023 |
      
      @PROD
    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5387380 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5383023 |
      
      Scenario Outline: Validate when fairid is missing
    * def reqBody =
      """
      {
          "fairId": '<FAIR_ID>'
      }
      """
    * def Response = call read('classpath:utils/JarvisRunnerHelper.feature@currentFairRunnerHelper'){userId : '<USER_NAME>', pwd : '<PASSWORD>', jsonInput : '#(reqBody)'}
    Then match Response.HttpStatusCd == 400
    And print Response.ResponseString

		@QA
    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd |  |
      
        Scenario Outline: Validate when fairid is invalid
    * def reqBody =
      """
      {
          "fairId": '<FAIR_ID>'
      }
      """
    * def Response = call read('classpath:utils/JarvisRunnerHelper.feature@currentFairRunnerHelper'){userId : '<USER_NAME>', pwd : '<PASSWORD>', jsonInput : '#(reqBody)'}
    Then match Response.HttpStatusCd == 403
    And print Response.ResponseString

		@QA
    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 538738000 |
      
       Scenario Outline: Validate when input is empty
    * def reqBody =
      """
      {
      }
      """
    * def Response = call read('classpath:utils/JarvisRunnerHelper.feature@currentFairRunnerHelper'){userId : '<USER_NAME>', pwd : '<PASSWORD>', jsonInput : '#(reqBody)'}
    Then match Response.HttpStatusCd == 400
    And print Response.ResponseString

		@QA
    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 538738000 |