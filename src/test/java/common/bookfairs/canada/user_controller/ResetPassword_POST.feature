@ResetPassword
Feature: Canada Toolkit ResetPassword API Tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * string resetPasswordUri = "/api/user/resetpwd"

  @Happy
  Scenario Outline: Validate when user doesn't have access to CPTK for user:<USER_NAME> and fair:<FAIRID_OR_CURRENT>
    * def REQUEST_BODY = {}
    Given def deleteHomepageEventsResponse = call read('RunnerHelper.feature@DeleteHomepageEvents')
    Then match deleteHomepageEventsResponse.responseStatus == 204
    And match deleteHomepageEventsResponse.responseHeaders['Sbf-Jarvis-Reason'][0] == "NO_ASSOCIATED_FAIRS"

    @QA
    Examples:
      | USER_NAME           | PASSWORD  | FAIRID_OR_CURRENT |
      | nofairs@testing.com | password1 | 5694296           |