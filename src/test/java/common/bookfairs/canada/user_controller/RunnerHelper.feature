@ignore @report=true
Feature: Helper for running user_controller endpoints

  Background: Set config
    * string resetPasswordUri = "/api/user/resetpwd"

  # Input: REQUEST_BODY
  # Output: response
  @ResetPassword
  Scenario: Run get wallets for fair for user: <USER_NAME> and fair: <FAIRID_OR_CURRENT>
    * url CANADA_TOOLKIT_URL + resetPasswordUri
    * request REQUEST_BODY
    Then method POST