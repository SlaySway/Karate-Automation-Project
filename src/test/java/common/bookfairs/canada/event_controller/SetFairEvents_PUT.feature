@UpdateFairEvents
Feature: Canada Toolkit SetFairEvents API Tests

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
    * match mongoResults.document[0].onlineHomepage.events contains REQUEST_BODY
    * def buildExpectedMongoEntry =
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

    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT | requestBody |
      | azhou1@scholastic.com | password1 | 5196693           | oneEvent    |
#      | azhou1@scholastic.com | password1 | 5196693           | twoEvents   |
#      | azhou1@scholastic.com | password1 | 5196693           | zeroevents  |


  Scenario: User cannot set event for another fair

  Scenario: User sends an invalid request body

  Scenario: User

    # User attempts sending extra field

  # User attempts sending without a field

  # Reference https://jira.sts.scholastic.com/browse/BFS-1847 for scenarios
