@GetCOATest
Feature: GetCOA API automation tests

  Background: Set config
    * string getCOAUri = "/bookfairs-jarvis/api/user/fairs/current/coa"
    * def obj = Java.type('utils.StrictValidation')

  Scenario: Validate when session cookies are not passed
    Given url BOOKFAIRS_JARVIS_TARGET + getCOAUri
    When method get
    Then match responseStatus == 401

  Scenario: Validate when sessoion cookies are invalid
    Given url BOOKFAIRS_JARVIS_TARGET + getCOAUri
    And cookies {SCHL : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e', SBF_JARVIS : 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.e'}
    When method get
    Then match responseStatus == 401

  Scenario Outline: Validate 200 response code for a valid request || fairId=<FAIR_ID>
    * def ResponseDataMap = call read('classpath:common/bookfairs/jarvis/coa_controller/COARunnerHelper.feature@GetCOABase'){USER_ID : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID : '<FAIR_ID>'}
    Then match ResponseDataMap.responseStatus == 200

    Examples: 
      | USER_NAME              | PASSWORD | FAIR_ID |
      | mtodaro@scholastic.com | passw0rd | 5782058 |

    # TODO: Figure out schema validation for sure for sure
  Scenario Outline: Validate service response schema || fairId=<FAIR_ID>
    * def ResponseDataMap = call read('classpath:common/bookfairs/jarvis/coa_controller/COARunnerHelper.feature@GetCOABase'){USER_ID : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID : '<FAIR_ID>'}
    Then match ResponseDataMap.responseStatus == 200
    And json ActualResponseSchema = ResponseDataMap.response
    And json ExpectedSchema = call read('classpath:common/bookfairs/jarvis/coa_controller/schemas/GetCOA_schema.json')
    And match ExpectedSchema == ActualResponseSchema

    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5495158 |

  Scenario Outline: Validate fairType 'bogo tabletop' || fairId=<FAIR_ID>
    * def ResponseDataMap = call read('classpath:common/bookfairs/jarvis/coa_controller/COARunnerHelper.feature@GetCOABase'){USER_ID : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID : '<FAIR_ID>'}
    Then match ResponseDataMap.response.fairInfo.fairType == 'bogo tabletop'

    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5638186 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5644037 |

  Scenario Outline: Validate fairType 'Virtual' || fairId=<FAIR_ID>
    * def ResponseDataMap = call read('classpath:common/bookfairs/jarvis/coa_controller/COARunnerHelper.feature@GetCOABase'){USER_ID : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID : '<FAIR_ID>'}
    Then json ResponseObject = ResponseDataMap.TargetResponse
    Then match ResponseObject.fairInfo.fairType == 'Virtual'

    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5731020 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5638188 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5725454 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5731008 |

  Scenario Outline: Validate fairType 'discounted 25%' || fairId=<FAIR_ID>
    * def ResponseDataMap = call read('classpath:common/bookfairs/jarvis/coa_controller/COARunnerHelper.feature@GetCOABase'){USER_ID : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID : '<FAIR_ID>'}
    Then json ResponseObject = ResponseDataMap.TargetResponse
    Then match ResponseObject.fairInfo.fairType == 'discounted 25%'

    Examples: 
      | USER_NAME              | PASSWORD | FAIR_ID |
      | mtodaro@scholastic.com | passw0rd | 5782058 |
      | mtodaro@scholastic.com | passw0rd | 5782061 |
      | mtodaro@scholastic.com | passw0rd | 5782060 |
      | mtodaro@scholastic.com | passw0rd | 5782056 |
      | mtodaro@scholastic.com | passw0rd | 5782055 |
      | mtodaro@scholastic.com | passw0rd | 5782053 |

  Scenario Outline: Validate bookfairAccountId is matching with cmdm bookFairId || FAIR_ID=<FAIR_ID>
    * def ResponseDataMap = call read('classpath:common/bookfairs/jarvis/coa_controller/COARunnerHelper.feature@GetCOABase'){USER_ID : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID : '<FAIR_ID>'}
    * def CMDMResponseDataMap = call read('classpath:common/cmdm/fairs/CMDMRunnerHelper.feature@GetFairRunner'){FAIR_ID : '<FAIR_ID>'}
    Then match ResponseDataMap.BFAcctId == CMDMResponseDataMap.response.organization.bookfairAccountId

    Examples: 
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com | passw0rd | 5495158 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5591617 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5644034 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5725452 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5731880 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5725433 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5576627 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5209377 |

  Scenario Outline: Validate regression using dynamic comaprison || fairId=<FAIR_ID>
    * def BaseResponseMap = call read('classpath:common/bookfairs/jarvis/coa_controller/COARunnerHelper.feature@GetCOABase'){USER_ID : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID : '<FAIR_ID>'}
    * def TargetResponseMap = call read('classpath:common/bookfairs/jarvis/coa_controller/COARunnerHelper.feature@GetCOATarget'){USER_ID : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIR_ID : '<FAIR_ID>'}
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
      | USER_NAME                           | PASSWORD | FAIR_ID |
      | mtodaro@scholastic.com              | passw0rd | 5782058 |
      | mtodaro@scholastic.com              | passw0rd | 5782061 |
      | mtodaro@scholastic.com              | passw0rd | 5782060 |
      | mtodaro@scholastic.com              | passw0rd | 5782056 |
      | mtodaro@scholastic.com              | passw0rd | 5782055 |
      | mtodaro@scholastic.com              | passw0rd | 5782053 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5495158 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5591617 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5644034 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5725452 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5731880 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5725433 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5576627 |
      | sdevineni-consultant@scholastic.com | passw0rd | 5209377 |
      | mtodaro@scholastic.com              | passw0rd | 5782061 |
      | mtodaro@scholastic.com              | passw0rd | 5782060 |
      | mtodaro@scholastic.com              | passw0rd | 5782056 |
      | mtodaro@scholastic.com              | passw0rd | 5782055 |
      | mtodaro@scholastic.com              | passw0rd | 5782053 |