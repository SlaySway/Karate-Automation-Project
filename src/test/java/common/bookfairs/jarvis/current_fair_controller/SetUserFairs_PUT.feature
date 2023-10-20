@setUserFairsTest
Feature: SetUserFairs API automation tests

  Background: Set config
    * string beginFairSessionUri = "/bookfairs-jarvis/api/user/fairs/current"

  Scenario Outline: Validate when fairid is missing
    * def requestBody =
      """
      {
          "fairId": '<FAIR_ID>'
      }
      """
    * def Response = call read('classpath:common/bookfairs/jarvis/current_fair_controller/CurrentFairRunnerHelper.feature@setUserFairsRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', jsonInput : '#(reqBody)'}
    Then match Response.StatusCode == 400
    And print Response.ResponseString

    @QA
    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd |         |

  Scenario Outline: Validate when fairid is invalid
    * def reqBody =
      """
      {
          "fairId": '<FAIR_ID>'
      }
      """
    * def Response = call read('classpath:common/bookfairs/jarvis/current_fair_controller/CurrentFairRunnerHelper.feature@setUserFairsRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', jsonInput : '#(reqBody)'}
    Then match Response.StatusCode == 403
    And print Response.ResponseString

    @QA
    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID   |
      | sdevineni-consultant@scholastic.com | passw0rd | 538738000 |

  Scenario Outline: Validate when input is empty
    * def reqBody =
      """
      {
      }
      """
    * def Response = call read('classpath:common/bookfairs/jarvis/current_fair_controller/CurrentFairRunnerHelper.feature@setUserFairsRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', jsonInput : '#(reqBody)'}
    Then match Response.StatusCode == 400
    And print Response.ResponseString

    @QA
    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID   |
      | sdevineni-consultant@scholastic.com | passw0rd | 538738000 |

  Scenario Outline: Validate response code 204 with valid input request. GET FAIR SETTING TEST FOR NOW
    * def reqBody =
      """
      {
          "fairId": '<FAIR_ID>'
      }
      """
    * def bookfairsResponse = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@getFairsSettingsRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIR_ID : '<FAIR_ID>'}
    * print "======= BOOKFAIRS RESPONSE ========="
    * print bookfairsResponse
    Then match bookfairsResponse.responseStatus == 200
    * def cmdmResponse = call read('classpath:utils/CMDMRunnerHelper.feature@fairsRunnerHelper'){FAIR_ID: '<FAIR_ID>'}
    * print "======= CMDM RESPONSE ==========="
    * print cmdmResponse
    Then match bookfairsResponse.response.fairInfo.bookfairAccountId == cmdmResponse.response.organization.bookfairAccountId

    @QA
    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | azhou1@scholastic.com | password1 | 5633533 |
