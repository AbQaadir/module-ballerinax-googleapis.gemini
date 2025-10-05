## Overview

Google Gemini is a powerful multimodal AI model that can understand and generate text, images, audio, and video content. The Gemini API enables developers to integrate advanced AI capabilities into their applications with features including:

- **Text Generation**: Generate human-like text responses for various use cases
- **Image Understanding**: Analyze and describe images, extract information from visual content
- **Video Understanding**: Process and analyze video content
- **Audio Understanding**: Handle audio input and processing
- **Document Processing**: Extract and understand information from documents
- **Function Calling**: Enable the model to call external functions and APIs
- **Code Execution**: Execute and analyze code snippets
- **Structured Output**: Generate responses in specific formats like JSON
- **Long Context**: Handle large amounts of context data efficiently
- **Embeddings**: Generate vector representations for semantic search and similarity tasks

This Ballerina connector provides seamless integration with the Google Gemini API, allowing you to leverage these advanced AI capabilities in your Ballerina applications.

## Setup guide

To use the Gemini API, you need to obtain an API key and configure it in your environment.

### Obtaining an API Key

1. Go to [Google AI Studio](https://aistudio.google.com/)
2. Sign in with your Google account
3. Navigate to the **API Keys** page from the Dashboard
4. If you don't have a Google Cloud project imported:
   - Click **Projects** in the left panel
   - Select **Import projects**
   - Search for and select your Google Cloud project, then click **Import**
   - If you don't have a project, create one in [Google Cloud Console](https://console.cloud.google.com/)
5. Once you have a project imported, go back to the **API Keys** page
6. Click **Create API Key** and select your project
7. Copy the generated API key

### Configuration Setup

Ballerina uses configurable variables that can be provided via a `Config.toml` file. Create a `Config.toml` file in your project root directory and configure the API key as follows:

#### Create Config.toml file
```toml
geminiApiKey = "your_api_key_here"
geminiModel = "gemini-2.5-flash"
```

#### Configure .gitignore
**Important**: Always add `Config.toml` to your `.gitignore` file to prevent accidentally committing your API key to version control:

```gitignore
Config.toml
```

This ensures your sensitive configuration data remains secure and is not exposed in your source code repository.

### Security Best Practices

- **Never commit API keys to source control**
- **Don't expose API keys in client-side code**
- **Use server-side calls with API keys** for production applications
- **Consider adding restrictions** to your API key in Google Cloud Console
- **Treat your API key like a password** - keep it secure and confidential

## Quickstart

### 1. Generate Content

To use the `Gemini` connector for content generation in your Ballerina application, update the `.bal` file as follows:

#### Step 1: Import the module

Import the `googleapis.gemini` module.

```ballerina
import ballerinax/googleapis.gemini;
```

#### Step 2: Instantiate a new connector

1. Create a `gemini:ApiKeysConfig` with the obtained API key and initialize the connector with it.

```ballerina
configurable string geminiApiKey = ?;
configurable string geminiModel = ?;
    
// Create API configuration
gemini:ApiKeysConfig apiKeysConfig = { xGoogApiKey: geminiApiKey };

// Create the Gemini client
gemini:Client geminiClient = check new (apiKeysConfig);
```

#### Step 3: Create the request

##### Prepare the content for the request

```ballerina
gemini:Content userContent = {
   parts: [
      {
            text: "Who were the brilliant minds behind the 2017 groundbreaking AI paper 'Attention Is All You Need'?"
      }
   ]
};

gemini:GenerateContentRequest request = {
   model: geminiModel,
   contents: [userContent]
};
```

#### Step 4: Invoke the connector operation

Now, utilize the available connector operations.

##### Generate content with Gemini

```ballerina
public function main() returns error? {
   gemini:GenerateContentResponse response = check geminiClient->generativeServiceGenerateModelContent(
      geminiModel, request
   );
}
```

#### Step 5: Run the Ballerina application

```bash
bal run
```

### 2. Generate Embedding

To use the `Gemini` connector for generating embeddings in your Ballerina application, follow these steps:

#### Step 1: Import the module

Import the `googleapis.gemini` module.

```ballerina
import ballerinax/googleapis.gemini;
```

#### Step 2: Instantiate a new connector

1. Create a `gemini:ApiKeysConfig` with the obtained API key and initialize the connector with it.

```ballerina
configurable string geminiApiKey = "AIzaSyDtGfTI1Mkj9R_4-sC1pwP8ivju2fLV0oI";
configurable string geminiEmbeddingModel = "gemini-embedding-001";

// Create API configuration
gemini:ApiKeysConfig apiKeysConfig = { xGoogApiKey: geminiApiKey };

// Create the Gemini client
gemini:Client geminiClient = check new (apiKeysConfig);
```

#### Step 3: Create the request

##### Prepare the content for embedding

```ballerina
gemini:Content textContent = {
    parts: [
        {
            text: "The quick brown fox jumps over the lazy dog."
        }
    ]
};

gemini:EmbedContentRequest request = {
    model: geminiEmbeddingModel,
    content: textContent
};
```

#### Step 4: Invoke the connector operation

Now, utilize the available connector operations.

##### Generate embedding with Gemini

```ballerina
public function main() returns error? {
    // Make the API call
    gemini:EmbedContentResponse response = check geminiClient->generativeServiceEmbedContent(
        geminiEmbeddingModel, request
    );
}
```

#### Step 5: Run the Ballerina application

```bash
bal run
```

## Examples

The `Gemini` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/module-ballerinax-googleapis.gemini/tree/main/examples/), covering the following use cases:

[//]: # (TODO: Add examples)
