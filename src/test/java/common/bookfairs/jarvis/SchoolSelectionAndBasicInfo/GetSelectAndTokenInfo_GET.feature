@GetSelectAndTokenInfoAPI @PerformanceEnhancement
Feature: GetSelectAndTokenInfo GET Api tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * def getSelectAndTokenInfoUri = "/bookfairs-jarvis/api/user/schools/<schoolId>"

  @Happy
  Scenario Outline: Validate when a user doesn't have any associated fairs for user:<USER_NAME>
    Given def getSchoolsResponse = call read('classpath:common/bookfairs/jarvis/SchoolSelectionAndBasicInfo/RunnerHelper.feature@GetSelectAndTokenInfo')
    Then match getSchoolsResponse.responseStatus == 200

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | SCHOOL_ID|
      | azhou1@scholastic.com | password2 | 64807    |