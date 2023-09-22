@getFairDetailTest
Feature: Content Fair detail API automation tests

  Background: Set config
    * string getFairDetailUrl = "/bookfairs-content/api/fairdetail"

  Scenario Outline: Validate a 200 status code for a valid request
    * def ResponseDataMap = call read('classpath:common/bookfairs/content/fair_details/FairDetailsRunnerHelper.feature@getContentFairDetailRunner'){FAIRID : '<FAIR_ID>'}
    Then match ResponseDataMap.StatusCode == 200
    And print ResponseDataMap.ResponseString
    * assert ResponseDataMap.ResponseString.status == 'Not Yet Accepted'
    * assert ResponseDataMap.ResponseString.stfEnabledFlag == 'true'

    Examples:
      | FAIR_ID |
      | 5416059 |
      | 5417273 |
      | 5417911 |
      | 5550650 |
      | 5615142 |

  Scenario Outline: Validate when invalid fair is provided
    Given url BOOKFAIRS_CONTENT_URL + getFairDetailUrl
    And def pathParams = {bookFairId : '#(FAIRID)'}
    And path pathParams.bookFairId
    When method get
    Then match responseStatus == 500

    Examples:
      | FAIR_ID |
      | 54160b  |
      | 54172a  |

  Scenario: Validate when no fairId is provided
    Given url BOOKFAIRS_CONTENT_URL + getFairDetailUrl
    When method get
    Then match responseStatus == 404


