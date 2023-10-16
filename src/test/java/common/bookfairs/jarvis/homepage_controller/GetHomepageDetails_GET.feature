@GetHomepageDetailsTest
Feature: HomepageDetails API automation tests

  Background: Set config
    * string GetHomepageDetailsUrl = "/api/user/fairs"

Scenario Outline: Validate 200 response code for a valid request
* def GetHomepageDetailsResponse = call read('classpath:common/bookfairs/jarvis/homepage_controller/HomepageRunnerHelper.feature@GetHomepageDetailsRunner'){USER_ID : '<USER_NAME>', PWD : '<PASSWORD>', FAIRID : '<FAIR_ID>'}
  And print GetHomepageDetailsResponse.ResponseString
  Then match GetHomepageDetailsResponse.StatusCode == 200


Examples:
| USER_NAME                          | PASSWORD | FAIR_ID |
| azhou1@scholastic.com              | password1| 5633533 |
| sdevineni-consultant@scholastic.com| passw0rd | 5734325 |



