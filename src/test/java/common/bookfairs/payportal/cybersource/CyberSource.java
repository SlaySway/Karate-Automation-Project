//package common.bookfairs.payportal.cybersource;
//
//import com.fasterxml.jackson.core.type.TypeReference;
//import com.fasterxml.jackson.databind.ObjectMapper;
//import com.google.common.collect.ImmutableMap;
//import com.google.common.net.UrlEscapers;
//
//import java.io.IOException;
//import java.util.Map;
//import java.util.stream.Collectors;
//import java.util.stream.Stream;
//
//import static com.google.common.base.CaseFormat.LOWER_CAMEL;
//import static com.google.common.base.CaseFormat.LOWER_UNDERSCORE;
//import static java.util.Map.entry;
//
//public class CyberSource {
//
//    public void whenUserHitsExternalCybersourceSecureAcceptanceEndpoint(){
//        //converting response from camelCase to snake_case and passing as request body
//        String reqBody = "";
//        try {
//            ObjectMapper objectMapper = new ObjectMapper();
//            Map<String, Object> userData = objectMapper.readValue(createCreditCardSignatureResponse.getBody().asString(), new TypeReference<Map<String, Object>>() {
//            });
//            reqBody = Stream.concat(userData.entrySet().stream().map(it -> entry(it.getKey(), it.getValue())),
//                            ImmutableMap.of("cardType", "001", "cardExpiryDate", "12-2023",
//                                    "cardNumber", "4111111111111111", "cardCvn", "838").entrySet().stream())
//                    .map(it -> String.format("%s=%s", LOWER_CAMEL.to(LOWER_UNDERSCORE, it.getKey()),
//                            UrlEscapers.urlFormParameterEscaper().escape(String.valueOf(it.getValue()))))
//                    .collect(Collectors.joining("&"));
//
//            val requestBody = userData.entrySet().stream().map(it -> it.getKey() +
//                    "=" + UrlEscapers.urlFormParameterEscaper().escape((String) it.getValue())).collect(Collectors.joining("&"));
//            log.info("Signature token : {}", requestBody);
//        } catch (IOException e) {
//            throw new RuntimeException(e);
//        }

//        testContext.response = testContext.given.contentType("application/x-www-form-urlencoded").body(reqBody).
//                post(baseUri);
//        log.info("External response {} ", testContext.response.getBody().asString());
//
//        Document doc = Jsoup.parse(testContext.response.getBody().asString());
//        fairId = doc.getElementById("req_reference_number").attr("value");
//    }
//}
//}