@GetFairSettings
Feature: Canada Toolkit get fair settings API Tests

  Scenario Outline: Validate fair settings returns 200 response and response is from CMDM
    Given def response = call read('RunnerHelper.feature@GetFairSettings'){FAIR_ID:"random", USER_NAME:"random"}
    # validate fair info from cmdm
      # where is fliers from
      # where is requestDateChangePending data from
      # where is planningKitShipped from
    # validate enableSwitch depending on how many fairs user has
    # validate organization bookfairAccountId
    # validate homepage url
    # validate salesHistory
    # validate consultant
    # validate sdBalance

    Examples:
    | word |
    | a    |