@getCOAWithJWTTest @public&userTests @PerformanceEnhancement
Feature: GetCOAWithJWT API automation tests

  Background: Set config
    * string getCOAWithJWTURL = "/bookfairs-jarvis/api/public/coa/pdf-links"
    * def obj = Java.type('utils.StrictValidation')

  Scenario: Validate request when jwt is not passed
    Then url BOOKFAIRS_JARVIS_URL + getCOAWithJWTURL
    And method get
    Then match responseStatus == 404

  Scenario: Validate request when jwt is invalid
    Then url BOOKFAIRS_JARVIS_URL + getCOAWithJWTURL
    Then path 'eyJraWQiOiJub25wcm9kLTIwMjEzMzExMzMyIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ'
    And method get
    Then match responseStatus == 403

  Scenario Outline: Validate a 200 status code for a valid request
    * def getFairDetailsResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@GetJWTForCOA')
    Then print getFairDetailsResponse.response
    Then string TOKEN = getFairDetailsResponse.response
    Then string finalToken = TOKEN.substring(TOKEN.indexOf("=") + 1)
    And print finalToken
    Then url BOOKFAIRS_JARVIS_URL + getCOAWithJWTURL
    Then path finalToken
    And method get
    Then match responseStatus == 200

    @QA
    Examples: 
      | USER_NAME              | PASSWORD | FAIRID_OR_CURRENT |
      | mtodaro@scholastic.com | passw0rd |           5795068 |

  #Delete this scenraio after the DEC release
  Scenario Outline: Validate regression with current prod version | <USER_NAME> | <FAIRID_OR_CURRENT> |
    * def TargetGetFairDetailsResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@GetJWTForCOA')
    Then print TargetGetFairDetailsResponse.response
    Then string TargetTOKEN = TargetGetFairDetailsResponse.response
    Then string finalTargetToken = TargetTOKEN.substring(TargetTOKEN.indexOf("=") + 1)
    Then url BOOKFAIRS_JARVIS_URL + getCOAWithJWTURL
    Then path finalTargetToken
    And method get
    Then string TargetResponse = response
    * def BaseGetFairDetailsResponse = call read('classpath:common/bookfairs/jarvis/Public/publicRunnerHelper.feature@getCOAWithJWTBase')
    Then print BaseGetFairDetailsResponse.response
    Then string BaseTOKEN = BaseGetFairDetailsResponse.response
    Then string finalBaseToken = BaseTOKEN.substring(BaseTOKEN.indexOf("=") + 1)
    Then url BOOKFAIRS_JARVIS_BASE + getCOAWithJWTURL
    Then path finalBaseToken
    And method get
    Then string BaseResponse = response
    * def compResult = obj.strictCompare(BaseResponse, TargetResponse)
    Then print "Response from production code base", BaseResponse
    Then print "Response from current qa code base", TargetResponse
    Then print 'Differences any...', compResult
    And match BaseResponse == TargetResponse

    @QA
    Examples: 
      | USER_NAME              | PASSWORD | FAIRID_OR_CURRENT |
      | mtodaro@scholastic.com | passw0rd |           5795066 |
      | mtodaro@scholastic.com | passw0rd |           5795071 |
      | mtodaro@scholastic.com | passw0rd |           5797220 |
      | mtodaro@scholastic.com | passw0rd |           5814798 |
      | mtodaro@scholastic.com | passw0rd |           5795061 |
      | mtodaro@scholastic.com | passw0rd |           5795064 |
      | mtodaro@scholastic.com | passw0rd |           5795065 |
      | mtodaro@scholastic.com | passw0rd |           5795067 |
      | mtodaro@scholastic.com | passw0rd |           5795068 |
      | mtodaro@scholastic.com | passw0rd |           5795069 |
      | mtodaro@scholastic.com | passw0rd |           5795070 |
      | mtodaro@scholastic.com | passw0rd |           5795068 |
      | mtodaro@scholastic.com | passw0rd |           5731888 |

  #Enable this after the DEC release
  @ignore
  Scenario Outline: Validate regression  | <USER_NAME> | <FAIRID_OR_CURRENT> |
    * def TargetGetFairDetailsResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@GetJWTForCOA')
    Then print TargetGetFairDetailsResponse.response
    Then string TargetTOKEN = TargetGetFairDetailsResponse.response
    Then string finalTargetToken = TargetTOKEN.substring(TargetTOKEN.indexOf("=") + 1)
    Then url BOOKFAIRS_JARVIS_URL + getCOAWithJWTURL
    Then path finalTargetToken
    And method get
    Then string TargetResponse = response
    * def BaseGetFairDetailsResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@GetJWTForCOABase')
    Then print BaseGetFairDetailsResponse.response
    Then string BaseTOKEN = BaseGetFairDetailsResponse.response
    Then string finalBaseToken = BaseTOKEN.substring(BaseTOKEN.indexOf("=") + 1)
    Then url BOOKFAIRS_JARVIS_BASE + getCOAWithJWTURL
    Then path finalBaseToken
    And method get
    Then string BaseResponse = response
    * def compResult = obj.strictCompare(BaseResponse, TargetResponse)
    Then print "Response from production code base", BaseResponse
    Then print "Response from current qa code base", TargetResponse
    Then print 'Differences any...', compResult
    And match BaseResponse == TargetResponse

    @QA
    Examples: 
      | USER_NAME              | PASSWORD | FAIRID_OR_CURRENT |
      | mtodaro@scholastic.com | passw0rd |           5795066 |
      | mtodaro@scholastic.com | passw0rd |           5795071 |
      | mtodaro@scholastic.com | passw0rd |           5797220 |
      | mtodaro@scholastic.com | passw0rd |           5814798 |
      | mtodaro@scholastic.com | passw0rd |           5795061 |
      | mtodaro@scholastic.com | passw0rd |           5795064 |
      | mtodaro@scholastic.com | passw0rd |           5795065 |
      | mtodaro@scholastic.com | passw0rd |           5795067 |
      | mtodaro@scholastic.com | passw0rd |           5795068 |
      | mtodaro@scholastic.com | passw0rd |           5795069 |
      | mtodaro@scholastic.com | passw0rd |           5795070 |
      | mtodaro@scholastic.com | passw0rd |           5795068 |
      | mtodaro@scholastic.com | passw0rd |           5731888 |
