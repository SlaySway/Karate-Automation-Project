@GetFairEvents
Feature: Canada Toolkit GetFairEvents API Tests

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
          newEvent.createDate = "#present"
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
    # Thu Mar 28 02:30:00 EDT 2024
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
#    * syncResponseToMongo(response.response)
    * print response.response
    * print buildResponseFromMongoEventsList(mongoResults.document[0].onlineHomepage.events)
    * print mongoResults.document[0].onlineHomepage.events
    * print mongoResults
    Then match buildResponseFromMongoEventsList(mongoResults.document[0].onlineHomepage.events) == response.response.events
#    * match mongoResults.document[0].onlineHomepage.events == response.response.events
#    * def getCMDMFairSettingsResponse = call read('classpath:common/cmdm/canada/RunnerHelper.feature@GetFairRunner'){FAIR_ID:<FAIRID_OR_CURRENT>}
#    * match getCMDMFairSettingsResponse.response.fairInfo.startDate == response.response.fairInfo.start # <- Will work once salesforce and mongo has a way to sync up (kafka topic)
#    * match getCMDMFairSettingsResponse.response.fairInfo.endDate == response.response.fairInfo.end

    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5196693           |





