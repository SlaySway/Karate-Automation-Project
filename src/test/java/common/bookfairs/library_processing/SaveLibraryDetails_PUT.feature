@PUTLibraryDetailsTest
Feature: Save Library details API automation tests

  Background: Set config
    * def obj = Java.type('utils.StrictValidation')
    * string saveLibraryDetails = "/api/user/library/orgs/<orgUcn>"

  Scenario Outline: Validate 200 response code for a valid request
    * def REQUEST_BODY = read('SaveLibraryDetails.json')[requestBody]
    * def saveLibraryDetailsResponseMap = call read('classpath:common/bookfairs/library_processing/RunnerHelper.feature@PutLibraryDetails'){ORG_UCN : '<ORG_UCN>'}
    Then match saveLibraryDetailsResponseMap.responseStatus == 200
    * def getLibraryDetailsResponseMap = call read('classpath:common/bookfairs/library_processing/RunnerHelper.feature@GetLibraryDetails'){ORG_UCN : '<ORG_UCN>'}
    Then match getLibraryDetailsResponseMap.responseStatus == 200
    Then match saveLibraryDetailsResponseMap.response.capitalization == getLibraryDetailsResponseMap.response.capitalization.selectedValue
    Then match saveLibraryDetailsResponseMap.response.medium == getLibraryDetailsResponseMap.response.medium.selectedValue
    Then match saveLibraryDetailsResponseMap.response.softwareSystem == getLibraryDetailsResponseMap.response.softwareSystem.selectedValue
    Then match saveLibraryDetailsResponseMap.response.format == getLibraryDetailsResponseMap.response.format.selectedValue
    Then match saveLibraryDetailsResponseMap.response.readingLabel == getLibraryDetailsResponseMap.response.readingLabel.selectedValue
    Then match saveLibraryDetailsResponseMap.response.readingProgram == getLibraryDetailsResponseMap.response.readingProgram.selectedValue
    Then match saveLibraryDetailsResponseMap.response.readingLabelPlacement == getLibraryDetailsResponseMap.response.readingLabelPlacement.selectedValue
    Then match saveLibraryDetailsResponseMap.response.spineLabelPlacement == getLibraryDetailsResponseMap.response.spineLabelPlacement.selectedValue
    Then match saveLibraryDetailsResponseMap.response.barcodeOrientation == getLibraryDetailsResponseMap.response.barcodeOrientation.selectedValue
    Then match saveLibraryDetailsResponseMap.response.barcodePlacement == getLibraryDetailsResponseMap.response.barcodePlacement.selectedValue
    Then match saveLibraryDetailsResponseMap.response.barCodeSymbology == getLibraryDetailsResponseMap.response.barCodeSymbology.selectedValue
    Then match saveLibraryDetailsResponseMap.response.barcodePrefix == getLibraryDetailsResponseMap.response.barcodePrefix
    Then match saveLibraryDetailsResponseMap.response.libraryName == getLibraryDetailsResponseMap.response.libraryName

    @QA
    Examples:
      | ORG_UCN | requestBody       |
      | 77789   | putLibraryDetails |

  Scenario Outline: Validate 400 response code when no request payload is passed
    * def REQUEST_BODY =
    """

    """
    * def saveLibraryDetailsResponseMap = call read('classpath:common/bookfairs/library_processing/RunnerHelper.feature@PutLibraryDetails'){ORG_UCN : '<ORG_UCN>'}
    Then match saveLibraryDetailsResponseMap.responseStatus == 400

    @QA
      Examples:
    |ORG_UCN  |
    |77789    |

  Scenario Outline: Validate 404 response code when no orgUcn is passed
    * def REQUEST_BODY = read('SaveLibraryDetails.json')[requestBody]
    * def saveLibraryDetailsResponseMap = call read('classpath:common/bookfairs/library_processing/RunnerHelper.feature@PutLibraryDetails'){ORG_UCN : '<ORG_UCN>'}
    Then match saveLibraryDetailsResponseMap.responseStatus == 404

    @QA
    Examples:
      | ORG_UCN | requestBody       |
      |         | putLibraryDetails |

  @Regression @ignore
  Scenario Outline: Validate regression using dynamic comparison || orgUcn=<ORG_UCN>
    * def BaseResponseMap = call read('classpath:common/bookfairs/library_processing/RunnerHelper.feature@PutLibraryDetailsBase')
    * def TargetResponseMap = call read('classpath:common/bookfairs/library_processing/RunnerHelper.feature@PutLibraryDetails')
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
