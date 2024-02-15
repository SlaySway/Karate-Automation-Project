@ignore @report=true
Feature: Helper for running user_controller endpoints

  Background: Set config
    * string resetPasswordUri = "/api/user/resetpwd"
    * string loginUri = "/api/user/login"

  # Input: REQUEST_BODY
  # Output: response
  @ResetPassword
  Scenario: Run reset password for user: <REQUEST_BODY.email> and fair: <REQUEST_BODY.>
    * url CANADA_TOOLKIT_URL + resetPasswordUri
    * request REQUEST_BODY
    Then method POST

  # Input: REQUEST_BODY
  # Output: response
  @Login
  Scenario: Run get login for user: <REQUEST_BODY.email> and password: <REQUEST_BODY.password>
    * url CANADA_TOOLKIT_URL + loginUri
    * request REQUEST_BODY
    Then method POST