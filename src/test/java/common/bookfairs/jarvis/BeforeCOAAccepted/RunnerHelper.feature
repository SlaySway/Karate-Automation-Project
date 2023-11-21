@ignore @report=true
Feature: Helper for running Before COA Accepted endpoints

  Background: Set config
    * string getJWTForCOAUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/coa/pdf-links"
    * string getCOAUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/coa"
    * string postChangeRequestUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/coa/change-request"
    * string putConfirmCOAUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/coa/confirmation"
    * string getCOApdfLinkUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/coa/pdf-links"
    * string postCOApdfLinkUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/coa/pdf-links"
    * string getCOAdatesUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/settings/dates"
    * string putBlackoutDatesUri = "/bookfairs-jarvis/api/user/fairs/<fairIdOrCurrent>/settings/dates/blackout-dates"

  # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT
  # Output: response
  @GetJWTForCOA
  Scenario: Get a JWT for COA
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    And replace getJWTForCOAUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + getJWTForCOAUri
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And method GET

  # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT
  # Output: response
  #    * def getCOAResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@GetCOA'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>'}
  @GetCOA
  Scenario: Get COA
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    And replace getCOAUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + getCOAUri
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And method GET

    # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT
  # Output: response
  #    * def getCOAResponseBase = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@GetCOABase'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>'}
  @GetCOABase
  Scenario: Get COA api in base environment
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    And replace getCOAUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_BASE + getCOAUri
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And method GET

    # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT, requestBody
  # Output: response
  #    * def requestChangeResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PostChangeRequest'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>',REQUEST_BODY : '#(requestBody)'}
  @PostChangeRequest
  Scenario: Change COA request
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    And replace postChangeRequestUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + postChangeRequestUri
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And request requestBody
    And method POST

  # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT, requestBody
  # Output: response
  #    * def requestChangeResponseBase = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PostChangeRequestBase'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>',REQUEST_BODY : '#(requestBody)'}
  @PostChangeRequestBase
  Scenario: Change COA request API in base environment
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    And replace postChangeRequestUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_BASE + postChangeRequestUri
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And request requestBody
    And method POST

# Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT
  # Output: response
  #    * def putConfirmCOAResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PutConfirmCOA'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>'}
  @PutConfirmCOA
  Scenario: Confirm COA api
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    And replace putConfirmCOAUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + putConfirmCOAUri
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And method PUT

    # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT
  # Output: response
  #    * def putConfirmCOAResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PutConfirmCOABase'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>'}
  @PutConfirmCOABase
  Scenario: Confirm COA api in the base environment
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    And replace putConfirmCOAUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_BASE + putConfirmCOAUri
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And method PUT

    # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT
  # Output: response
  #    * def getCOApdfLinkResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@GetCOApdfLink'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>'}
  @GetCOApdfLink
  Scenario: Get COA pdf link api
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    And replace getCOApdfLinkUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + getCOApdfLinkUri
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And method GET

    # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT
  # Output: response
  #    * def getCOApdfLinkResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@GetCOApdfLinkBase'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>'}
  @GetCOApdfLinkBase
  Scenario: Get COA pdf link api in base environment
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    And replace getCOApdfLinkUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_BASE + getCOApdfLinkUri
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And method GET

 # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT, requestbody
  # Output: response
  #    * def postCOApdfLinkResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@GetCOApdfLink'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>',REQUEST_BODY : '#(requestBody)'}
  @PostCOApdfLink
  Scenario: Post COA pdf link api
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    And replace postCOApdfLinkUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + postCOApdfLinkUri
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And request requestBody
    And method POST

    # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT, requestbody
  # Output: response
  #    * def postCOApdfLinkResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@GetCOApdfLinkBase'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>',REQUEST_BODY : '#(requestBody)'}
  @PostCOApdfLinkBase
  Scenario: Post COA pdf link api in base environment
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    And replace postCOApdfLinkUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_BASE + postCOApdfLinkUri
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And request requestBody
    And method POST

    # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT
  # Output: response
  #    * def getCOAdatesResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@GetCOAdates'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>'}
  @GetCOAdates
  Scenario: Get COA dates api
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    And replace getCOAdatesUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + getCOAdatesUri
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And method GET

    # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT
  # Output: response
  #    * def getCOAdatesResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@GetCOAdatesBase'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>'}
  @GetCOAdatesBase
  Scenario: Get COA dates api in base environment
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    And replace getCOAdatesUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_BASE + getCOAdatesUri
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And method GET

    # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT, requestBody
  # Output: response
  #    * def putBlackoutDatesResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PutBlackoutDates'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>',REQUEST_BODY : '#(requestBody)'}
  @PutBlackoutDates
  Scenario: Put COA Blackout dates api
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    And replace putBlackoutDatesUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + putBlackoutDatesUri
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And request requestBody
    And method PUT

    # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT, requestBody
  # Output: response
  #    * def putBlackoutDatesResponse = call read('classpath:common/bookfairs/jarvis/BeforeCOAAccepted/RunnerHelper.feature@PutBlackoutDatesBase'){USER_NAME : '<USER_NAME>', PASSWORD : '<PASSWORD>', FAIRID_OR_CURRENT : '<fairIdOrCurrent>',REQUEST_BODY : '#(requestBody)'}
  @PutBlackoutDatesBase
  Scenario: Put COA Blackout dates api in base environment
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    And replace putBlackoutDatesUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_BASE + putBlackoutDatesUri
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And request requestBody
    And method PUT
    And method get

  # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT
  # Output: response
  @GetJWTForCOABase
  Scenario: Get a JWT for COA
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunnerBase')
    And replace getJWTForCOAUri.fairIdOrCurrent = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_BASE + getJWTForCOAUri
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And method get