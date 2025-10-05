import ballerina/io;
import ballerinax/googleapis.gemini;

configurable string geminiApiKey = "<YOUR_GEMINI_API_KEY>";
configurable string geminiModel = "gemini-2.5-flash";

public function main() returns error? {
    
    // Create API configuration
    gemini:ApiKeysConfig apiKeysConfig = { xGoogApiKey: geminiApiKey };
    
    // Create the Gemini client
    gemini:Client geminiClient = check new (apiKeysConfig);

    // Prepare the content for the request
    gemini:Content userContent = {
        parts: [
            {
                text: "What is 1+1+1? Please explain the calculation step by step."
            }
        ],
        role: "user"
    };
    
    // Create the GenerateContentRequest
    gemini:GenerateContentRequest request = {
        model: geminiModel,
        contents: [userContent]
    };
    
    // Make the API call
    gemini:GenerateContentResponse response = check geminiClient->generativeServiceGenerateModelContent(
        geminiModel, request
    );
    
    // Extract and display the response
    string responseText = <string>response["candidates"][0]["content"]["parts"][0]["text"];
    io:println(responseText);
}




