#Author: Ravindra Pallerla

@setCoChairsTest
Feature: SetCoChairs API automation tests

  Background: Set config
    * string coCharisUri = "/bookfairs-jarvis/api/private/fairs/current/settings/co-chairs"

  Scenario Outline: Validate when session cookies are not passed
    * def inputBody =
      """
        {
      "co-chairs": [
       {
         "firstName": '<CC_FIRSTNAME>',
         "lastName": '<CC_LASTNAME>',
         "email": '<CC_EMAIL>',
         "salesforceId": '<SF_ID>'
       }
      ]
      }
      """
    Given url BOOKFAIRS_JARVIS_URL + coCharisUri
    And request inputBody
    When method put
    Then match responseStatus == 401

    Examples: 
      | USER_NAME                    | PASSWORD | CC_FIRSTNAME | CC_LASTNAME | CC_EMAIL          | SF_ID |
      | sd-consultant@scholastic.com | passw0rd | Jimmy        | Kies        | jimmyk@qatest.com | E1    |

  Scenario Outline: Validate when sessoion cookies are invalid
    * def inputBody =
      """
        {
      "co-chairs": [
       {
         "firstName": '<CC_FIRSTNAME>',
         "lastName": '<CC_LASTNAME>',
         "email": '<CC_EMAIL>',
         "salesforceId": '<SF_ID>'
       }
      ]
      }
      """
    Given url BOOKFAIRS_JARVIS_URL + coCharisUri
    And cookies {SCHL : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e', SBF_JARVIS : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e'}
    And request inputBody
    When method put
    Then match responseStatus == 401

    Examples: 
      | USER_NAME                    | PASSWORD | CC_FIRSTNAME | CC_LASTNAME | CC_EMAIL          | SF_ID |
      | sd-consultant@scholastic.com | passw0rd | Jimmy        | Kies        | jimmyk@qatest.com | E1    |

  Scenario Outline: Validate 200 response code for a valid request
    * def inputBody =
      """
        {
      "co-chairs": [
       {
         "firstName": '<CC_FIRSTNAME>',
         "lastName": '<CC_LASTNAME>',
         "email": '<CC_EMAIL>'
       }
      ]
      }
      """
    * def ResponseDataMap = call read('classpath:common/bookfairs/jarvis/cochair_controller/CoChairRunnerHelper.feature@coChairsRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>', Input_Body : '#(inputBody)'}
    Then match ResponseDataMap.StatusCode == 200
    And print ResponseDataMap.ResponseString

    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID | CC_FIRSTNAME | CC_LASTNAME | CC_EMAIL             |
      | sdevineni-consultant@scholastic.com | passw0rd | 5734325 | Jimmy        | Kies        | jimmyk@qatest.com    |
      | sdevineni-consultant@scholastic.com | passw0rd | 5734325 | Jo           | Kies        | jokies@qatest.com    |
      | sdevineni-consultant@scholastic.com | passw0rd | 5734325 | QA           | Testing     | qatesting@qatest.com |
