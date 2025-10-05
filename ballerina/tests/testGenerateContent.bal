import ballerina/test;
import ballerina/log;

@test:Config {}
function testGeminiClientInitialization() {
    ApiKeysConfig apiKeysConfig = getTestApiKeysConfig();
    Client|error geminiClient = new (apiKeysConfig);
    test:assertTrue(geminiClient is Client, "Client should be initialized successfully");
}

@test:Config {
    enable: true
}
function testRealGeminiAPICall() returns error? {   

    // Initialize the client 
    ApiKeysConfig apiKeysConfig = getTestApiKeysConfig();
    Client geminiClient = check new (apiKeysConfig);
    

    // Prepare the content for the request
    Content userContent = {
        parts: [{ text: "What is 1+1+1? Please explain the calculation step by step."}],
        role: "user"
    };
    
    GenerateContentRequest request = {
        model: getTestGeminiModel(),
        contents: [userContent]
    };
    
    // Make the API call
    GenerateContentResponse response = check geminiClient->generativeServiceGenerateModelContent(
        getTestGeminiModel(), request
    );

    // Log the full response for debugging
    log:printInfo("Full Response: " + response.toJsonString());
    
    // Extract and print the response text (same logic as main.bal)
    string responseText = <string>response["candidates"][0]["content"]["parts"][0]["text"];

    // Verify we got a real response
    test:assertTrue(responseText.length() > 0, "Should get actual response text");
    
}