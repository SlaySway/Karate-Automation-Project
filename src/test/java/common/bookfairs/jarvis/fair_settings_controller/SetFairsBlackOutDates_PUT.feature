@setFairBlkOutDatesTest
Feature: SetFairsBlackoutDates API automation tests

  Background: Set config
    * string setFairBlackOutDatesUri = "/bookfairs-jarvis/api/user/fairs/current/settings/dates/blackout-dates"
    * def setFairSettingsBlackOut_ReqBody =
      """
      {
      "blackoutDates": {
       "deliveryBlackoutDates": [
         "10-15-2023"
       ],
       "pickupBlackoutDates": [
         "10-10-2023"
       ]
      }
      }
      """

  Scenario Outline: Validate when session cookies are not passed
    Given url BOOKFAIRS_JARVIS_URL + setFairBlackOutDatesUri
    And request setFairSettingsBlackOut_ReqBody
    When method put
    Then match responseStatus == 401

    Examples: 
      | USER_NAME                    | PASSWORD |
      | sd-consultant@scholastic.com | passw0rd |

  Scenario Outline: Validate when session cookies are invalid
    Given url BOOKFAIRS_JARVIS_URL + setFairBlackOutDatesUri
    And cookies {SCHL : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e', SBF_JARVIS : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e'}
    And request setFairSettingsBlackOut_ReqBody
    When method put
    Then match responseStatus == 401

    Examples: 
      | USER_NAME                    | PASSWORD |
      | sd-consultant@scholastic.com | passw0rd |

  Scenario Outline: Validate when request body is missing
    * def ResponseDataMap = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@setFairsBlkOutDatesRunner'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID : '<FAIR_ID>'}
    Then match ResponseDataMap.StatusCode == 415
    And print ResponseDataMap.ResponseString

    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID | DELIVERY_DATE | PICKUP_DATE |
      | sdevineni-consultant@scholastic.com | passw0rd | 5383023 | 2023-10-15    | 2023-10-10  |

  Scenario Outline: Validate 200 response code for a valid request
    * def Input_PayloadBody =
      """
      {
        "blackoutDates": {
          "deliveryBlackoutDates": [
            '<DELIVERY_DATE>'
          ],
          "pickupBlackoutDates": [
            '<PICKUP_DATE>'
          ]
        }
      }
      """
    * def ResponseDataMap = call read('classpath:common/bookfairs/jarvis/fair_settings_controller/FairSettingsRunnerHelper.feature@setFairsBlkOutDatesRunner'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID : '<FAIR_ID>', setFairsBlackOutDates_Input : '#(Input_PayloadBody)'}
    Then match ResponseDataMap.StatusCode == 200
    And print ResponseDataMap.ResponseString

    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID | DELIVERY_DATE | PICKUP_DATE |
      | sdevineni-consultant@scholastic.com | passw0rd | 5383023 | 2023-10-15    | 2023-10-10  |
      | sdevineni-consultant@scholastic.com | passw0rd | 5734325 | 2023-10-15    | 2023-10-10  |
