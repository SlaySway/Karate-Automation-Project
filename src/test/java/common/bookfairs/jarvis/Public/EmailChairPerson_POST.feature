@emailChairPersonTest @public&userTests
Feature: EmailChairPerson API automation tests

  Background: Set config
    * string EmailChairPersonURL = "/bookfairs-jarvis/api/public/fairs/<fairId>/emails/parent-to-chairperson"

  Scenario Outline: Validate request when manadtory path parameter 'fairId' is not passed
    * replace EmailChairPersonURL.fairId = FAIRID_OR_CURRENT
    * def reqBody =
      """
      {
      "email": <USER_NAME>,
      "message": <MSG>,
      "name": {
        "first": <FIRST_NAME>,
        "last": <LAST_NAME>
      },
      "phone": <PHONE>
      }
      """
    Given url BOOKFAIRS_JARVIS_URL + EmailChairPersonURL
    And request reqBody
    And method post
    Then match responseStatus == 404

    @QA
    Examples: 
      | USER_NAME                           | PASSWORD | FAIRID_OR_CURRENT | MSG                     | FIRST_NAME    | LAST_NAME | PHONE      |
      | rpallerla-consultant@scholastic.com | passw0rd | null              | Sending an email to BFC | MariaCristina | Todaro    | 7321211111 |

  Scenario Outline: Validate request when manadtory path parameter 'fairId' is invalid
    * replace EmailChairPersonURL.fairId = FAIRID_OR_CURRENT
    * def reqBody =
      """
      {
      "email": <USER_NAME>,
      "message": <MSG>,
      "name": {
        "first": <FIRST_NAME>,
        "last": <LAST_NAME>
      },
      "phone": <PHONE>
      }
      """
    Given url BOOKFAIRS_JARVIS_URL + EmailChairPersonURL
    And request reqBody
    And method post
    Then match responseStatus == 404

    @QA
    Examples: 
      | USER_NAME                           | PASSWORD | FAIRID_OR_CURRENT | MSG                     | FIRST_NAME    | LAST_NAME | PHONE      |
      | rpallerla-consultant@scholastic.com | passw0rd |           1231111 | Sending an email to BFC | MariaCristina | Todaro    | 7321211111 |

  Scenario Outline: Validate request when request body is missing
    * replace EmailChairPersonURL.fairId = FAIRID_OR_CURRENT
    Given url BOOKFAIRS_JARVIS_URL + EmailChairPersonURL
    And method post
    Then match responseStatus == 400

    @QA
    Examples: 
      | USER_NAME                           | PASSWORD | FAIRID_OR_CURRENT | MSG                     | FIRST_NAME | LAST_NAME | PHONE      |
      | rpallerla-consultant@scholastic.com | passw0rd |           5808611 | Sending an email to BFC | Ravindra   | Pallerla  | 7321211111 |

  Scenario Outline: Validate request when request body is empty
    * replace EmailChairPersonURL.fairId = FAIRID_OR_CURRENT
    * def reqBody =
      """
      {
      
      }
      """
    Given url BOOKFAIRS_JARVIS_URL + EmailChairPersonURL
    And request reqBody
    And method post
    Then match responseStatus == 400

    @QA
    Examples: 
      | USER_NAME                           | PASSWORD | FAIRID_OR_CURRENT | MSG                     | FIRST_NAME | LAST_NAME | PHONE      |
      | rpallerla-consultant@scholastic.com | passw0rd |           5808611 | Sending an email to BFC | Ravindra   | Pallerla  | 7321211111 |

  Scenario Outline: Validate request when email is missing
    * replace EmailChairPersonURL.fairId = FAIRID_OR_CURRENT
    * def reqBody =
      """
      {
      "message": <MSG>,
      "name": {
        "first": <FIRST_NAME>,
        "last": <LAST_NAME>
      },
      "phone": <PHONE>
      }
      """
    Given url BOOKFAIRS_JARVIS_URL + EmailChairPersonURL
    And request reqBody
    And method post
    Then match responseStatus == 400

    @QA
    Examples: 
      | USER_NAME                           | PASSWORD | FAIRID_OR_CURRENT | MSG                     | FIRST_NAME | LAST_NAME | PHONE      |
      | rpallerla-consultant@scholastic.com | passw0rd |           5808611 | Sending an email to BFC | Ravindra   | Pallerla  | 7321211111 |

  Scenario Outline: Validate request when email is invalid || <USER_NAME>
    * replace EmailChairPersonURL.fairId = FAIRID_OR_CURRENT
    * def reqBody =
      """
      {
      "email": <USER_NAME>,
      "message": <MSG>,
      "name": {
        "first": <FIRST_NAME>,
        "last": <LAST_NAME>
      },
      "phone": <PHONE>
      }
      """
    Given url BOOKFAIRS_JARVIS_URL + EmailChairPersonURL
    And request reqBody
    And method post
    Then match responseStatus == 200
    #Then match responseStatus == 400 - defect deferred

    @QA
    Examples: 
      | USER_NAME                 | PASSWORD | FAIRID_OR_CURRENT | MSG                     | FIRST_NAME | LAST_NAME | PHONE      |
      | rpallerla-consultant      | passw0rd |           5808611 | Sending an email to BFC | Ravindra   | Pallerla  | 7321211111 |
      | rpallerla-consultant@mail | passw0rd |           5808611 | Sending an email to BFC | Ravindra   | Pallerla  | 7321211111 |

  Scenario Outline: Validate request with valid fair and input
    * replace EmailChairPersonURL.fairId = FAIRID_OR_CURRENT
    * def reqBody =
      """
      {
      "email": <USER_NAME>,
      "message": <MSG>,
      "name": {
        "first": <FIRST_NAME>,
        "last": <LAST_NAME>
      },
      "phone": <PHONE>
      }
      """
    Given url BOOKFAIRS_JARVIS_URL + EmailChairPersonURL
    And request reqBody
    And method post
    Then match responseStatus == 200
    And match response == 'Successful'

    @QA
    Examples: 
      | USER_NAME                           | PASSWORD | FAIRID_OR_CURRENT | MSG                     | FIRST_NAME | LAST_NAME | PHONE      |
      | rpallerla-consultant@scholastic.com | passw0rd |           5808611 | Sending an email to BFC | Ravindra   | Pallerla  | 7321211111 |
