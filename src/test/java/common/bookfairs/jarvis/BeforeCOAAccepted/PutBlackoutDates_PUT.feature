@PutBlackoutDatesTest
Feature: PutBlackoutDates API automation tests

  Background: Set config
    * string putBlackoutDatesUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/settings/dates/blackout-dates"
    * def obj = Java.type('utils.StrictValidation')

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
    * def putBlackoutDatesResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PutBlackoutDates')
    Then match putBlackoutDatesResponse.responseStatus == 200

    Examples:
      | USER_NAME                           | PASSWORD  | FAIRID_OR_CURRENT|
      | azhou1@scholastic.com               | password1 | 5633533          |
      | sdevineni-consultant@scholastic.com | passw0rd  | 5782071          |
  #      With current keyword test is getting failed
#      | sdevineni-consultant@scholastic.com | passw0rd  | current         |
#      | azhou1@scholastic.com               | password1 | current         |

  Scenario Outline: Validate regression using dynamic comparison || fairId=<FAIR_ID>
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
    * def TargetResponseMap = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PutBlackoutDates')
    * def BaseResponseMap = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PutBlackoutDatesBase')
    Then match BaseResponseMap.responseStatus == TargetResponseMap.responseStatus
    Then match BaseResponseMap.response == TargetResponseMap.response

    * string base = BaseResponseMap.response
    * string target = TargetResponseMap.response
    * def compResult = obj.strictCompare(base, target)
    Then print "Response from production code base", base
    Then print "Response from current qa code base", target
    Then print 'Differences any...', compResult
    And match base == target

    Examples:
      | USER_NAME                           | PASSWORD  | FAIRID_OR_CURRENT|
      | azhou1@scholastic.com               | password1 | 5633533          |
      | sdevineni-consultant@scholastic.com | passw0rd  | 5644038          |
#      | sdevineni-consultant@scholastic.com | passw0rd  | current         |
#      | azhou1@scholastic.com               | password1 | current         |

  Scenario Outline: Validate PutBlackoutDates API with a valid fairId SCHL and Session Cookie
    * def getCookie = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair')
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
    * def putBlackoutDatesResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PutBlackoutDates')
    Then match putBlackoutDatesResponse.responseStatus == 200
    * print putBlackoutDatesResponse.response

    Examples:
      | USER_NAME                           | PASSWORD  | FAIRID_OR_CURRENT|
      | azhou1@scholastic.com               | password1 | 5633533          |
      | sdevineni-consultant@scholastic.com | passw0rd  | 5644038          |

  Scenario Outline: Validate PutBlackoutDates API with current keyword SCHL and Session Cookie
    * def getCookie = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair')
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
    * def putBlackoutDatesResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PutBlackoutDates')
    Then match putBlackoutDatesResponse.responseStatus == 200
    * print putBlackoutDatesResponse.response

    Examples:
      | USER_NAME                           | PASSWORD  | FAIRID_OR_CURRENT|
      | azhou1@scholastic.com               | password1 | current          |
      | sdevineni-consultant@scholastic.com | passw0rd  | current          |

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
    * def putBlackoutDatesResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PutBlackoutDates')
    Then match putBlackoutDatesResponse.responseStatus == 403

    Examples:
      | USER_NAME                           | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com               | password1 | 56335             |
