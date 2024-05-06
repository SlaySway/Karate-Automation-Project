@PutBlackoutDatesTest @PerformanceEnhancement
Feature: PutBlackoutDates API automation tests

  Background: Set config
    * string putBlackoutDatesUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/settings/dates/blackout-dates"
    * def obj = Java.type('utils.StrictValidation')

  Scenario Outline: Validate with a valid fairId
    * def requestBody =
     """
       {
    "blackoutDates": {
    "deliveryBlackoutDates": [
     ],
      "pickupBlackoutDates": [
     ]
    }
   }
      """
    * def putBlackoutDatesResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PutBlackoutDates')
    Then match putBlackoutDatesResponse.responseStatus == 200
    # TODO for Swayamsree: In order to test functionality:
      # set blackout dates empty
      # check that blackout dates is empty
      # select one random blackout date within range of deliveryWindow and pickupWindow
        # ^ random date must be on a weekday
      # set blackout dates to the randomly chosen days
      # check that backout dates is now updated

    @QA
    Examples:
      | USER_NAME              | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com  | password1 | 5694296           |
      | azhou1@scholastic.com  | password1 | current           |
      | mtodaro@scholastic.com | passw0rd  | 5736341           |
      | mtodaro@scholastic.com | passw0rd  | 5736340           |
      | mtodaro@scholastic.com | passw0rd  | 5736339           |
      | mtodaro@scholastic.com | passw0rd  | 5736338           |
      | mtodaro@scholastic.com | passw0rd  | 5736341           |
      | mtodaro@scholastic.com | passw0rd  | 5736341           |
      | mtodaro@scholastic.com | passw0rd  | 5736341           |
      | mtodaro@scholastic.com | passw0rd  | 5736341           |
      | mtodaro@scholastic.com | passw0rd  | 5736341           |

  @QA
  Scenario Outline: Validate different response bodies for blackout dates for fair <FAIRID_OR_CURRENT>
    * def requestBody = read('PutBlackoutDates.json')[FAIRID_OR_CURRENT][requestBodyJsonPath]
    * def putBlackoutDatesResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PutBlackoutDates')
    Then match putBlackoutDatesResponse.responseStatus == 200
    * def expectedResponse = read('PutBlackoutDates.json')[FAIRID_OR_CURRENT][requestBodyJsonPath + "Response"]
    * def getDatesResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@GetCOAdates')
    Then match getDatesResponse.response == expectedResponse



    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | requestBodyJsonPath                          |
      | azhou1@scholastic.com | password2 | 5694296           | emptyBlackoutDates                           |
      | azhou1@scholastic.com | password2 | 5694296           | emptyDeliveryDatesPopulatedElevenPickupDates |
      | azhou1@scholastic.com | password2 | 5694296           | populatedElevenDeliveryDatesEmptyPickupDates |
      | azhou1@scholastic.com | password2 | 5694296           | populatedElevenBlackoutDates                 |
      | azhou1@scholastic.com | password2 | 5694296           | blackoutDayBeforeFairAndAfterFair            |
      | azhou1@scholastic.com | password2 | 5694296           | swapDates                                    |
      | azhou1@scholastic.com | password2 | 5694296           | arbitraryDates                               |
      | azhou1@scholastic.com | password2 | 5694296           | swapDates                                    |
      | azhou1@scholastic.com | password2 | 5694296           | swapDates                                    |
      | azhou1@scholastic.com | password2 | 5694296           | swapDates                                    |
      | azhou1@scholastic.com | password2 | 5694296           | swapDates                                    |
      | azhou1@scholastic.com | password2 | 5694296           | swapDates                                    |


  Scenario Outline: Validate regression using dynamic comparison || fairId=<FAIRID_OR_CURRENT>
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

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password2 | 5694296           |
      | azhou1@scholastic.com | password2 | current           |

  Scenario Outline: Validate PutBlackoutDates API with invalid login session and valid fairId
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
    And replace putBlackoutDatesUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + putBlackoutDatesUri
    And cookies { SCHL : eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoSMyNTYifQ.eyJpc3MiOiJNeVNjaGwiLCJhdWQiOiJTY2hvbGFzdGljIiwibmJmIjoxNzAxMzY1MzUyLCJzdWIiOiI5ODMwMzM2MSIsImlhdCI6MTcwMTM2NTM1NywiZXhwIjoxNzAxMzY3MTU3fQ.RuNxPupsos4pRP7GVeYoUTM_bxxHfXS4FWpf_bZaeZs}
    And request requestBody
    And method PUT
    Then match responseStatus == 401

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password2 | 5694296           |

  Scenario Outline: Validate PutBlackoutDates API with valid login session and a invalid fairId
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
    And replace putBlackoutDatesUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + putBlackoutDatesUri
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunnerBase')
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And request requestBody
    And method PUT
    Then match responseStatus == 403

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password2 | 57752YU           |

  Scenario Outline: Validate with current keyword valid SCHL and invalid fairsession
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
    * def sbf_jarvis = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair')
    And replace putBlackoutDatesUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + putBlackoutDatesUri
    And cookies { SCHL : '#(sbf_jarvis.SCHL)',SBF_JARVIS  :eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoSMyNTYifQ}
    And request requestBody
    And method PUT
    Then match responseStatus == 400

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password2 | current           |

  Scenario Outline: Validate PutBlackoutDates API with SCHL Session Cookie and no request payload
    * def requestBody = ""
    * def putBlackoutDatesResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PutBlackoutDates')
    Then match putBlackoutDatesResponse.responseStatus == 415

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password2 | 5775209           |

  @Unhappy
  Scenario Outline: Validate when user doesn't have access to CPTK for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    Given def getCoaDatesResponse = call read('RunnerHelper.feature@GetCOAdates')
    Then match getCoaDatesResponse.responseStatus == 204
    And match getCoaDatesResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_ASSOCIATED_RESOURCES"

    @QA
    Examples:
      | USER_NAME           | PASSWORD  | FAIRID_OR_CURRENT |
      | nofairs@testing.com | password1 | current           |

  @Unhappy
  Scenario Outline: Validate when SCHL cookie is not passed for fair:<FAIRID_OR_CURRENT>
    * replace putBlackoutDatesUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    * url BOOKFAIRS_JARVIS_URL + putBlackoutDatesUri
    Given method get
    Then match responseStatus == 204
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SCHL"

    @QA
    Examples:
      | FAIRID_OR_CURRENT |
      | 5694296           |

  @Unhappy
  Scenario Outline: Validate when user uses an invalid fair ID for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    Given def getCoaDatesResponse = call read('RunnerHelper.feature@PutBlackoutDates')
    Then match getCoaDatesResponse.responseStatus == 404
    And match getCoaDatesResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "MALFORMED_RESOURCE_ID"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | requestBody |
      | azhou1@scholastic.com | password2 | abc1234           | {}          |
