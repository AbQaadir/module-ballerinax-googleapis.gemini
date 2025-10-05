import ballerina/test;
import ballerina/log;

@test:Config {}
function testGeminiFunctionCallClientInitialization() {
    ApiKeysConfig apiKeysConfig = getTestApiKeysConfig();
    Client|error geminiClient = new (apiKeysConfig);
    test:assertTrue(geminiClient is Client, "Client should be initialized successfully");
}

@test:Config {
    enable: true
}
function testRealGeminiFunctionCallAPICall() returns error? {   

    // Initialize the client 
    ApiKeysConfig apiKeysConfig = getTestApiKeysConfig();
    Client geminiClient = check new (apiKeysConfig);
    
    // Define function declaration for smart light control (same as main-functioncall.bal)
    FunctionDeclaration setLightValuesFunction = {
        name: "set_light_values",
        description: "Sets the brightness and color temperature of a smart light.",
        parameters: {
            'type: "object",
            properties: {
                "brightness": {
                    'type: "integer",
                    description: "Light level from 0 to 100. Zero is off and 100 is full brightness"
                },
                "color_temp": {
                    'type: "string",
                    'enum: ["daylight", "cool", "warm"],
                    description: "Color temperature of the light fixture, which can be daylight, cool or warm"
                }
            },
            required: ["brightness", "color_temp"]
        }
    };
    
    // Create tool with function declarations
    Tool lightControlTool = {
        functionDeclarations: [setLightValuesFunction]
    };
    
    // Prepare the content for the request
    Content userContent = {
        parts: [
            {
                text: "Turn the lights down to a romantic level with warm color temperature."
            }
        ],
        role: "user"
    };
    
    // Create the GenerateContentRequest with tools
    GenerateContentRequest request = {
        model: getTestGeminiModel(),
        contents: [userContent],
        tools: [lightControlTool]
    };
    
    // Make the API call
    GenerateContentResponse response = check geminiClient->generativeServiceGenerateModelContent(
        getTestGeminiModel(), request
    );

    // Log the full response for debugging
    log:printInfo("Full Function Call Response: " + response.toJsonString());
    
    // Verify we got candidates
    test:assertTrue(response.candidates.length() > 0, "Should get at least one candidate");
    
    Candidate firstCandidate = response.candidates[0];
    test:assertTrue(firstCandidate.content.parts.length() > 0, "Should get at least one part");
    
    // Check if we got a function call
    boolean foundFunctionCall = false;
    string functionName = "";
    record {} functionArgs = {};
    
    foreach Part part in firstCandidate.content.parts {
        if part.functionCall is FunctionCall {
            foundFunctionCall = true;
            FunctionCall functionCall = <FunctionCall>part.functionCall;
            functionName = functionCall.name;
            
            if functionCall.args is record {} {
                functionArgs = <record {}>functionCall.args;
            }
            break;
        }
    }
    
    // Verify function call was made
    test:assertTrue(foundFunctionCall, "Should receive a function call from the model");
    test:assertEquals(functionName, "set_light_values", "Should call the set_light_values function");
    
    // Verify function arguments
    test:assertTrue(functionArgs.hasKey("brightness"), "Function args should contain brightness");
    test:assertTrue(functionArgs.hasKey("color_temp"), "Function args should contain color_temp");
    
    // Log the function call details
    log:printInfo("Function called: " + functionName);
    log:printInfo("Function arguments: " + functionArgs.toString());
    
    // Verify argument values are reasonable
    anydata brightness = functionArgs["brightness"];
    anydata colorTemp = functionArgs["color_temp"];
    
    // Brightness should be an integer between 0-100
    if brightness is int {
        test:assertTrue(brightness >= 0 && brightness <= 100, "Brightness should be between 0-100");
    }
    
    // Color temp should be one of the valid enum values
    if colorTemp is string {
        test:assertTrue(colorTemp == "daylight" || colorTemp == "cool" || colorTemp == "warm", 
                      "Color temp should be daylight, cool, or warm");
    }
    
    log:printInfo("Function call test completed successfully!");
}
