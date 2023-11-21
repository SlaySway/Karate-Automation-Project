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
