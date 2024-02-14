@ResetPassword
Feature: Canada Toolkit ResetPassword API Tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * string resetPasswordUri = "/api/user/resetpwd"

  @Unhappy
  Scenario Outline: Validate when user inputs incorrect credentials for response body, email:<EMAIL> and account id:<ACCOUNT_ID>
    * def REQUEST_BODY =
    """
      {
        "email": "#(EMAIL)",
        "accountNumber": "#(ACCOUNT_ID)"
      }
    """
    Given def resetPasswordResponse = call read('RunnerHelper.feature@ResetPassword')
    Then match resetPasswordResponse.responseStatus == 404
    Then match resetPasswordResponse.response.message == "Account/Email is incorrect"

    @QA
    Examples:
      | EMAIL                                       | ACCOUNT_ID |
      | nchandrachandola-consultant@scholastic.com  | 76787851   |
      | nchandrachandola-consultant@scholastic.coms | 7678785    |

  @Unhappy @QA
  Scenario: Validate when user inputs incorrect media type of response body, email:<EMAIL> and account id:<ACCOUNT_ID>
    * def REQUEST_BODY = ""
    Given def resetPasswordResponse = call read('RunnerHelper.feature@ResetPassword')
    Then match resetPasswordResponse.responseStatus == 415

  @Unhappy @QA
  Scenario: Validate when user inputs incorrect response body, email:<EMAIL> and account id:<ACCOUNT_ID>
    * def REQUEST_BODY = null
    Given def resetPasswordResponse = call read('RunnerHelper.feature@ResetPassword')
    Then match resetPasswordResponse.responseStatus == 400

  @Happy
  Scenario Outline: Validate when user inputs correct value for response body, email:<EMAIL> and account id:<ACCOUNT_ID>
    * def REQUEST_BODY =
    """
      {
        "email": "#(EMAIL)",
        "accountNumber": "#(ACCOUNT_ID)"
      }
    """
    Given def resetPasswordResponse = call read('RunnerHelper.feature@ResetPassword')
    Then match resetPasswordResponse.responseStatus == 200
    Then match resetPasswordResponse.response.message == "Password generation successful"

    @QA
    Examples:
      | EMAIL                                      | ACCOUNT_ID |
      | nchandrachandola-consultant@scholastic.com | 7678785    |