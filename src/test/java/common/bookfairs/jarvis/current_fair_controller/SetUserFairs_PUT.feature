@setUserFairsTest
Feature: SetUserFairs API automation tests

  Background: Set config
    * string beginFairSessionUri = "/bookfairs-jarvis/api/user/fairs/current"

  Scenario Outline: Validate when fairId is missing
    * def requestBody =
      """
      {
          "fairId": '<FAIR_ID>'
      }
      """
    * def Response = call read('classpath:common/bookfairs/jarvis/current_fair_controller/CurrentFairRunnerHelper.feature@SetUserFairsRunner'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>',  REQUEST_BODY: '#(requestBody)'}
    Then match Response.responseStatus == 400

    @QA
    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd |         |

  Scenario Outline: Validate when fairId is invalid
    * def requestBody =
      """
      {
          "fairId": '<FAIR_ID>'
      }
      """
    * def Response = call read('classpath:common/bookfairs/jarvis/current_fair_controller/CurrentFairRunnerHelper.feature@SetUserFairsRunner'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>',  REQUEST_BODY: '#(requestBody)'}
    Then match Response.responseStatus == 403

    @QA
    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID   |
      | sdevineni-consultant@scholastic.com | passw0rd | 123456789 |

  Scenario Outline: Validate when input is empty
    * def requestBody =
      """
      {
      }
      """
    * def Response = call read('classpath:common/bookfairs/jarvis/current_fair_controller/CurrentFairRunnerHelper.feature@SetUserFairsRunner'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>',  REQUEST_BODY: '#(requestBody)'}
    Then match Response.responseStatus == 400

    @QA
    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID   |
      | sdevineni-consultant@scholastic.com | passw0rd | 538738000 |

  Scenario Outline: Validate response code 204 with valid input request. GET FAIR SETTING TEST FOR NOW
    * def requestBody =
      """
      {
          "fairId": '<FAIR_ID>'
      }
      """
    * def Response = call read('classpath:common/bookfairs/jarvis/current_fair_controller/CurrentFairRunnerHelper.feature@SetUserFairsRunner'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>',  REQUEST_BODY: '#(requestBody)'}
    Then match Response.responseStatus == 204

    @QA
    Examples: 
      | USER_NAME             | PASSWORD  | FAIR_ID |
      | azhou1@scholastic.com | password1 | 5633533 |
