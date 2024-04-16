@ignore @report=true
Feature: Helper for accessing canada Mongo

  Background: Set config
    * def uri = "mongodb+srv://canadaToolkitUser:FFEdEjlHSPkjlXp7@uber-index-qa.ipjav.mongodb.net/admin?retryWrites=true&loadBalanced=false&replicaSet=UBER-INDEX-QA-shard-0&readPreference=primary&srvServiceName=mongodb&connectTimeoutMS=10000&authSource=admin&authMechanism=SCRAM-SHA-1"
    * def dbName = "canada-toolkit"

    # Input: collection, field, value
    # Output: document (returns document as JSON)
  @FindDocumentByField
  Scenario: Find and return document by field
    * def DbUtils = Java.type('utils.MongoDBUtils')
    * def db = new DbUtils(uri, dbName, "bookFairDataLoad")
    * json document = db.findByField(collection, field, value)
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

  # Input: AGGREGATE_PIPELINE, collectionName
  @RunAggregate
  Scenario: Run a mongo command
    * def DbUtils = Java.type('utils.MongoDBUtils')
    * def db = new DbUtils(uri, dbName, "not used")
    * json document = db.runAggregate(karate.toString(AGGREGATE_PIPELINE), collectionName)
    * print document
    * db.disconnect()

  # Input: collection, findField, findValue, deleteField
  @FindDocumentThenDeleteField
  Scenario: Find a document and delete a field in it
    * def DbUtils = Java.type('utils.MongoDBUtils')
    * def db = new DbUtils(uri, dbName, collection)
    * json document = db.findByFieldThenDeleteField(collection, findField, findValue, deleteField)
    * print document
    * db.disconnect()

  # Will be kept here as reference
  @ignore
  Scenario Outline: Test Mongo Queries
    * def DbUtils = Java.type('utils.MongoDBUtils')
    * def db = new DbUtils(uri, dbName, "not used")
    * def mongoQueryAsJson =
    """
    {
      find: "fairs",
      "filter": {
        "fairId": "#(FAIRID_OR_CURRENT)"
      }
    }
    """
    * print mongoQueryAsJson
    * print FAIRID_OR_CURRENT
    * json document = db.runCommand(karate.toString(mongoQueryAsJson))
    * print document.cursor.firstBatch[0]
    * db.disconnect()

    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5196693           |


  # Will be kept here as reference
  @ignore
  Scenario Outline: Test Mongo Query Aggregate
    * def DbUtils = Java.type('utils.MongoDBUtils')
    * def db = new DbUtils(uri, dbName, "not used")
    * def AGGREGATE_PIPELINE =
    """
    [
        {
          $match:{
              "fairId":"#(FAIRID_OR_CURRENT)"
          }
        }
      ]
    """
    * def collectionName = "fairs"
    * json document = db.runAggregate(karate.toString(AGGREGATE_PIPELINE), collectionName)
    * print document
    * db.disconnect()

    Examples:
      | USER_NAME             | PASSWORD  | FAIRID_OR_CURRENT |
      | azhou1@scholastic.com | password1 | 5196693           |
