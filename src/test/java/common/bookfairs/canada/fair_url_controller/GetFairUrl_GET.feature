@GetFairUrl
Feature: Canada Toolkit GetFairUrl API Tests

  Background: Set config
    * string getFairUrlUri = "/api/user/fairs/<resourceId>/homepage/fair-url"

  Scenario Outline: Validate fields returned by get events against mongo and cmdm for fair: <FAIRID_OR_CURRENT>
    Given def response = call read('RunnerHelper.feature@GetFairUrl'){FAIR_ID:<FAIRID_OR_CURRENT>}
    Then match response.responseStatus == 200
    And def AGGREGATE_PIPELINE =
    """
    [
      {
        $match:{
            "fairId":"#(FAIRID_OR_CURRENT)"
        }
      }
    ]
    """
    And def mongoResults = call read('classpath:common/bookfairs/canada/MongoDBRunner.feature@RunAggregate'){collectionName: "fairs"}
    * match response.response.fairUrl.english contains mongoResults.document[0].onlineHomepage.fairUrl.english
    * match response.response.fairUrl.french contains mongoResults.document[0].onlineHomepage.fairUrl.french
    * def getCMDMFairSettingsResponse = call read('classpath:common/cmdm/canada/RunnerHelper.feature@GetFairRunner'){FAIR_ID:<FAIRID_OR_CURRENT>}
    * match getCMDMFairSettingsResponse.response.fairInfo.customEnglishFairUrl == response.response.fairUrl.english
    * match getCMDMFairSettingsResponse.response.fairInfo.customFrenchFairUrl == response.response.fairUrl.french

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5196693           |

  Scenario Outline: Validate no authorization cookie provided for get events for fair: <FAIRID_OR_CURRENT>
    * replace getFairUrlUri.resourceId = FAIRID_OR_CURRENT
    * url CANADA_TOOLKIT_URL + getFairUrlUri
    Then method GET
    Then match responseStatus == 204
    Then match responseHeaders['Sbf-Ca-Reason'] == ["NO_USER_EMAIL"]

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5196693           |

  Scenario Outline: Validate "current" default fair selection to get events for fair: <FAIRID_OR_CURRENT>
    * replace getFairUrlUri.resourceId = FAIRID_OR_CURRENT
    * url CANADA_TOOLKIT_URL + getFairUrlUri
    * cookies {fairId : '#(EXPECTED_FAIR)', userEmail: '#(USER_NAME)'}
    Given method GET
    Then match responseStatus == 200
    Then match responseHeaders['Sbf-Ca-Resource-Id'] == ['#(EXPECTED_FAIR)']

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | EXPECTED_FAIR |
      | azhou1@scholastic.com | password1 | current           | 5196693       |







