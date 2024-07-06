@GetSchoolsAPI @PerformanceEnhancement
Feature: GetSchools GET Api tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * def schoolsUri = "/bookfairs-jarvis/api/user/schools"

  @Happy
  Scenario Outline: Validate when a user have any associated fairs and schools for user:<USER_NAME>
    Given def getSchoolsResponse = call read('classpath:common/bookfairs/jarvis/SchoolSelectionAndBasicInfo/RunnerHelper.feature@GetSchools')
    Then match getSchoolsResponse.responseStatus == 200
    * def res = getSchoolsResponse.response
     # Define the field name you want to check
    * def schoolName = 'name'
    * def schoolUcn = 'ucn'
    * def schoolBookfairAccountId = 'bookfairAccountId'
    * def foundName = false
    * def foundUcn = false
    * def foundBookfairAccountId = false

    # Iterate through each object in the 'schools' array and check if the field is present
    * eval res.schools.forEach(function(item) { if (item[schoolName] != null) foundName = true; })
    * eval res.schools.forEach(function(item) { if (item[schoolUcn] != null) foundUcn = true; })
    * eval res.schools.forEach(function(item) { if (item[schoolBookfairAccountId] != null) foundBookfairAccountId = true; })

    # Assert that at least one object contains the specified field
    * assert foundName
    * assert foundUcn
    * assert foundBookfairAccountId

    @QA
    Examples:
      | USER_NAME             | PASSWORD  |
      | azhou1@scholastic.com | password2 |
      | mtodaro@scholastic.com| passw0rd  |

  @Happy
  Scenario Outline: Validate when a user doesn't have any associated fairs for user:<USER_NAME>
    Given def schlResponse = call read('classpath:common/iam/IAMRunnerHelper.feature@SCHLCookieRunner')
    * url BOOKFAIRS_JARVIS_URL
    * path schoolsUri
    * cookies { SCHL : #(schlResponse.SCHL)}
    Given method get
    Then match responseStatus == 204
    And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_ASSOCIATED_RESOURCES"

    @QA
    Examples:
      | USER_NAME           | PASSWORD  |
      | nofairs@testing.com | password1 |

    @Happy @QA
    Scenario: Validate when no SCHL cookie is passed in header
      * url BOOKFAIRS_JARVIS_URL
      * path schoolsUri
      Given method get
      Then match responseStatus == 204
      And match responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_SCHL"

    @Unhappy @QA
    Scenario: Validate when invalid path is passed
      * url BOOKFAIRS_JARVIS_URL
      * path "/bookfairs-jarvis/api/user/school"
      Given method get
      Then match responseStatus == 404

    @Unhappy @QA
    Scenario: Validate when PUT method is called instead of GET
      * url BOOKFAIRS_JARVIS_URL
      * path schoolsUri
      Given method put
      Then match responseStatus == 405
      Then match response.error == 'Method Not Allowed'

    @Regression
    Scenario Outline: Validate regression using dynamic comparison || username=<USER_NAME>
      * def BaseResponseMap = call read('RunnerHelper.feature@GetSchools')
      * def TargetResponseMap = call read('RunnerHelper.feature@GetSchoolsBase')
      * string base = BaseResponseMap.response
      * string target = TargetResponseMap.response
      * def compResult = obj.strictCompare(base, target)
      Then print "Response from current qa code base", BaseResponseMap.response
      Then print "Response from production code base", TargetResponseMap.response
      Then print 'Differences any...', compResult

      Examples:
        | USER_NAME             | PASSWORD  |
        | azhou1@scholastic.com | password2 |
        | mtodaro@scholastic.com| passw0rd  |

