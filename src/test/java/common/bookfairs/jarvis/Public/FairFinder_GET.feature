@fairFinderTest @public&userTests @PerformanceEnhancement
Feature: FairFinder API automation tests

  Background: Set config
    * string fairFinderURL = "/bookfairs-jarvis/api/public/fairs"
    * string fairFinderURLStage = "/bookfairs-jarvis/api/public/fairs/find"
    * def obj = Java.type('utils.StrictValidation')

  @QA @PROD
  Scenario: Validate request when manadtory input 'searchQuery' is not passed
    Given url BOOKFAIRS_JARVIS_URL + fairFinderURL
    And params {offset : '0', size:'100'}
    And method get
    Then match responseStatus == 400

  @QA @PROD
  Scenario: Validate request when manadtory input 'offset' is not passed
    Given url BOOKFAIRS_JARVIS_URL + fairFinderURL
    And params {searchQuery : 'fair', size:'100'}
    And method get
    Then match responseStatus == 400

  @QA @PROD
  Scenario: Validate request when manadtory input 'size' is not passed
    Given url BOOKFAIRS_JARVIS_URL + fairFinderURL
    And params {searchQuery : 'fair', offset : '0'}
    And method get
    Then match responseStatus == 400

  @QA @PROD
  Scenario: Validate request when size is 0
    Given url BOOKFAIRS_JARVIS_URL + fairFinderURL
    And params {searchQuery : 'fair', offset : '0', size:'0'}
    And method get
    Then match responseStatus == 400

  @QA @PROD
  Scenario: Validate request when size is 101
    Given url BOOKFAIRS_JARVIS_URL + fairFinderURL
    And params {searchQuery : 'fair', offset : '0', size:'101'}
    And method get
    Then match responseStatus == 400

  @QA @PROD
  Scenario: Validate request when size is string
    Given url BOOKFAIRS_JARVIS_URL + fairFinderURL
    And params {searchQuery : 'fair', offset : '0', size:'text'}
    And method get
    Then match responseStatus == 400

  @QA @PROD
  Scenario: Validate request when offset is string
    Given url BOOKFAIRS_JARVIS_URL + fairFinderURL
    And params {searchQuery : 'fair', offset : 'text', size:'10'}
    And method get
    Then match responseStatus == 400

  @QA @PROD
  Scenario: Validate a 200 status code for a valid request
    Given url BOOKFAIRS_JARVIS_URL + fairFinderURL
    And params {searchQuery : 'fair', offset : '0', size:'100'}
    And method get
    Then match responseStatus == 200

  #Delete this scenario after DEC release
  @QA @Regression
  Scenario: Validate regression with current prod version
    Given url BOOKFAIRS_JARVIS_URL + fairFinderURL
    And params {searchQuery : 'fair', offset : '0', size:'100'}
    And method get
    Then string TargetResponse = response
    Then string TargetStatusCd = responseStatus
    Given url BOOKFAIRS_JARVIS_BASE + fairFinderURLStage
    And params {searchQuery : 'fair', offset : '0', size:'100'}
    And method get
    Then string BaseResponse = response
    Then string BaseStatusCd = responseStatus
    Then match BaseStatusCd == TargetStatusCd
    * def compResult = obj.strictCompare(BaseResponse, TargetResponse)
    Then print "Response from production code base", BaseResponse
    Then print "Response from current qa code base", TargetResponse
    Then print 'Differences any...', compResult
    And match BaseResponse == TargetResponse

  #Enable this after DEC release
  @ignore @QA @Regression
  Scenario: Validate regression with current prod version
    Given url BOOKFAIRS_JARVIS_URL + fairFinderURL
    And params {searchQuery : 'fair', offset : '0',, size:'100'}
    And method get
    Then string TargetResponse = response
    Then string TargetStatusCd = responseStatus
    Given url BOOKFAIRS_JARVIS_BASE + fairFinderURL
    And params {searchQuery : 'fair', offset : '0',, size:'100'}
    And method get
    Then string BaseResponse = response
    Then string BaseStatusCd = responseStatus
    Then match BaseStatusCd == TargetStatusCd
    * def compResult = obj.strictCompare(BaseResponse, TargetResponse)
    Then print "Response from production code base", BaseResponse
    Then print "Response from current qa code base", TargetResponse
    Then print 'Differences any...', compResult
    And match BaseResponse == TargetResponse