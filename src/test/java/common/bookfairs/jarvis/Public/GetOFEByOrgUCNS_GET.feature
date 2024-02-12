@GetOFEByOrgUCNS
Feature:GetOFEByOrgUCNS API Automation Tests

  Background: Set config
    * string getOFEByOrgUCNSUri = "/bookfairs-jarvis/api/public/ofe/school/<schoolUCNs>"
    * def obj = Java.type('utils.StrictValidation')

  Scenario Outline: Validate with invalid schoolUCNS for UCNS: <SCHOOL_UCNS> and expected code: <EXPECTED_RESPONSE_CODE>
    * def SCHOOL_UCNS = !SCHOOL_UCNS ? "" : SCHOOL_UCNS
    * replace getOFEByOrgUCNSUri.schoolUCNs = SCHOOL_UCNS
    Given url BOOKFAIRS_JARVIS_URL + getOFEByOrgUCNSUri
    And method get
    Then match responseStatus == EXPECTED_RESPONSE_CODE

    @QA @PROD
    Examples:
      | SCHOOL_UCNS | EXPECTED_RESPONSE_CODE! |
      |             | 404                     |
      | 12345       | 404                     |
      | abc         | 400                     |
      | ''          | 400                     |

  Scenario Outline: Validate happy response is valid against calling CMDM and building expected response for UCNS: <SCHOOL_UCNS>
    * def buildResponse =
    """
      function(schoolUcnsAsString){
        let schoolUcns = schoolUcnsAsString.split(",");
        let expectedResponse = []
        schoolUcns.forEach((schoolUcn) => {
          console.log("Calling cmdm for ", schoolUcn);
          let cmdmResponse = karate.call("classpath:common/cmdm/fairs/CMDMRUnnerHelper.feature@GetFairsByOrgUcn", {SCHOOL_UCN: schoolUcn});
          let DateUtils = Java.type('utils.DateUtils');
          if(cmdmResponse.response.fairs){
            cmdmResponse.response.fairs.forEach((fair) =>  {
                let newFair = {}
                newFair.name = fair.name;
                newFair.id = fair.bookfairAccountId;
                newFair.ucn = fair.schoolUcn;
                newFair.address1 = fair.address;
                newFair.address2 = "";
                newFair.city = fair.city;
                newFair.state = fair.state;
                newFair.postalCode = fair.zipcode;
                newFair.fairId = parseInt(fair.fairId);
                newFair.ofeStartDate = fair.fairStartDate;
                newFair.ofeEndDate = (fair.productId && ["OC", "VF", "OS", "OT"].includes(fair.productId)) ? fair.fairEndDate : DateUtils.addDays(fair.fairStartDate,13);
                newFair.active = DateUtils.isCurrentDateBetweenTwoDates(newFair.ofeStartDate, newFair.ofeEndDate);
                newFair.percentProfit = newFair.active ? 25 : 2;
                expectedResponse.push(newFair);
            })
          }
        })
        if(expectedResponse.length == 0)
          return ""
        return expectedResponse;
      }
      """
    Given def expectedResponse = buildResponse(SCHOOL_UCNS);
    Given def getOFEByOrgUCNSResponse = call read("publicRunnerHelper.feature@GetOFEByOrgUCNS")
    Then getOFEByOrgUCNSResponse.responseStatus = 200
    * print expectedResponse
    * print getOFEByOrgUCNSResponse.response
    And match expectedResponse contains only getOFEByOrgUCNSResponse.response

    @QA
    Examples:
      | SCHOOL_UCNS                             |
      | 600009249                               |
      | 600116335,600130575,600119711,600080044 |
      | 600073255,600009249                     |