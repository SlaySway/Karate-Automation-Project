@fairFinderByFairIdTest @public&userTests @PerformanceEnhancement
Feature: FairFinderByFairId API automation tests

  Background: Set config
    * string fairFinderByFairIdURL = "/bookfairs-jarvis/api/public/fairs/<fairId>"
    * string fairFinderByFairIdURLStage = "/bookfairs-jarvis/api/fairs/<fairId>"
    * string  fairSettingsURLStage = "/bookfairs-jarvis/api/user/fairs/current/settings"
    * def obj = Java.type('utils.StrictValidation')

  Scenario: Validate request when manadtory path parameter 'fairId' is not passed
    * replace fairFinderByFairIdURL.fairId = ''
    Given url BOOKFAIRS_JARVIS_URL + fairFinderByFairIdURL
    And method get
    Then match responseStatus == 400

  Scenario: Validate request when manadtory path parameter 'fairId' is not valid
    * replace fairFinderByFairIdURL.fairId = '5001234'
    Given url BOOKFAIRS_JARVIS_URL + fairFinderByFairIdURL
    And method get
    Then match responseStatus == 404

  Scenario: Validate request when manadtory path parameter 'fairId' is string
    * replace fairFinderByFairIdURL.fairId = 'abcdtex'
    Given url BOOKFAIRS_JARVIS_URL + fairFinderByFairIdURL
    And method get
    Then match responseStatus == 500

  Scenario: Validate request when manadtory path parameter 'fairId' does not exist
    * replace fairFinderByFairIdURL.fairId = '1112223'
    Given url BOOKFAIRS_JARVIS_URL + fairFinderByFairIdURL
    And method get
    Then match responseStatus == 500

  Scenario Outline: Validate a 200 status code for a valid request
    * replace fairFinderByFairIdURL.fairId = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + fairFinderByFairIdURL
    And method get
    Then match responseStatus == 200

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5694296           |

  #Delete this scenario after DEC release
  Scenario Outline: Validate regression with current prod version | <USER_NAME> | <FAIRID_OR_CURRENT> |
    * replace fairFinderByFairIdURL.fairId = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + fairFinderByFairIdURL
    And method get
    Then string TargetResponse = response
    Then string TargetStatusCd = responseStatus
    * def BaseCall = call read('classpath:common/bookfairs/jarvis/Public/publicRunnerHelper.feature@bookFairServiceGetFairDetails')
    Then string BaseResponse = BaseCall.response
    Then string BaseStatusCd = BaseCall.responseStatus
    Then match BaseStatusCd == TargetStatusCd
    * def compResult = obj.strictCompare(BaseResponse, TargetResponse)
    Then print "Response from production code base", BaseResponse
    Then print "Response from current qa code base", TargetResponse
    Then print 'Differences any...', compResult
#    And match BaseResponse == TargetResponse

    @QA
    Examples:
      | USER_NAME              | PASSWORD | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5694296           |

  #Enable this scenario after DEC release
  @ignore
  Scenario Outline: Validate regression with current prod version | <USER_NAME> | <FAIRID_OR_CURRENT> |
    * replace fairFinderByFairIdURL.fairId = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + fairFinderByFairIdURL
    And method get
    Then string TargetResponse = response
    Then string TargetStatusCd = responseStatus
    Given url BOOKFAIRS_JARVIS_BASE + fairFinderByFairIdURL
    And method get
    Then string BaseResponse = response
    Then string BaseStatusCd = responseStatus
    Then match BaseStatusCd == TargetStatusCd
    * def compResult = obj.strictCompare(BaseResponse, TargetResponse)
    Then print "Response from production code base", BaseResponse
    Then print "Response from current qa code base", TargetResponse
    Then print 'Differences any...', compResult
    And match BaseResponse == TargetResponse

    @QA
    Examples:
      | USER_NAME              | PASSWORD | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5694296           |
