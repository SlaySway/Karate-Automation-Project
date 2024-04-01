@UpdateFairEvents
Feature: Canada Toolkit SetFairEvents API Tests

  Background: Set config
    * string setFairEventsUri = "/api/user/fairs/<resourceId>/homepage/events"

  Scenario Outline: Validate set events sets the events in mongo for fair: <FAIRID_OR_CURRENT>
    * def REQUEST_BODY = read('SetFairEventRequests.json')[requestBody]
    Given def response = call read('RunnerHelper.feature@SetFairEvents'){FAIR_ID:<FAIRID_OR_CURRENT>}
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
    Then match response.responseStatus == 200
    * def buildRequestFromMongoEventsList =
    """
      function(events){
        if(events.length==0){
          return [];
        }
        let DateUtils = Java.type('utils.DateUtils');
        let expectedResponse = [];
        events.forEach((event) => {
          let newEvent = {};
          newEvent.date = DateUtils.convertFormat(event.date, "EEE MMM dd HH:mm:ss zzz yyyy",  "yyyy-MM-dd", "UTC");
          DateUtils.convertFormat(event.createdDate, "EEE MMM dd HH:mm:ss zzz yyyy", "yyyy-MM-dd'T'HH:mm:ss.SS");
          newEvent.category = event.category
          newEvent.title = event.title
          newEvent.startTime = DateUtils.convertFormat(event.startTime, "EEE MMM dd HH:mm:ss zzz yyyy", "HH:mm:ss", "UTC");
          newEvent.endTime = DateUtils.convertFormat(event.endTime, "EEE MMM dd HH:mm:ss zzz yyyy", "HH:mm:ss", "UTC");
          newEvent.detailMessage = event.detailMessage
          expectedResponse.push(newEvent)
        })
        return expectedResponse;
      }
      """
    * match buildRequestFromMongoEventsList(mongoResults.document[0].onlineHomepage.events) contains REQUEST_BODY

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | requestBody |
      | azhou1@scholastic.com | password1 | 5196693           | oneEvent    |
      | azhou1@scholastic.com | password1 | 5196693           | twoEvents   |
      | azhou1@scholastic.com | password1 | 5196693           | noEvents    |

  Scenario Outline: Validate no authorization cookie provided for put events for fair: <FAIRID_OR_CURRENT>
    * replace getFairEventsUri.resourceId = FAIRID_OR_CURRENT
    * url CANADA_TOOLKIT_URL + setFairEventsUri
    Then method PUT
    Then match responseStatus == 204
    Then match responseHeaders['Sbf-Ca-Reason'] == "NO_USER_EMAIL"

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5196693           |

  Scenario Outline: Validate user cannot set event for a fair user has no access to. user:<USER_NAME>, fair: <FAIRID_OR_CURRENT>
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
    Given def fairEventsBeforePutAttempt = call read('classpath:common/bookfairs/canada/MongoDBRunner.feature@RunAggregate'){collectionName: "fairs"}
    * def REQUEST_BODY =
    """
    {
        "date": "2021-03-12",
        "category": "Family Event",
        "title": "Breakfast and Books",
        "startTime": "06:30:00",
        "endTime": "07:30:00",
        "detailMessage": {
          "english":"Random event, should never show up",
          "french": "Since this is an unhappy path test"
        }
      }
    """
    Given def response = call read('RunnerHelper.feature@SetFairEvents'){FAIR_ID:<unauthorizedFair>}
    Then match response.responseStatus == 204
    And match response.responseHeaders["Sbf-Ca-Reason"] == "RESOURCE_ID_NOT_VALID"
    Then def fairEventsAfterPutAttempt = call read('classpath:common/bookfairs/canada/MongoDBRunner.feature@RunAggregate'){collectionName: "fairs"}
    And match fairEventsAfterPutAttempt.document[0].onlineHomepage.events == fairEventsBeforePutAttempt.document[0].onlineHomepage.events

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | unauthorizedFair |
      | azhou1@scholastic.com | password1 | 123456           |


  Scenario Outline: Validate when user sends an invalid request body
    Given def REQUEST_BODY = ""
    And def response = call read('RunnerHelper.feature@SetFairEvents'){FAIR_ID:<FAIRID_OR_CURRENT>}
    Then match response.responseStatus == 400

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5196693           |

  Scenario Outline: Validate when user doesn't exist
    * replace getFairEventsUri.resourceId = FAIRID_OR_CURRENT
    * url CANADA_TOOLKIT_URL + setFairEventsUri
    Then method PUT
    * cookies { userEmail : '#(USER_NAME)'}
    Then match responseStatus == 404

    @QA
    Examples:
      | USER_NAME                  | FAIRID_OR_CURRENT |
      | idon'texist@scholastic.com | 5196693           |
