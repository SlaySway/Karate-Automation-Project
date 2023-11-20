@PutConfirmCOATest
Feature: PutCOAConfirm API automation tests

  Background: Set config
    * string putConfirmCOAUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/coa/confirmation"

  Scenario Outline: Validate with a valid fairId or current keyword
    * def putConfirmCOAResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PutConfirmCOA'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>'}
    Then match putConfirmCOAResponse.responseStatus == 200
    * print putConfirmCOAResponse.response

    Examples:
      | USER_NAME                           | PASSWORD  | fairIdOrCurrent |
      | azhou1@scholastic.com               | password1 | 5633533         |
      | sdevineni-consultant@scholastic.com | passw0rd  | 5591611         |
#  current keyword is giving 400
#      | sdevineni-consultant@scholastic.com | passw0rd  | current         |
#      | azhou1@scholastic.com               | password1 | current         |

  #  Scenario Outline: Validate regression using dynamic comparison || fairId=<FAIR_ID>
#    * def BaseResponseMap = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PutConfirmCOABase'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>'}
#    * def TargetResponseMap = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PutConfirmCOA'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>'}
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
#      | sdevineni-consultant@scholastic.com | passw0rd  | 5591611         |
#      | sdevineni-consultant@scholastic.com | passw0rd  | current         |
#      | azhou1@scholastic.com               | password1 | current         |

  Scenario Outline: Validate GetCOA API with a valid fairId SCHL and Session Cookie
    * def getCookie = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){FAIRID_OR_CURRENT : '<fairIdOrCurrent>'}
    Then match getCookie.responseStatus == 200
    * def putConfirmCOAResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){FAIRID_OR_CURRENT : '<fairIdOrCurrent>'}
    Then match putConfirmCOAResponse.responseStatus == 200
    * print putConfirmCOAResponse.response

    Examples:
      | USER_NAME                           | PASSWORD  | fairIdOrCurrent |
      | azhou1@scholastic.com               | password1 | 5633533         |
      | sdevineni-consultant@scholastic.com | passw0rd  | 5591611         |

  Scenario Outline: Validate GetCOA API with current keyword SCHL and Session Cookie
    * def getCookie = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){FAIRID_OR_CURRENT : '<fairIdOrCurrent>'}
    Then match getCookie.responseStatus == 200
    * def putConfirmCOAResponse = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair'){FAIRID_OR_CURRENT : '<fairIdOrCurrent>'}
    Then match putConfirmCOAResponse.responseStatus == 200
    * print putConfirmCOAResponse.response

    Examples:
      | USER_NAME                           | PASSWORD  | fairIdOrCurrent |
      | azhou1@scholastic.com               | password1 | current         |
      | sdevineni-consultant@scholastic.com | passw0rd  | current         |

  Scenario Outline: Validate with invalid fairId or current keyword
    * def putConfirmCOAResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PutConfirmCOA'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>'}
    Then match putConfirmCOAResponse.responseStatus == 403

    Examples:
      | USER_NAME                           | PASSWORD  | fairIdOrCurrent | additionalDetails| Cnt_Method|
      | azhou1@scholastic.com               | password1 | 56335           | Test1            | Email     |
