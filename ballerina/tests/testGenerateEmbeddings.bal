import ballerina/test;
import ballerina/log;

@test:Config {}
function testGeminiEmbeddingClientInitialization() {
    ApiKeysConfig apiKeysConfig = getTestApiKeysConfig();
    Client|error geminiClient = new (apiKeysConfig);
    test:assertTrue(geminiClient is Client, "Client should be initialized successfully");
}

@test:Config {
    enable: true
}
function testRealGeminiEmbeddingAPICall() returns error? {   

    // Initialize the client 
    ApiKeysConfig apiKeysConfig = getTestApiKeysConfig();
    Client geminiClient = check new (apiKeysConfig);
    
    // Prepare the content for embedding
    Content textContent = {
        parts: [
            {
                text: "The quick brown fox jumps over the lazy dog."
            }
        ]
    };
    
    // Create embedding request
    EmbedContentRequest request = {
        model: getTestEmbeddingModel(),
        content: textContent
    };
    
    // Make the API call
    EmbedContentResponse response = check geminiClient->generativeServiceEmbedContent(
        getTestEmbeddingModel(), request
    );
    
    // response.embedding is already ContentEmbedding type, no condition needed
    ContentEmbedding embedding = response.embedding;

    // embedding.values is already float[] type, no need to check
    float[] values = embedding.values;
    test:assertTrue(values.length() > 0, "Embedding should have dimension > 0");
    
    // Log embedding info
    log:printInfo("Embedding dimension: " + values.length().toString());
    log:printInfo("First 5 values: " + values.slice(0, 5).toString());
}