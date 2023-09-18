#Author: Ravindra Pallerla

@getFairsTest
Feature: Fairs API automation tests

  Background: Set config
    * string ExternalSCHCookieUrl = "/bookfairs-jarvis/api/private/fairs"

  Scenario Outline: Validate http response code 200
    * def Response = call read('classpath:utils/JarvisRunnerHelper.feature@fairsRunnerHelper'){userId : '<USER_NAME>', pwd : '<PASSWORD>'}
    Then match Response.HttpStatusCd == 200
    And print Response.ResponseString

    Examples: 
      | USER_NAME                           | PASSWORD |
      | sdevineni-consultant@scholastic.com | passw0rd |
      | slam@scholastic.com                 | passw0rd |

  Scenario Outline: Validate when email is invalid
    * def Response = call read('classpath:utils/JarvisRunnerHelper.feature@fairsRunnerHelper'){userId : '<USER_NAME>', pwd : '<PASSWORD>'}
    #Then match Response.ResponseStatus == 'success'
    Then print Response.ResponseString

    Examples: 
      | USER_NAME                    | PASSWORD |
      | sd-consultant@scholastic.com | passw0rd |

  Scenario Outline: Validate when password is invalid
    * def Response = call read('classpath:utils/JarvisRunnerHelper.feature@fairsRunnerHelper'){userId : '<USER_NAME>', pwd : '<PASSWORD>'}
    #Then match Response.ResponseStatus == 'success'
    Then print Response.ResponseString

    Examples: 
      | USER_NAME           | PASSWORD  |
      | slam@scholastic.com | passsw0rd |
