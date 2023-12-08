@getUserFairsTest @public&userTests @PerformanceEnhancement
Feature: GetUserFairs API automation tests

  Background: Set config
    * string getUserFairsURL = "/bookfairs-jarvis/api/user/fairs"
    * def obj = Java.type('utils.StrictValidation')

  Scenario: Validate request when SCHL session is not passed
    Given url BOOKFAIRS_JARVIS_URL + getUserFairsURL
    And method get
    Then status 401

  Scenario: Validate request when SCHL session is invalid
    Given url BOOKFAIRS_JARVIS_URL + getUserFairsURL
    And cookies { SCHL : 'abcdeabcdeabcdeabcdeabcdeabcde12345.abcd'}
    And method get
    Then status 401

  Scenario Outline: Validate a 200 status code for a valid request
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    Given url BOOKFAIRS_JARVIS_URL + getUserFairsURL
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And method get
    Then status 200

    @QA
    Examples:
      | USER_NAME              | PASSWORD |
      | mtodaro@scholastic.com | passw0rd |

  Scenario Outline: Validate regression | <USER_NAME>
    * def TargetCall = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    Given url BOOKFAIRS_JARVIS_URL + getUserFairsURL
    And cookies { SCHL : '#(TargetCall.SCHL)'}
    And method get
    Then def TargetStatusCd = responseStatus
    Then string TargetResponse = response
    * def BaseCall = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunnerBase')
    Given url BOOKFAIRS_JARVIS_BASE + getUserFairsURL
    And cookies { SCHL : '#(BaseCall.SCHL)'}
    And method get
    Then def BaseStatusCd = responseStatus
    Then string BaseResponse = response
    Then match BaseStatusCd == TargetStatusCd
    * def compResult = obj.strictCompare(BaseResponse, TargetResponse)
    Then print "Response from production code base", BaseResponse
    Then print "Response from current qa code base", TargetResponse
    Then print 'Differences any...', compResult
    And match BaseResponse == TargetResponse

    @QA
    Examples:
      | USER_NAME                                              | PASSWORD  |
      #| mtodaro@scholastic.com                                 | passw0rd  |
      #| amomin-consultant@scholastic.com                       | Bookfair2 |
      #| sdevineni-consultant@scholastic.com                    | passw0rd  |
      | RPallerla-consultant@Scholastic.com                    | Test@1234 |
      #| qaeduc032@gmail.com                                    | passw0rd  |
      | bradpitt@gmail.com                                     | passw0rd  |
      #| slam@scholastic.com                                    | passw0rd  |
      #| userhas.OnlyPastFairs@schl.com                         | passw0rd  |
      | HasRecentlyEnded.AndOnlyUpcomingandPastFairs@schol.com | passw0rd  |
      | upcomingAndPastFairs@schol.com                         | passw0rd  |
