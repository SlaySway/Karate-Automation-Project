@PostCOARequestChangeTest
Feature: PostRequestChange API automation tests

  Background: Set config
    * string postCOARequestChangeUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/coa/change-request"
    * def obj = Java.type('utils.StrictValidation')

  Scenario Outline: Validate with a valid fairId or current keyword
    * def requestBody =
     """
       {
        "additionalDetails": '<additionalDetails>',
        "contactMethod": '<Cnt_Method>',
        "reasons": [
        "test"
         ]
        }
      """
    * def postCOAChangeRequestResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PostChangeRequest')
    Then match postCOAChangeRequestResponse.responseStatus == 201

    Examples:
      | USER_NAME                           | PASSWORD  | FAIRID_OR_CURRENT| additionalDetails| Cnt_Method|
      | azhou1@scholastic.com               | password1 | 5633533          | Test1            | Email     |
      | sdevineni-consultant@scholastic.com | passw0rd  | 5782071          | TEST2            | PhoneNum  |
  #      With current keyword test is getting failed
#      | sdevineni-consultant@scholastic.com | passw0rd  | current         | Siva             | Email     |
#      | azhou1@scholastic.com               | password1 | current         | And              | Phn       |

  Scenario Outline: Validate regression using dynamic comparison || fairId=<FAIR_ID>
    * def requestBody =
     """
       {
        "additionalDetails": '<additionalDetails>',
        "contactMethod": '<Cnt_Method>',
        "reasons": [
        "test"
         ]
        }
      """
    * def TargetResponseMap = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PostChangeRequest')
    * def BaseResponseMap = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PostChangeRequestBase')
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
      | USER_NAME                           | PASSWORD  | FAIRID_OR_CURRENT| EMAIL                             | MESSAGE|
      | azhou1@scholastic.com               | password1 | 5633533          |azhou1@scholastic.com              | test   |
      | sdevineni-consultant@scholastic.com | passw0rd  | 5644038          |sdevineni-consultant@scholastic.com| TEST1  |
#      | sdevineni-consultant@scholastic.com | passw0rd  | current         |sdevineni-consultant@scholastic.com| TEST2  |
#      | azhou1@scholastic.com               | password1 | current         |azhou1@scholastic.com              | TEST3  |

  Scenario Outline: Validate PostChangeCOARequest API with a valid fairId SCHL and Session Cookie
    * def getCookie = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair')
    * def requestBody =
     """
       {
        "additionalDetails": '<additionalDetails>',
        "contactMethod": '<Cnt_Method>',
        "reasons": [
        "test"
         ]
        }
      """
    * def postCOAChangeRequestResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PostChangeRequest')
    Then match postCOAChangeRequestResponse.responseStatus == 201
    * print postCOAChangeRequestResponse.response

    Examples:
      | USER_NAME                           | PASSWORD  | FAIRID_OR_CURRENT| additionalDetails| Cnt_Method|
      | azhou1@scholastic.com               | password1 | 5633533          | TEST2            | PhoneNum  |
      | sdevineni-consultant@scholastic.com | passw0rd  | 5644038          | TEST1            | PhoneNum  |

  Scenario Outline: Validate PostChangeCOARequest API with current keyword SCHL and Session Cookie
    * def getCookie = call read('classpath:common/bookfairs/jarvis/SelectionAndBasicInfo/RunnerHelper.feature@SelectFair')
    * def requestBody =
     """
       {
        "additionalDetails": '<additionalDetails>',
        "contactMethod": '<Cnt_Method>',
        "reasons": [
        "test"
         ]
        }
      """
    * def postCOAChangeRequestResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PostChangeRequest')
    Then match postCOAChangeRequestResponse.responseStatus == 201
    * print postCOAChangeRequestResponse.response

    # returning 400 for current keyword everytime
    Examples:
      | USER_NAME                           | PASSWORD  | FAIRID_OR_CURRENT|additionalDetails| Cnt_Method|
      | azhou1@scholastic.com               | password1 | current          |TEST2            | PhoneNum  |
      | sdevineni-consultant@scholastic.com | passw0rd  | current          |TEST3            | PhoneNum  |

  Scenario Outline: Validate with invalid fairId or current keyword
    * def requestBody =
     """
       {
        "additionalDetails": '<additionalDetails>',
        "contactMethod": '<Cnt_Method>',
        "reasons": [
        "test"
         ]
        }
      """
    * def postCOAChangeRequestResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PostChangeRequest')
    Then match postCOAChangeRequestResponse.responseStatus == 403

    Examples:
      | USER_NAME                           | PASSWORD  | FAIRID_OR_CURRENT | additionalDetails| Cnt_Method|
      | azhou1@scholastic.com               | password1 | 56335             | Test1            | Email     |
