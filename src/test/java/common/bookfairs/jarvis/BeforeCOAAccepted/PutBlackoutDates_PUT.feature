@PutBlackoutDatesTest
Feature: PutBlackoutDates API automation tests

  Background: Set config
    * string putBlackoutDatesUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/settings/dates/blackout-dates"

  Scenario Outline: Validate with a valid fairId or current keyword
    * def requestBody =
     """
       {
    "blackoutDates": {
    "deliveryBlackoutDates": [
      "11-09-2023"
     ],
      "pickupBlackoutDates": [
      "17-11-2023"
     ]
    }
   }
      """
    * def putBlackoutDatesResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PutBlackoutDates'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>',REQUEST_BODY : '#(requestBody)'}
    Then match putBlackoutDatesResponse.responseStatus == 200

    Examples:
      | USER_NAME                           | PASSWORD  | fairIdOrCurrent |
      | azhou1@scholastic.com               | password1 | 5633533         |
      | sdevineni-consultant@scholastic.com | passw0rd  | 5782071         |
  #      With current keyword test is getting failed
#      | sdevineni-consultant@scholastic.com | passw0rd  | current         |
#      | azhou1@scholastic.com               | password1 | current         |

  Scenario Outline: Validate PutBlackoutDates API with a valid fairId SCHL and Session Cookie
    * def getCookie = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){FAIRID_OR_CURRENT : '<fairIdOrCurrent>'}
    * def requestBody =
     """
       {
    "blackoutDates": {
    "deliveryBlackoutDates": [
      "11-09-2023"
     ],
      "pickupBlackoutDates": [
      "17-11-2023"
     ]
    }
   }
      """
    * def putBlackoutDatesResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PutBlackoutDates'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>',REQUEST_BODY : '#(requestBody)'}
    Then match putBlackoutDatesResponse.responseStatus == 200
    * print putBlackoutDatesResponse.response

    Examples:
      | USER_NAME                           | PASSWORD  | fairIdOrCurrent |
      | azhou1@scholastic.com               | password1 | 5633533         |
      | sdevineni-consultant@scholastic.com | passw0rd  | 5644038         |

  Scenario Outline: Validate PutBlackoutDates API with current keyword SCHL and Session Cookie
    * def getCookie = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){FAIRID_OR_CURRENT : '<fairIdOrCurrent>'}
    * def requestBody =
     """
       {
    "blackoutDates": {
    "deliveryBlackoutDates": [
      "11-09-2023"
     ],
      "pickupBlackoutDates": [
      "17-11-2023"
     ]
    }
   }
      """
    * def putBlackoutDatesResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PutBlackoutDates'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>',REQUEST_BODY : '#(requestBody)'}
    Then match putBlackoutDatesResponse.responseStatus == 200
    * print putBlackoutDatesResponse.response

    Examples:
      | USER_NAME                           | PASSWORD  | fairIdOrCurrent |
      | azhou1@scholastic.com               | password1 | current         |
      | sdevineni-consultant@scholastic.com | passw0rd  | current         |

  Scenario Outline: Validate with invalid fairId or current keyword
    * def requestBody =
     """
       {
    "blackoutDates": {
    "deliveryBlackoutDates": [
      "11-09-2023"
     ],
      "pickupBlackoutDates": [
      "17-11-2023"
     ]
    }
   }
      """
    * def putBlackoutDatesResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PutBlackoutDates'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>',REQUEST_BODY : '#(requestBody)'}
    Then match putBlackoutDatesResponse.responseStatus == 403

    Examples:
      | USER_NAME                           | PASSWORD  | fairIdOrCurrent |
      | azhou1@scholastic.com               | password1 | 56335           |
