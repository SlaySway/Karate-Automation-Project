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

  Scenario Outline: Validate happy response is valid against CMDM based for UCNS: <SCHOOL_UCNS>
    * def dateParser =
    """
    function(dateString){
        let parts = dateString.split("-");
        return new Date(parts[0], parts[1]-1, parts[2]);
    }
    """
    * def addDays =
    """
    function(dateObject, daysToAdd){
        dateObject.setDate(dateObject.getDate() + daysToAdd);
        return dateObject;
    }
    """
    * def buildResponse =
    """
    function(cmdmResponse){
      let response = []
      let currentDate = new Date();
      console.log("Current date: ", currentDate);
      cmdmResponse.fairs.forEach((fair) =>  {
          let newFair = {}
          newFair.name = fair.name;
          newFair.id = fair.bookfairAccountId;
          newFair.ucn = fair.schoolUcn;
          newFair.address1 = fair.address;
          newFair.address2 = "";
          newFair.city = fair.city;
          newFair.state = fair.state;
          newFair.postalCode = fair.zipcode;
          newFair.active = (currentDate >= dateParser(fair.fairStartDate) && currentDate <= dateParser(fair.fairEndDate));
          newFair.percentProfit = newFair.active ? "25" : "2";
          newFair.fairId = parseInt(fair.fairId);
          newFair.ofeStartDate = fair.fairStartDate;
          newFair.ofeEndDate = (fair.productId && ["OC", "VF", "OS", "OT"].includes(fair.productId)) ? fair.fairEndDate : addDays(dateParser(fair.fairEndDate),13).toISOString().split('T')[0];
          response.push(newFair);
      })
      return response;
  }
    """
    Given def cmdmGetFairByOrgUcnResponse = call read("classpath:common/cmdm/fairs/CMDMRUnnerHelper.feature@GetFairsByOrgUcn")
    Then cmdmGetFairByOrgUcnResponse.responseStatus = 200
    * def expectedResponse = buildResponse(cmdmGetFairByOrgUcnResponse.response)
    * print expectedResponse

#    Given def getOFEByOrgUCNSResponse = call read("classpath:common/cmdm/fairs/CMDMRUnnerHelper.feature@GetFairsByOrgUcn")
#    Then getOFEByOrgUCNSResponse.responseStatus = 200

    @QA
    Examples:
      | SCHOOL_UCN | EXPECTED_RESPONSE_CODE! |
      |     600009249        | 404                     |

    Scenario: testing
      * def dateParser =
    """
    function(dateString){
        let parts = dateString.split("-");
        return new Date(parts[0], parts[1]-1, parts[2]);
    }
    """
      * def a =
      """
      function(dateString){
        console.log("Over here", dateParser(dateString));
        return dateParser(dateString);
      }
      """
      * def b = a("2024-03-02")
      * print b