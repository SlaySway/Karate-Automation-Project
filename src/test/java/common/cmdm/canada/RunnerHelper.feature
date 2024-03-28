@ignore
Feature: Runner helper for CMDM Canada apis

  Background: Set config
    * string fairUrl = "/cmdm/ca-fair-service/v1/fair/"

  # Input: FAIR_ID
  @GetFairRunner
  Scenario: Run getFairs api for fair:<FAIR_ID>
    * url CMDM_URL + fairUrl + FAIR_ID
    * header Authorization = CMDM_CA_BEARER_TOKEN
    Given method get