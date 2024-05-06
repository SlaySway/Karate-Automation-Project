@SetFliers
Feature: Canada Toolkit set fliers API tests

  Background: Set config
    * string setFliersUri = "/api/user/fairs/<resourceId>/fliers"

  Scenario Outline: Validate when changing values of fliers to values different from original for fair: <FAIRID_OR_CURRENT>
    * def REQUEST_BODY =
    """
    {
      "sixthAndAbove": 0,
      "fifthAndBelow": 1
    }
    """
    Given def response = call read('RunnerHelper.feature@SetFliers'){FAIR_ID:<FAIRID_OR_CURRENT>}
    Then match response.responseStatus == 200
    * def getCMDMFairSettingsResponse = call read('classpath:common/cmdm/canada/RunnerHelper.feature@GetFairRunner'){FAIR_ID:<FAIRID_OR_CURRENT>}
    * match getCMDMFairSettingsResponse.response.fairInfo.numberOfFliersFiveAndBelowGrades == REQUEST_BODY.fifthAndBelow
    * match getCMDMFairSettingsResponse.response.fairInfo.numberOfFliersSixAndAboveGrades == REQUEST_BODY.sixthAndAbove
    * def REQUEST_BODY =
    """
    {
      "sixthAndAbove": 1,
      "fifthAndBelow": 0
    }
    """
    Given def response = call read('RunnerHelper.feature@SetFliers'){FAIR_ID:<FAIRID_OR_CURRENT>}
    Then match response.responseStatus == 200
    * def getCMDMFairSettingsResponse = call read('classpath:common/cmdm/canada/RunnerHelper.feature@GetFairRunner'){FAIR_ID:<FAIRID_OR_CURRENT>}
    * match getCMDMFairSettingsResponse.response.fairInfo.numberOfFliersFiveAndBelowGrades == REQUEST_BODY.fifthAndBelow
    * match getCMDMFairSettingsResponse.response.fairInfo.numberOfFliersSixAndAboveGrades == REQUEST_BODY.sixthAndAbove
    * def REQUEST_BODY =
    """
    {
      "sixthAndAbove": 999,
      "fifthAndBelow": 999
    }
    """
    Given def response = call read('RunnerHelper.feature@SetFliers'){FAIR_ID:<FAIRID_OR_CURRENT>}
    Then match response.responseStatus == 200
    * def getCMDMFairSettingsResponse = call read('classpath:common/cmdm/canada/RunnerHelper.feature@GetFairRunner'){FAIR_ID:<FAIRID_OR_CURRENT>}
    * match getCMDMFairSettingsResponse.response.fairInfo.numberOfFliersFiveAndBelowGrades == REQUEST_BODY.fifthAndBelow
    * match getCMDMFairSettingsResponse.response.fairInfo.numberOfFliersSixAndAboveGrades == REQUEST_BODY.sixthAndAbove

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5196693           |

  Scenario Outline: Validate bounds for the fliers for fair: <FAIRID_OR_CURRENT>
    * def REQUEST_BODY = read('SetFliersRequests.json')[requestBody]
    Given def response = call read('RunnerHelper.feature@SetFliers'){FAIR_ID:<FAIRID_OR_CURRENT>}
    * print response.response
    Then match response.responseStatus == 400

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | requestBody     |
      | azhou1@scholastic.com | password1 | 5196693           | sumOfFliersZero |
      | azhou1@scholastic.com | password1 | 5196693           | sixthAt1000     |
      | azhou1@scholastic.com | password1 | 5196693           | fifthAt1000     |
      | azhou1@scholastic.com | password1 | 5196693           | sixthNegative   |
      | azhou1@scholastic.com | password1 | 5196693           | fifthNegative   |
      | azhou1@scholastic.com | password1 | 5196693           | sixthMissing    |
      | azhou1@scholastic.com | password1 | 5196693           | fifthMissing    |

  Scenario Outline: Validate when user uses invalid media type: <FAIRID_OR_CURRENT>
    * def REQUEST_BODY = ""
    Given def response = call read('RunnerHelper.feature@SetFliers'){FAIR_ID:<FAIRID_OR_CURRENT>}
    * print response.response
    Then match response.responseStatus == 415

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5196693           |

  @Security
  Scenario Outline: Validate no authorization cookie provided for get events for fair: <FAIRID_OR_CURRENT>
    * replace setFliersUri.resourceId = FAIRID_OR_CURRENT
    * url CANADA_TOOLKIT_URL + setFliersUri
    * def REQUEST_BODY =
    """
    {
      "sixthAndAbove": 999,
      "fifthAndBelow": 999
    }
    """
    * request REQUEST_BODY
    Then method PUT
    Then match responseStatus == 204
    Then match responseHeaders['Sbf-Ca-Reason'] == ["NO_USER_EMAIL"]

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5196693           |