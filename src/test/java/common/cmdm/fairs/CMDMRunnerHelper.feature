#Author: Ravindra Pallerla
@ignore
Feature: Runner helper for Jarvis application apis

  Background: Set config
    * string fairsUri = "/cmdm/fair-service/v1/fairs/"

  # Input: FAIR_ID
  @GetFairRunner
  Scenario: Run getFairs api for fair:<FAIR_ID>
    * url CMDM_URL + fairsUri + FAIR_ID
    * header Authorization = CMDM_BEARER_TOKEN
    Given method get