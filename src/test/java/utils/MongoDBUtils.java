package utils;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.mongodb.client.*;
import com.mongodb.client.model.Updates;
import com.mongodb.client.result.UpdateResult;
import org.bson.BsonDocument;
import org.bson.Document;
import org.bson.conversions.Bson;

import com.mongodb.client.model.Projections;
import org.bson.json.JsonWriterSettings;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

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

    public UpdateResult findByFieldThenUpdate(String collection, String findField, String value, String updateField, String updateValue) {
        try {
            MongoCollection<Document> mongoCollection = mongoClient.getDatabase(dbName).getCollection(collection);
            FindIterable<Document> docs = mongoClient.getDatabase(dbName).getCollection(collection).find(eq(findField, value));
            Document foundDocument = null;
            if (docs == null){
                return null;
            }else{
                for(Document doc: docs){
                    if(doc.get(findField).equals(value)){
                        foundDocument = doc;
                    }
                }
            }
            Bson updates = Updates.set(updateField, updateValue);

            UpdateResult result = mongoCollection.updateOne(foundDocument, updates);
            return result;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public AggregateIterable<Document> runAggregate(String cmnd, String collectionName) {

        try {

            List<Document> cmndBson = parsePipeline(cmnd);
            MongoDatabase database = mongoClient.getDatabase(dbName);
            MongoCollection<Document> collection = database.getCollection(collectionName);
            AggregateIterable<Document> results = collection.aggregate(cmndBson);
            return results;

        } catch (Exception e) {

            e.printStackTrace();
        }
        return null;
    }

    public static List<Document> parsePipeline(String aggregationJson){

        List<Document> pipeline = new ArrayList<>();
        try{
            ObjectMapper objectMapper = new ObjectMapper();
            List<Object> objects = objectMapper.readValue(aggregationJson, List.class);

            for( Object object: objects) {
                Document document = Document.parse(objectMapper.writeValueAsString(object));
                pipeline.add(document);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return pipeline;
    }

}
