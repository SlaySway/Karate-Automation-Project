#Author: Ravindra Pallerla
@ignore
Feature: Runner helper for Jarvis application apis

  Background: Set config
    * string fairsUrl = "/bookfairs-jarvis/api/private/fairs"
    * string currentFairUrl = "/bookfairs-jarvis/api/user/fairs/current"
    * string homePageEventsPostUri = "/bookfairs-jarvis/api/user/fairs/current/homepage/events"

  @fairsRunnerHelper
  Scenario: Run getFairs api
    * def schCall = call read('classpath:utils/ExternalCookiesRunner.feature@ExternalSCHCookieRunner'){USER_ID : '#(userId)', PWD : '#(pwd)'}
    * def SCH_Cookie =  schCall.SCHL_SESSION
    Given url BOOKFAIRS_JARVIS_URL + fairsUrl
    And headers {Content-Type : 'application/json', Cookie : '#(SCH_Cookie)'}
    When method get
    Then def HttpStatusCd = responseStatus
    And def ResponseString = response

  @currentFairRunnerHelper
  Scenario: Run currentFair api
    * def schCall = call read('classpath:utils/ExternalCookiesRunner.feature@ExternalSCHCookieRunner'){USER_ID : '#(userId)', PWD : '#(pwd)'}
    * def SCH_Cookie =  schCall.SCHL_SESSION
    Given url BOOKFAIRS_JARVIS_URL + currentFairUrl
    And headers {Content-Type : 'application/json', Cookie : '#(SCH_Cookie)'}
    * def jsonBody = {inputpayLoad : '#(jsonInput)'}
    And request jsonBody.inputpayLoad
    When method PUT
    Then def HttpStatusCd = responseStatus
    And def ResponseString = response

  @createHomePageEventRunnerHelper
  Scenario: Run currentFair api
    * def schCall = call read('classpath:utils/ExternalCookiesRunner.feature@BFSRunner'){USER_ID : '#(userId)', PWD : '#(pwd)', FAIR_ID : '#(FairID)'}
    * def BFS_SCH_Cookie =  schCall.BFS_SCHL
    * def BFS_JARVIS_Cookie =  schCall.JARVIS_FAIR_SESSION
    And print BFS_SCH_Cookie
    And print BFS_JARVIS_Cookie
    Given url BOOKFAIRS_JARVIS_URL + homePageEventsPostUri
    And cookies {SCHL : '#(BFS_SCH_Cookie)', SBF_JARVIS : '#(BFS_JARVIS_Cookie)'}
    * def jsonBody = {inputpayLoad : '#(jsonInput)'}
    And request jsonBody.inputpayLoad
    When method POST
    Then def HttpStatusCd = responseStatus
    And def ResponseString = response
