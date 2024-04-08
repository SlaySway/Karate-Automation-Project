@UpdateVolunteersUrl
Feature: Canada Toolkit Update Volunteer URL API Tests

  Background: Set config
    * string updateVolunteersUrlUri = "/api/user/fairs/<resourceId>/homepage/volunteers"

  Scenario Outline: Validate update volunteer url sets the url in mongo for fair: <FAIRID_OR_CURRENT>
    * def REQUEST_BODY =
    """
    {
      "url" : '#(volunteerUrl)'
    }
    """
    Given def response = call read('RunnerHelper.feature@UpdateVolunteersUrl'){FAIR_ID:<FAIRID_OR_CURRENT>}
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
    * match mongoResults.document[0].onlineHomepage.volunteerUrl == volunteerUrl

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | volunteerUrl       |
      | azhou1@scholastic.com | password1 | 5196693           | automationTesting1 |
      | azhou1@scholastic.com | password1 | 5196693           | automationTesting2 |
      | azhou1@scholastic.com | password1 | 5196693           | automationTesting3 |


  Scenario Outline: Validate no authorization cookie provided for update volunteer url for fair: <FAIRID_OR_CURRENT>
    * replace updateVolunteersUrlUri.resourceId = FAIRID_OR_CURRENT
    * def REQUEST_BODY =
    """
    {
      "url" : 'shouldNeverBeThis'
    }
    """
    * request REQUEST_BODY
    * url CANADA_TOOLKIT_URL + updateVolunteersUrlUri
    Then method PUT
    Then match responseStatus == 204
    Then match responseHeaders['Sbf-Ca-Reason'] == ["NO_USER_EMAIL"]

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5196693           |

  Scenario Outline: Validate user cannot set volunteer url for a fair user has no access to. user:<USER_NAME>, fair: <FAIRID_OR_CURRENT>
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
    Given def volunteerUrlBeforePut = call read('classpath:common/bookfairs/canada/MongoDBRunner.feature@RunAggregate'){collectionName: "fairs"}
    * def REQUEST_BODY =
    """
    {
      "url" : 'shouldNeverBeThis'
    }
    """
    Given def response = call read('RunnerHelper.feature@UpdateVolunteersUrl'){FAIR_ID:<unauthorizedFair>}
    Then match response.responseStatus == 204
    And match response.responseHeaders["Sbf-Ca-Reason"] == ["RESOURCE_ID_NOT_VALID"]
    Then def volunteerUrlAfterPutAttempt = call read('classpath:common/bookfairs/canada/MongoDBRunner.feature@RunAggregate'){collectionName: "fairs"}
    And match volunteerUrlBeforePut.document[0].onlineHomepage.volunteerUrl == volunteerUrlAfterPutAttempt.document[0].onlineHomepage.volunteerUrl

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | unauthorizedFair |
      | azhou1@scholastic.com | password1 | 5197091          |

  Scenario Outline: Validate when user sends an invalid request body
    Given def REQUEST_BODY =
    """
    {}
    """
    And def response = call read('RunnerHelper.feature@UpdateVolunteersUrl'){FAIR_ID:<FAIRID_OR_CURRENT>}
    Then match response.responseStatus == 400

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5196693           |

  Scenario Outline: Validate when user sends an invalid request type
    Given def REQUEST_BODY = ""
    And def response = call read('RunnerHelper.feature@UpdateVolunteersUrl'){FAIR_ID:<FAIRID_OR_CURRENT>}
    Then match response.responseStatus == 415

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5196693           |

  Scenario Outline: Validate when user doesn't exist
    * replace updateVolunteersUrlUri.resourceId = FAIRID_OR_CURRENT
    * url CANADA_TOOLKIT_URL + updateVolunteersUrlUri
    * def REQUEST_BODY =
    """
    {
      "url" : 'shouldNeverBeThis'
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
