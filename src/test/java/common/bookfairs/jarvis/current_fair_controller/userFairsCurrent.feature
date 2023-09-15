#Author: Ravindra Pallerla
@currentFairsTest
Feature: userCurrentFairs API automation tests

  Background: Set config
    * string userCurrentFairsUrl = "/bookfairs-jarvis/api/user/fairs/current"

  Scenario Outline: Validate when fairid is missing
    * def reqBody =
      """
      {
          "fairId": '<FAIR_ID>'
      }
      """
    * def Response = call read('classpath:utils/RunnerHelper.feature@currentFairsTarget'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', jsonInput : '#(reqBody)'}
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
    * def Response = call read('classpath:utils/RunnerHelper.feature@currentFairsTarget'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', jsonInput : '#(reqBody)'}
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
    * def Response = call read('classpath:utils/RunnerHelper.feature@currentFairsTarget'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', jsonInput : '#(reqBody)'}
    Then match Response.StatusCode == 400
    And print Response.ResponseString

    @QA
    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID   |
      | sdevineni-consultant@scholastic.com | passw0rd | 538738000 |

  Scenario Outline: Validate response code 204 with valid input request
    * def reqBody =
      """
      {
          "fairId": '<FAIR_ID>'
      }
      """
    * def Response = call read('classpath:utils/RunnerHelper.feature@currentFairsTarget'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', jsonInput : '#(reqBody)'}
    Then match Response.StatusCode == 204
    And print Response.ResponseString

    @QA
    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5387380 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5383023 |
