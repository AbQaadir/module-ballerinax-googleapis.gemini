// Central test configuration file
// All configurable variables should be declared here to avoid redeclaration

configurable string geminiApiKey = "<GEMINI_API_KEY>";
configurable string geminiModel = "gemini-2.5-flash";
configurable string geminiEmbeddingModel = "text-embedding-004";

// Test utility functions
public function getTestApiKeysConfig() returns ApiKeysConfig {
    return { xGoogApiKey: geminiApiKey };
}

public function getTestGeminiModel() returns string {
    return geminiModel;
}

public function getTestEmbeddingModel() returns string {
    return geminiEmbeddingModel;
}