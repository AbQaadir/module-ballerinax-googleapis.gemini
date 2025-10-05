import ballerina/test;
import ballerina/log;

// Test configuration - hardcoded for testing
configurable string geminiApiKey = "<YOUR_API_KEY_HERE>";
configurable string geminiEmbeddingModel = "gemini-embedding-001";

@test:Config {}
function testGeminiEmbeddingClientInitialization() {
    ApiKeysConfig apiKeysConfig = { xGoogApiKey: geminiApiKey };
    Client|error geminiClient = new (apiKeysConfig);
    test:assertTrue(geminiClient is Client, "Client should be initialized successfully");
}

@test:Config {
    enable: true
}
function testRealGeminiEmbeddingAPICall() returns error? {   

    // Initialize the client 
    ApiKeysConfig apiKeysConfig = { xGoogApiKey: geminiApiKey };
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
        model: geminiEmbeddingModel,
        content: textContent
    };
    
    // Make the API call
    EmbedContentResponse response = check geminiClient->generativeServiceEmbedContent(
        geminiEmbeddingModel, request
    );
    
    if response.embedding is ContentEmbedding {
        ContentEmbedding embedding = <ContentEmbedding>response.embedding;

        test:assertTrue(embedding.values is float[], "Embedding should have values");
        
        if embedding.values is float[] {
            float[] values = <float[]>embedding.values;
            test:assertTrue(values.length() > 0, "Embedding should have dimension > 0");
            
            // Log embedding info
            log:printInfo("Embedding dimension: " + values.length().toString());
            log:printInfo("First 5 values: " + values.slice(0, 5).toString());
        }
    }
}