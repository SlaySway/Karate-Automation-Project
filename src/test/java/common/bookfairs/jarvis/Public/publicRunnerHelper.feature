@ignore @report=true
Feature: Helper for running SCHL login api

  Background: Set config
    * string beginFairSessionUri = "/bookfairs-jarvis/api/login/userAuthorization/fairs"
    * string getCOAWithJWTURLStage = "/bookfairs-jarvis/api/user/fairs/current/coa/pdf-links"
    * string  fairSettingsURLStage = "/bookfairs-jarvis/api/user/fairs/current/settings"
    * string  fairFinderByFairIdURLStage = "/bookfairs-jarvis/api/fairs"

    * string getOFEByOrgUCNSUri = "/bookfairs-jarvis/api/public/ofe/school/<schoolUCNs>"

  # Input: USER_NAME, PASSWORD, FAIRID_OR_CURRENT
  # Output: response.SBF_JARVIS
  @getCOAWithJWTBase
  Scenario: Run GetCOAWithJWT api in base environment
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunnerBase')
    Given url BOOKFAIRS_JARVIS_BASE + beginFairSessionUri
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And path FAIRID_OR_CURRENT
    And method get
    Then def SBF_JARVIS = responseCookies.SBF_JARVIS.value
    Then def SCHL = schlResponse.SCHL
    Given url BOOKFAIRS_JARVIS_BASE + getCOAWithJWTURLStage
    And cookies {SCHL : '#(SCHL)', SBF_JARVIS  : '#(SBF_JARVIS)'}
    And method get

  # Input: USER_NAME, PASSWORD, SCHL, SBF_JARVIS
  # Output: response
  @fairFinderByFairIdBase
  Scenario: Run GetFairSettings api in base environment
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunnerBase')
    Given url BOOKFAIRS_JARVIS_BASE + beginFairSessionUri
    And cookies { SCHL : '#(schlResponse.SCHL)'}
    And path FAIRID_OR_CURRENT
    And method get
    Then def SBF_JARVIS = responseCookies.SBF_JARVIS.value
    Then def SCHL = schlResponse.SCHL
    #Given url BOOKFAIRS_JARVIS_BASE + fairSettingsURLStage
    Given url BOOKFAIRS_JARVIS_BASE + fairFinderByFairIdURLStage
    And path FAIRID_OR_CURRENT
    And cookies {SCHL : '#(SCHL)', SBF_JARVIS  : '#(SBF_JARVIS)'}
    And method get

  # Input:FAIRID_OR_CURRENT
  # Output: response
  @bookFairServiceGetFairDetails
  Scenario: Run GetFairDetails api from bookfairs service swagger
    Given url BOOKFAIRS_SERVICE_URL + '/bookfairs-service'
    And path FAIRID_OR_CURRENT
    And method get

  # Input: SCHOOL_UCNS
  # Output: response
  @GetOFEByOrgUCNS
  Scenario: Run GetOFEByOrgUCNS api in base environment
    * replace getOFEByOrgUCNSUri.schoolUCNs = SCHOOL_UCNS
    Given url BOOKFAIRS_JARVIS_URL + getOFEByOrgUCNSUri
    And method get