package utils;

import org.bson.BsonDocument;
import org.bson.Document;
import org.bson.conversions.Bson;

import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoIterable;
import com.mongodb.client.model.Projections;
import org.bson.json.JsonWriterSettings;

import static com.mongodb.client.model.Filters.*;


public class MongoDBUtils {

    private final String clientURL;
    private final String dbName;
    private MongoClient mongoClient;

    public MongoDBUtils(String clientURL, String databaseName, String collectionName) {
        super();
        this.clientURL = clientURL;

        mongoClient = MongoClients.create(clientURL);
        dbName = databaseName;

//		connectToACollection(databaseName, collectionName);
//		getDocumentFields(databaseName, collectionName);
    }

    public void connectToACollection(String databaseName, String collectionName) {

        mongoClient = MongoClients.create(clientURL);

        try {
            MongoIterable<String> dbNames = mongoClient.listDatabaseNames();
            for (String dbName : dbNames) {

                if (dbName.equalsIgnoreCase(databaseName)) {

                    MongoDatabase database = mongoClient.getDatabase(databaseName);
                    MongoIterable<String> collection = database.listCollectionNames();

                    for (String collectName : collection) {
                        System.out.println("Collection Name ===> " + collectName);
                        if (collectName.equalsIgnoreCase(collectionName)) {

                            System.out.println("Looking for " + collectionName + " And found this " + collectName);

                        }

                    }
                }

            }

        } finally {

            mongoClient.close();
        }

    }

    public void getDocumentFields(String databaseName, String collectionName) {

        mongoClient = MongoClients.create(clientURL);

        try {
            MongoIterable<String> dbNames = mongoClient.listDatabaseNames();
            for (String dbName : dbNames) {

                if (dbName.equalsIgnoreCase(databaseName)) {

                    MongoDatabase database = mongoClient.getDatabase(databaseName);
                    MongoCollection<Document> collection = database.getCollection(collectionName);

                    Bson projectionFields = Projections.fields();
                    FindIterable<Document> cursor = collection.find();

                    System.out.println(" ============== Documents =========");

                    for (Document document : cursor) {

                        System.out.println(document);
                    }

                }
            }

        } finally {
            mongoClient.close();
        }

    }

    /*
     * public void getDistinctValuesFromACollection(String cmnd) {
     *
     * try {
     *
     * mongoClient = MongoClients.create(clientURL);
     */

    public void getDatabasesList(String dbUrl) {

        try {

            mongoClient = MongoClients.create(dbUrl);
            MongoIterable<String> dbNames = mongoClient.listDatabaseNames();
            for (String dbName : dbNames) {

                System.out.println("Database name is ===> " + dbName);

            }

        } catch (Exception e) {

            e.printStackTrace();
        }
        mongoClient.close();

    }

    public void runMongoCommand(String cmnd) {

        try {

            mongoClient = MongoClients.create(clientURL);
            MongoIterable<String> dbNames = mongoClient.listDatabaseNames();
            for (String dbName : dbNames) {

                System.out.println("Database name is ===> " + dbName);

            }

        } catch (Exception e) {

            e.printStackTrace();
        }
        mongoClient.close();


    }

    public void disconnect() {
        mongoClient.close();
    }

    public Document runCommand(String cmnd) {

        try {
            BsonDocument cmndBson = BsonDocument.parse(cmnd);
            return mongoClient.getDatabase(dbName).runCommand(cmndBson);

        } catch (Exception e) {

            e.printStackTrace();
        }
        return null;
    }

    public MongoClient client() {
        return mongoClient;
    }

    public String findByField(String collection, String field, String value) {
        try {
            FindIterable<Document> docs = mongoClient.getDatabase(dbName).getCollection(collection).find(eq(field, value));
            if (docs == null){
                return null;
            }else{
                for(Document doc: docs){
                    if(doc.get(field).equals(value)){

                        return doc.toJson(JsonWriterSettings.builder().build());
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

}
