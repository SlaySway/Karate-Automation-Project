@GetCOATest
Feature: GetFairCOA API automation tests

  Background: Set config
    * string getCOAUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/coa"

  Scenario Outline: Validate with a valid fairId or current keyword
    * def getCOAResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@GetCOA'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>'}
    Then match getCOAResponse.responseStatus == 200
    * print getCOAResponse.response

    Examples:
      | USER_NAME                           | PASSWORD  | fairIdOrCurrent |
      | azhou1@scholastic.com               | password1 | 5633533         |
      | sdevineni-consultant@scholastic.com | passw0rd  | 5644038         |
      | sdevineni-consultant@scholastic.com | passw0rd  | current         |
      | azhou1@scholastic.com               | password1 | current         |

#  Scenario Outline: Validate regression using dynamic comparison || fairId=<FAIR_ID>
#    * def BaseResponseMap = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@GetCOABase'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>'}
#    * def TargetResponseMap = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@GetCOA'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>'}
#    Then match BaseResponseMap.responseStatus == TargetResponseMap.responseStatus
#    Then match BaseResponseMap.response == TargetResponseMap.response
#
#    * string base = BaseResponseMap.response
#    * string target = TargetResponseMap.response
#    * def compResult = obj.strictCompare(base, target)
#    Then print "Response from production code base", base
#    Then print "Response from current qa code base", target
#    Then print 'Differences any...', compResult
#    And match BaseResponseMap.BaseResponse == TargetResponseMap.TargetResponse
#
#    Examples:
#      | USER_NAME                           | PASSWORD  | fairIdOrCurrent |
#      | azhou1@scholastic.com               | password1 | 5633533         |
#      | sdevineni-consultant@scholastic.com | passw0rd  | 5644038         |
#      | sdevineni-consultant@scholastic.com | passw0rd  | current         |
#      | azhou1@scholastic.com               | password1 | current         |

  Scenario Outline: Validate GetCOA API with a valid fairId SCHL and Session Cookie
    * def getFairSessionCookie = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){FAIRID_OR_CURRENT : '<fairIdOrCurrent>'}
    Then match getFairSessionCookie.responseStatus == 200
    * def getCOAResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@GetCOA'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>'}
    Then match getCOAResponse.responseStatus == 200
    * print getCOAResponse.response

    Examples:
      | USER_NAME                           | PASSWORD  | fairIdOrCurrent |
      | azhou1@scholastic.com               | password1 | 5633533         |
      | sdevineni-consultant@scholastic.com | passw0rd  | 5644038         |

  Scenario Outline: Validate GetCOA API with current keyword SCHL and Session Cookie
    * def getFairSessionCookie = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){FAIRID_OR_CURRENT : '<fairIdOrCurrent>'}
    Then match getFairSessionCookie.responseStatus == 200
    * def getCOAResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@GetCOA'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>'}
    Then match getCOAResponse.responseStatus == 200
    * print getCOAResponse.response

    Examples:
      | USER_NAME                           | PASSWORD  | fairIdOrCurrent |
      | azhou1@scholastic.com               | password1 | current         |
      | sdevineni-consultant@scholastic.com | passw0rd  | current         |
