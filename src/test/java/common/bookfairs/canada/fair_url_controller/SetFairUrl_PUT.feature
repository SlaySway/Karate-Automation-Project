@SetFairUrl
Feature: Canada Toolkit SetFairUrl API Tests

  Background: Set config
    * string setFairUrlUri = "/api/user/fairs/<resourceId>/homepage/fair-url"

  Scenario Outline: Validate set fairUrl sets the url in mongo and cmdm for fair: <FAIRID_OR_CURRENT>
    * def REQUEST_BODY =
    """
    {
      "fairUrl" : '#(fairUri)'
    }
    """
    Given def response = call read('RunnerHelper.feature@SetFairUrl'){FAIR_ID:<FAIRID_OR_CURRENT>}
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
    * match mongoResults.document[0].onlineHomepage.fairUrl.english == fairUri
    * match mongoResults.document[0].onlineHomepage.fairUrl.french == fairUri
    * def getCMDMFairSettingsResponse = call read('classpath:common/cmdm/canada/RunnerHelper.feature@GetFairRunner'){FAIR_ID:<FAIRID_OR_CURRENT>}
    * match getCMDMFairSettingsResponse.response.fairInfo.customEnglishFairUrl contains fairUri
    * match getCMDMFairSettingsResponse.response.fairInfo.customFrenchFairUrl contains fairUri

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | fairUri            |
      | azhou1@scholastic.com | password1 | 5196693           | automationTesting1 |
      | azhou1@scholastic.com | password1 | 5196693           | automationTesting2 |
      | azhou1@scholastic.com | password1 | 5196693           | automationTesting3 |


  Scenario Outline: Validate that same fair url being set returns an error for user: <USER_NAME>, fair: <FAIRID_OR_CURRENT>
    * def AGGREGATE_PIPELINE =
    """
    [
      {
        $match:{
            "fairId":"#(FAIRID_OR_CURRENT)"
        }
      }
    ]
    """
    Given def fairUrlBeforePut = call read('classpath:common/bookfairs/canada/MongoDBRunner.feature@RunAggregate'){collectionName: "fairs"}
    * def REQUEST_BODY =
    """
    {
      "fairUrl" : '#(fairUrlBeforePut.document[0].onlineHomepage.fairUrl.english)'
    }
    """
    Given def response = call read('RunnerHelper.feature@SetFairUrl'){FAIR_ID:<FAIRID_OR_CURRENT>}
    Then match response.responseStatus == 208

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5196693           |

  Scenario Outline: Validate no authorization cookie provided for put events for fair: <FAIRID_OR_CURRENT>
    * replace setFairUrlUri.resourceId = FAIRID_OR_CURRENT
    * url CANADA_TOOLKIT_URL + setFairUrlUri
    Then method PUT
    Then match responseStatus == 204
    Then match responseHeaders['Sbf-Ca-Reason'] == ["NO_USER_EMAIL"]

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5196693           |

  Scenario Outline: Validate user cannot set fairUrl for a fair user has no access to. user:<USER_NAME>, fair: <FAIRID_OR_CURRENT>
    * def AGGREGATE_PIPELINE =
    """
    [
      {
        $match:{
            "fairId":"#(unauthorizedFair)"
        }
      }
    ]
    """
    Given def fairUrlBeforePut = call read('classpath:common/bookfairs/canada/MongoDBRunner.feature@RunAggregate'){collectionName: "fairs"}
    * def REQUEST_BODY =
    """
    {
      "fairUrl" : 'shouldNeverBeThis'
    }
    """
    Given def response = call read('RunnerHelper.feature@SetFairUrl'){FAIR_ID:<unauthorizedFair>}
    Then match response.responseStatus == 204
    And match response.responseHeaders["Sbf-Ca-Reason"] == ["RESOURCE_ID_NOT_VALID"]
    Then def fairUrlAfterPutAttempt = call read('classpath:common/bookfairs/canada/MongoDBRunner.feature@RunAggregate'){collectionName: "fairs"}
    And match fairUrlBeforePut.document[0].onlineHomepage.fairUrl == fairUrlAfterPutAttempt.document[0].onlineHomepage.fairUrl

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | unauthorizedFair |
      | azhou1@scholastic.com | password1 | 5197091          |

  Scenario Outline: Validate when user sends an invalid request body
    Given def REQUEST_BODY =
    """
    {}
    """
    And def response = call read('RunnerHelper.feature@SetFairUrl'){FAIR_ID:<FAIRID_OR_CURRENT>}
    Then match response.responseStatus == 400

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5196693           |

  Scenario Outline: Validate when user sends an invalid request type
    Given def REQUEST_BODY = ""
    And def response = call read('RunnerHelper.feature@SetFairUrl'){FAIR_ID:<FAIRID_OR_CURRENT>}
    Then match response.responseStatus == 415

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5196693           |

  Scenario Outline: Validate when user doesn't exist
    * replace setFairUrlUri.resourceId = FAIRID_OR_CURRENT
    * url CANADA_TOOLKIT_URL + setFairUrlUri
    * def REQUEST_BODY =
    """
    {
      "fairUrl" : 'shouldNeverBeThis'
    }
    """
    * request REQUEST_BODY
    Then method PUT
    * cookies { userEmail : '#(USER_NAME)'}
    Then match responseStatus == 404

    @QA
    Examples:
      | USER_NAME                  | FAIRID_OR_CURRENT |
      | idon'texist@scholastic.com | 5196693           |
