@UpdateHomepageDetailsTest
Feature: Update HomepageDetails API automation tests

  Background: Set config
    * string updateHomepageDetailsUrl = "/bookfairs-jarvis/api/user/fairs/current/homepage"

  Scenario Outline: Validate 200 response code for a valid request
    * def Input_PayloadBody =
      """
      {
        "fairId": 5383023,
        "paymentCheckCkbox": "N"
      }
      """
    * def UpdateHomepageDetailsResponseMap = call read('classpath:common/bookfairs/jarvis/homepage_controller/HomepageRunnerHelper.feature@UpdateHomepageDetailsRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>', body : '#(Input_PayloadBody)'}
    Then match UpdateHomepageDetailsResponseMap.StatusCode == 200
    And print UpdateHomepageDetailsResponseMap.ResponseString

    @QA
    Examples:
      | USER_NAME                          | PASSWORD | FAIR_ID |
      | sdevineni-consultant@scholastic.com| passw0rd | 5734325 |



