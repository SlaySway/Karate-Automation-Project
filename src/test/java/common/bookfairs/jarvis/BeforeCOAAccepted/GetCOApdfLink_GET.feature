@GetCOApdfLinkTest
Feature: GetCOApdfLink API automation tests

  Background: Set config
    * string getCOApdfLinkUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/coa/pdf-links"
    * def obj = Java.type('utils.StrictValidation')

  Scenario Outline: Validate with a valid fairId or current keyword
    * def getCOApdfLinkResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@GetCOApdfLink')
    Then match getCOApdfLinkResponse.responseStatus == 200
    * print getCOApdfLinkResponse.response

    Examples:
      | USER_NAME                           | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com               | password1 | 5633533           |
      | sdevineni-consultant@scholastic.com | passw0rd  | 5644038           |
      | sdevineni-consultant@scholastic.com | passw0rd  | current           |
      | azhou1@scholastic.com               | password1 | current           |

  Scenario Outline: Validate regression using dynamic comparison || fairId=<FAIR_ID>
    * def BaseResponseMap = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@GetCOApdfLinkBase')
    * def TargetResponseMap = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@GetCOApdfLink')
    Then match BaseResponseMap.responseStatus == TargetResponseMap.responseStatus
    Then match BaseResponseMap.response == TargetResponseMap.response

    * string base = BaseResponseMap.response
    * string target = TargetResponseMap.response
    * def compResult = obj.strictCompare(base, target)
    Then print "Response from production code base", base
    Then print "Response from current qa code base", target
    Then print 'Differences any...', compResult
    And match BaseResponseMap.BaseResponse == TargetResponseMap.TargetResponse

    Examples:
      | USER_NAME                           | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com               | password1 | 5633533           |
      | sdevineni-consultant@scholastic.com | passw0rd  | 5644038           |
    # For current keyword it is giving 400
#      | sdevineni-consultant@scholastic.com | passw0rd  | current           |
#      | azhou1@scholastic.com               | password1 | current           |

  Scenario Outline: Validate GetCOApdfLink API with a valid fairId SCHL and Session Cookie
    * def getFairSessionCookie = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair')
    Then match getFairSessionCookie.responseStatus == 200
    * def getCOApdfLinkResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@GetCOApdfLink')
    Then match getCOApdfLinkResponse.responseStatus == 200
    * print getCOApdfLinkResponse.response

    Examples:
      | USER_NAME                           | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com               | password1 | 5633533           |
      | sdevineni-consultant@scholastic.com | passw0rd  | 5644038           |

  Scenario Outline: Validate GetCOApdfLink API with current keyword SCHL and Session Cookie
    * def getFairSessionCookie = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair')
    Then match getFairSessionCookie.responseStatus == 200
    * def getCOApdfLinkResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@GetCOApdfLink')
    Then match getCOApdfLinkResponse.responseStatus == 200
    * print getCOApdfLinkResponse.response

    Examples:
      | USER_NAME                           | PASSWORD  | FAIRID_OR_CURRENT|
      | azhou1@scholastic.com               | password1 | current          |
      | sdevineni-consultant@scholastic.com | passw0rd  | current          |

  Scenario Outline: Validate with invalid fairId or current keyword
    * def getCOApdfLinkResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@GetCOApdfLink')
    Then match getCOApdfLinkResponse.responseStatus == 403

    Examples:
      | USER_NAME                           | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com               | password1 | 5565              |