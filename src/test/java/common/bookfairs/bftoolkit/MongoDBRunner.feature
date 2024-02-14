@ignore @report=true
Feature: Helper for accessing bftoolkit Mongo

  Background: Set config
    * def uri = "mongodb+srv://bftoolkitUser:a6AJEefUWIF7HY7y@uber-index-qa.ipjav.mongodb.net/admin?retryWrites=true&replicaSet=UBER-INDEX-QA-shard-0&readPreference=primary&srvServiceName=mongodb&connectTimeoutMS=10000&authSource=admin&authMechanism=SCRAM-SHA-1"
    * def dbName = "bf-toolkit"

    # Input: collection, field, value
    # Output: document (returns document as JSON)
  @FindDocumentByField
  Scenario: Find and return document by field
    * def DbUtils = Java.type('utils.MongoDBUtils')
    * def db = new DbUtils(uri, dbName, "bookFairDataLoad")
    * json document = db.findByField("bookFairDataLoad", "taxDetailTaxRate", "08200")
    * print document
    * db.disconnect()

  # Input: MONGO_COMMAND
  @RunCommand
  Scenario: Run a mongo command
    * def DbUtils = Java.type('utils.MongoDBUtils')
    * def db = new DbUtils(uri, dbName, "not used")
    * json document = db.runCommand(karate.toString(MONGO_COMMAND))
    # * print document.cursor.firstBatch[0]
    * db.disconnect()


  # Will be kept here as reference
  Scenario Outline: Test Mongo Queries
    * def DbUtils = Java.type('utils.MongoDBUtils')
    * def db = new DbUtils(uri, dbName, "not used")
    * def mongoQueryAsJson =
    """
    {
      find: "bookFairDataLoad",
      "filter": {
        "_id.fairId": "#(FAIRID_OR_CONTENT)"
      }
    }
    """
    * print mongoQueryAsJson
    * print FAIRID_OR_CURRENT
    * json document = db.runCommand(karate.toString(mongoQueryAsJson))
#    * print document.cursor.firstBatch[0]
    * db.disconnect()

    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5694296           |

