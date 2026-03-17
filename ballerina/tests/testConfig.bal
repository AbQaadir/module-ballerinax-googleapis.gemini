// Central test configuration file
// All configurable variables should be declared here to avoid redeclaration

configurable string geminiApiKey = ?;
configurable string geminiModel = ?;
configurable string geminiEmbeddingModel = ?;

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