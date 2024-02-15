@ResetPassword
Feature: Canada Toolkit ResetPassword API Tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * string loginUri = "/api/user/login"

  @Unhappy
  Scenario Outline: Validate when user inputs incorrect credentials for response body, email:<EMAIL> and password:<PASSWORD>
    * def REQUEST_BODY =
    """
      {
        "email": "#(EMAIL)",
        "password": "#(PASSWORD)"
      }
    """
    Given def loginResponse = call read('RunnerHelper.feature@Login')
    Then match loginResponse.responseStatus == 403
    Then match loginResponse.response.message == "Invalid credentials."

    @QA
    Examples:
      | EMAIL                  | PASSWORD  |
      | azhou1@scholastic.coms | 144220BM  |
      | azhou1@scholastic.com  | 144220BMs |

  @Unhappy @QA
  Scenario: Validate when user inputs invalid media type of response body, email:<EMAIL> and password:<PASSWORD>
    * def REQUEST_BODY = ""
    Given def loginResponse = call read('RunnerHelper.feature@Login')
    Then match loginResponse.responseStatus == 415

  @Unhappy @QA
  Scenario: Validate when user inputs incorrect response body, email:<EMAIL> and account password:<PASSWORD>
    * def REQUEST_BODY = null
    Given def loginResponse = call read('RunnerHelper.feature@Login')
    Then match loginResponse.responseStatus == 400

  @Happy
  Scenario Outline: Validate when user inputs correct value for response body, email:<EMAIL> and password:<PASSWORD>
    * def REQUEST_BODY =
    """
      {
        "email": "#(EMAIL)",
        "password": "#(PASSWORD)"
      }
    """
    Given def loginResponse = call read('RunnerHelper.feature@Login')
    Then match loginResponse.responseStatus == 200
    Then match loginResponse.response.message == "Successful"

    @QA
    Examples:
      | EMAIL                 | PASSWORD |
      | azhou1@scholastic.com | 144220BM |