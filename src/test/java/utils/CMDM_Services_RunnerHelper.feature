#Author: Ravindra Pallerla

@ignore
Feature: Runner helper for running CMDM services

  Background: Set config
    * string fairsUri = "/cmdm/fair-service/v1/fairs"

  @FairsServiceRunner
  Scenario: Run cmdm fairs service
    * def PathParams = {fairId : '#(FAIRID)'}
    Given url CMDM_QA_URL + fairsUri
    And path PathParams.fairId
    And headers {Content-Type : 'application/json', Authorization: 'Bearer 3dIx0ZzA49dKFMQmZKEPnz3aUWesIafl'}
    And method get
    Then def StatusCode = responseStatus
    And def ResponseString = response
    And def BFAccountId = response.organization.bookfairAccountId
