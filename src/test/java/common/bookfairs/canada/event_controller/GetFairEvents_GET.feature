@GetFairEvents
Feature: Canada Toolkit GetFairEvents API Tests

  Background: Set config
    * string getFairEventsUri = "/api/user/fairs/<resourceId>/homepage/events"

  Scenario Outline: Validate fields returned by get events against mongo and cmdm for fair: <FAIRID_OR_CURRENT>
    * def buildResponseFromMongoEventsList =
    """
      function(events){
        if(events.length==0){
          return [];
        }
        let DateUtils = Java.type('utils.DateUtils');
        let expectedResponse = [];
        events.forEach((event) => {
          let newEvent = {};
          newEvent.id = event._id;
          newEvent.date = DateUtils.convertFormat(event.date, "EEE MMM dd HH:mm:ss zzz yyyy",  "yyyy-MM-dd", "UTC");
          newEvent.createDate = "#notnull"
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
    Given def response = call read('RunnerHelper.feature@GetFairEvents'){FAIR_ID:<FAIRID_OR_CURRENT>}
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
    Then json expectedEventsResponse = buildResponseFromMongoEventsList(mongoResults.document[0].onlineHomepage.events)
    Then match response.response.events == expectedEventsResponse
    * def getCMDMFairSettingsResponse = call read('classpath:common/cmdm/canada/RunnerHelper.feature@GetFairRunner'){FAIR_ID:<FAIRID_OR_CURRENT>}
    # below will work once salesforce and mongo has a way to sync up (kafka topic)
    * match getCMDMFairSettingsResponse.response.fairInfo.startDate == response.response.fairInfo.start
    * match getCMDMFairSettingsResponse.response.fairInfo.endDate == response.response.fairInfo.end
    Then match responseHeaders['Sbf-Ca-Resource-Id'] == FAIRID_OR_CURRENT

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password2 | 5196693           |

  Scenario Outline: Validate no authorization cookie provided for get events for fair: <FAIRID_OR_CURRENT>
    * replace getFairEventsUri.resourceId = FAIRID_OR_CURRENT
    * url CANADA_TOOLKIT_URL + getFairEventsUri
    Then method GET
    Then match responseStatus == 204
    Then match responseHeaders['Sbf-Ca-Reason'] == ["NO_USER_EMAIL"]

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password2 | 5196693           |

  Scenario Outline: Validate "current" default fair selection to get events for fair: <FAIRID_OR_CURRENT>
    Given def response = call read('RunnerHelper.feature@GetFairEvents'){FAIR_ID:<FAIRID_OR_CURRENT>}
    Then match response.responseStatus == 200
    Then match response.responseHeaders['Sbf-Ca-Resource-Id'] == ['#(EXPECTED_FAIR)']

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | EXPECTED_FAIR |
      | azhou1@scholastic.com | password2 | current           | 5196693       |







