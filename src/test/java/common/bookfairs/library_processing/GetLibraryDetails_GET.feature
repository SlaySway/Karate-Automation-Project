@GetLibraryDetailsTest
Feature: Library details API automation tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * string getLibraryDetails = "/api/user/library/orgs/<orgUcn>"

  Scenario Outline: Validate 200 response code for a valid request
    * def getLibraryDetailsResponseMap = call read('classpath:common/bookfairs/library_processing/RunnerHelper.feature@GetLibraryDetails'){ORG_UCN : '<ORG_UCN>'}
    Then match getLibraryDetailsResponseMap.responseStatus == 200
    * def readingPlacementValFunction =
    """
    function(){
    if(getLibraryDetailsResponseMap.response.readingLabelPlacement.selectedValue >= 57 && getLibraryDetailsResponseMap.response.readingLabelPlacement.selectedValue <= 59)
    return true
      }
    """
    * def barCodePlacementValFunction =
    """
    function(){
    if(getLibraryDetailsResponseMap.response.barcodePlacement.selectedValue >= 1 && getLibraryDetailsResponseMap.response.barcodePlacement.selectedValue <= 18)
    return true
      }
    """

    @QA
    Examples:
      | ORG_UCN |
      | 12345   |

  Scenario Outline: Validate 200 response code for an orgUcn not existing in database
    * def getLibraryDetailsResponseMap = call read('classpath:common/bookfairs/library_processing/RunnerHelper.feature@GetLibraryDetails'){ORG_UCN : '<ORG_UCN>'}
    Then match getLibraryDetailsResponseMap.responseStatus == 200

    @QA
    Examples:
      | ORG_UCN  |
      | abcd1234 |

  Scenario Outline: Validate 404 response code for passing no orgUcn
    * def getLibraryDetailsResponseMap = call read('classpath:common/bookfairs/library_processing/RunnerHelper.feature@GetLibraryDetails'){ORG_UCN : '<ORG_UCN>'}
    Then match getLibraryDetailsResponseMap.responseStatus == 404

    @QA
    Examples:
      | ORG_UCN |
      |         |

  @Regression @ignore
  Scenario Outline: Validate regression using dynamic comparison || orgUcn=<ORG_UCN>
    * def BaseResponseMap = call read('classpath:common/bookfairs/library_processing/RunnerHelper.feature@GetLibraryDetailsBase')
    * def TargetResponseMap = call read('classpath:common/bookfairs/library_processing/RunnerHelper.feature@GetLibraryDetails')
    Then match BaseResponseMap.responseStatus == TargetResponseMap.responseStatus
    Then match BaseResponseMap.response == TargetResponseMap.response

    * string base = BaseResponseMap.response
    * string target = TargetResponseMap.response
    * def compResult = obj.strictCompare(base, target)
    Then print "Response from production code base", base
    Then print "Response from current qa code base", target
    Then print 'Differences any...', compResult
    And match base == target

    @QA
    Examples:
      | ORG_UCN |
      | 12345   |
