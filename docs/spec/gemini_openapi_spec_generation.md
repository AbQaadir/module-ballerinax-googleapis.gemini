
# Gemini OpenAPI Specification Generation Process

This document describes the complete process of generating the OpenAPI YAML specification (`openapi.yaml`) for the [Google Gemini Generative Language API](https://ai.google.dev/gemini-api), starting from the official Protocol Buffer (`.proto`) files. It includes all steps, commands, and explanations required for reproducibility and future reference.

---

## Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Cloning the API Definitions](#cloning-the-api-definitions)
4. [Adapting the Protobuf Service Definition for OpenAPI Generation](#adapting-the-protobuf-service-definition-for-openapi-generation)
5. [Setting Up the OpenAPI Generator](#setting-up-the-openapi-generator)
6. [Generating the OpenAPI Spec](#generating-the-openapi-spec)
7. [Handling Authentication Schemes](#handling-authentication-schemes)
8. [Validating and Editing the Spec](#validating-and-editing-the-spec)
9. [References](#references)

---

## 1. Overview

Google Gemini API exposes generative AI models via REST endpoints, originally described in Protocol Buffers (`.proto`). To build a Ballerina client or connector, we first need an OpenAPI 3.x specification. This document describes how we generated the OpenAPI spec using official tools and supplemented authentication support.

---

## 2. Prerequisites

- **Protocol Buffers Compiler (`protoc`)**  
  [Install Guide](https://grpc.io/docs/protoc-installation/)
- **OpenAPI Generator Plugin for Protoc**  
  We used [`protoc-gen-openapi`](https://github.com/google/gnostic/tree/main/apps/protoc-gen-openapi) from Google's [gnostic](https://github.com/google/gnostic) project.
- **Clone of Google API proto files**  
  [Google APIs GitHub Repo](https://github.com/googleapis/googleapis)
- **(Optional) Swagger Editor** for validation  
  [Swagger Editor](https://editor.swagger.io/)

---

## 3. Cloning the API Definitions

Clone the Google APIs repository to fetch all necessary `.proto` files:
```sh
git clone https://github.com/googleapis/googleapis.git
```

---

## 4. Adapting the Protobuf Service Definition for OpenAPI Generation

### **Reason for Modification**

The original `google/ai/generativelanguage/v1beta/generative_service.proto` file defines several RPC methods with *additional_bindings* for HTTP options.  
However, **these additional_bindings result in ambiguous or duplicated `operationId`s in the generated OpenAPI spec, which may cause issues with client generators and tooling.**

**To resolve this, we split multi-binding RPCs into distinct RPC methods, each with a unique name and HTTP path. This ensures each OpenAPI operation has a unique `operationId` and avoids conflicts.**

### **Modification Example**

**Original Code**
```proto
service GenerativeService {
  // Generates a model response given an input GenerateContentRequest.
  rpc GenerateContent(GenerateContentRequest) returns (GenerateContentResponse) {
    option (google.api.http) = {
      post: "/v1beta/{model=models/*}:generateContent"
      body: "*"
      additional_bindings { post: "/v1beta/{model=tunedModels/*}:generateContent" body: "*" }
      additional_bindings { post: "/v1beta/{model=dynamic/*}:generateContent" body: "*" }
    };
    option (google.api.method_signature) = "model,contents";
  }
  // ... other RPCs ...
}
```

**Updated Code for OpenAPI Generation**
```proto
service GenerativeService {
  // The original RPC was split into three distinct methods to ensure unique operationIds for OpenAPI generation.
  rpc GenerateModelContent(GenerateContentRequest) returns (GenerateContentResponse) {
    option (google.api.http) = { post: "/v1beta/{model=models/*}:generateContent" body: "*" };
    option (google.api.method_signature) = "model,contents";
  }
  rpc GenerateTunedModelContent(GenerateContentRequest) returns (GenerateContentResponse) {
    option (google.api.http) = { post: "/v1beta/{model=tunedModels/*}:generateContent" body: "*" };
  }
  rpc GenerateDynamicContent(GenerateContentRequest) returns (GenerateContentResponse) {
    option (google.api.http) = { post: "/v1beta/{model=dynamic/*}:generateContent" body: "*" };
  }
  // ... other RPCs similarly split ...
}
```

**This change was applied to all RPCs with multiple HTTP bindings (including streaming methods) to ensure compatibility with OpenAPI tooling and accurate, unambiguous client code generation.**

---

## 5. Setting Up the OpenAPI Generator

Download or build the `protoc-gen-openapi` plugin from [gnostic releases](https://github.com/google/gnostic/releases) or build locally.

Make sure the plugin is accessible from your `PATH` or specify its location during the `protoc` command.

---

## 6. Generating the OpenAPI Spec

Navigate to your working directory and run the following command to generate the OpenAPI specification from the Gemini `.proto` files:

```sh
protoc \
  --proto_path=./googleapis \
  --openapi_out=./docs/spec \
  --openapi_opt=allow_merge=true,merge_file_name=openapi.yaml \
  path/to/generative_service.proto
```

- `--proto_path=./googleapis` sets the root directory for all proto imports.
- `--openapi_out=./docs/spec` outputs the generated OpenAPI YAML file in `docs/spec`.
- `--openapi_opt=allow_merge=true,merge_file_name=openapi.yaml` enables merging and sets the output filename.
- Replace `path/to/generative_service.proto` with the actual proto file(s) for Gemini.

The resulting file will be `docs/spec/openapi.yaml`.

---

## 7. Handling Authentication Schemes

**Important:**  
Protocol Buffers do **not** declare authentication schemas. The generated OpenAPI spec will lack security definitions.

### Manual Addition

Add the following block under `components > securitySchemes` in `openapi.yaml`:

```yaml
securitySchemes:
  ApiKeyAuth:
    type: apiKey
    in: header
    name: x-goog-api-key
    description: "Gemini API Key"
```

Also, add the default security requirement at the root:

```yaml
security:
  - ApiKeyAuth: []
```

---

## 8. Validating and Editing the Spec

- Open `docs/spec/openapi.yaml` in [Swagger Editor](https://editor.swagger.io/) to validate the syntax and schemas.
- Ensure all endpoints, schemas, and authentication requirements are present.
- Edit descriptions, examples, or schemas as needed for clarity or completeness.

---

## 9. References

- **Google Gemini API Documentation:**  
  [https://ai.google.dev/gemini-api](https://ai.google.dev/gemini-api)
- **Google Gemini OpenAPI Spec Repo:**  
  [https://github.com/AbQaadir/google-gemini-openapi-spec](https://github.com/AbQaadir/google-gemini-openapi-spec)
- **protoc-gen-openapi Plugin:**  
  [https://github.com/google/gnostic/tree/main/apps/protoc-gen-openapi](https://github.com/google/gnostic/tree/main/apps/protoc-gen-openapi)
- **Swagger Editor:**  
  [https://editor.swagger.io/](https://editor.swagger.io/)

---

## Example: Final File Placement

- The generated OpenAPI YAML file is located at:  
  `docs/spec/openapi.yaml`  
  *(This file is now the foundation for client generation and connector development.)*

---

@AbQaadir