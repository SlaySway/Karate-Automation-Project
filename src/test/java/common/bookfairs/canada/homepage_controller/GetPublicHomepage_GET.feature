Feature: Canada Toolkit GetPublicHomepage API Tests

  Background: Set config
    * string getPublicHomepageUri = "/api/public/homepage/<homepageUrl>"

  Scenario Outline: Validate when valid resource ID provided fields returned against mongo and cmdm for user:<USER_NAME> and fair:<RESOURCE_ID>


    @QA
      Examples:
        | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
        | azhou1@scholastic.com | password2 | 5196693           |

  Scenario Outline: Validate when invalid resource ID provided fields returned against mongo and cmdm for user:<USER_NAME> and fair:<RESOURCE_ID>


    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password2 | 5196693           |

  Scenario Outline: Validate updating the fairUrl will make the last url null and the new url populated with data for fair:<RESOURCE_ID> and new url:<newUrl>

    @QA
    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password2 | 5196693           |