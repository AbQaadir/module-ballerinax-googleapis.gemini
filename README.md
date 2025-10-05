# Ballerina Gemini connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-googleapis.gemini/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-googleapis.gemini/actions/workflows/ci.yml)
[![Trivy](https://github.com/ballerina-platform/module-ballerinax-googleapis.gemini/actions/workflows/trivy-scan.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-googleapis.gemini/actions/workflows/trivy-scan.yml)
[![GraalVM Check](https://github.com/ballerina-platform/module-ballerinax-googleapis.gemini/actions/workflows/build-with-bal-test-graalvm.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-googleapis.gemini/actions/workflows/build-with-bal-test-graalvm.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-googleapis.gemini.svg)](https://github.com/ballerina-platform/module-ballerinax-googleapis.gemini/commits/master)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/googleapis.gemini.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%googleapis.gemini)

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
configurable string geminiApiKey = ?;
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

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 17. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`googleapis.gemini` package](https://central.ballerina.io/ballerinax/googleapis.gemini/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
