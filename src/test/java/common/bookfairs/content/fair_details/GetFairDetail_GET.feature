@GetFairDetailTest
Feature: Content Fair detail API automation tests

  Background: Set config
    * string getFairDetailUrl = "/bookfairs-content/api/fairdetail"

  Scenario Outline: Validate a 200 status code for a valid request
    * def getFairDetailsResponse = call read('classpath:common/bookfairs/content/fair_details/FairDetailsRunnerHelper.feature@GetContentFairDetailRunner'){FAIR_ID : '<FAIR_ID>'}
    * print getFairDetailsResponse
    Then match getFairDetailsResponse.responseStatus == 200
    Then match getFairDetailsResponse.response.status == 'Not Yet Accepted'
    Then match getFairDetailsResponse.response.stfEnabledFlag == 'true'

    Examples:
      | FAIR_ID |
      | 5416059 |
      | 5417273 |
      | 5417911 |
      | 5550650 |
      | 5615142 |

  Scenario Outline: Validate when invalid fair is provided
    Given url BOOKFAIRS_CONTENT_URL + getFairDetailUrl
    And def pathParams = {bookFairId : '#(FAIR_ID)'}
    And path pathParams.bookFairId
    When method GET
    Then match responseStatus == 500

    Examples:
      | FAIR_ID |
      | 54160b  |
      | 54172a  |

  Scenario: Validate when no fairId is provided
    Given url BOOKFAIRS_CONTENT_URL + getFairDetailUrl
    When method GET
    Then match responseStatus == 404


