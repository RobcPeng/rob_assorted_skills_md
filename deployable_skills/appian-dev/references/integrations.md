# Integrations Reference

## Integration Architecture

Appian integrations connect to external systems through:

1. **Connected Systems** — store connection config (URL, auth credentials)
2. **Integrations** — define specific API calls using a connected system
3. **Component Plugins** — custom SAIL components (JavaScript front-end)
4. **Connected System Plugins** — server-side Java extensions with Client APIs

---

## Connected Systems

A connected system stores:
- Base URL
- Authentication (Basic, OAuth, API Key, AWS Signature, Google Service Account)
- HTTP headers shared across all integrations

**Referenced via constants:** `cons!APP_MY_CONNECTED_SYSTEM`

---

## Integration Objects

Integration objects define HTTP calls:

### GET Request
```
/* Integration: APP_getUser */
/* Connected System: cons!APP_EXTERNAL_API */
/* Method: GET */
/* Path: /api/users/{ri!userId} */
/* Rule Inputs: ri!userId (Integer) */

/* Usage in interface: */
a!localVariables(
  local!result: rule!APP_getUser(userId: ri!userId),
  if(
    local!result.success,
    a!textField(label: "Name", value: local!result.result.body.name, readOnly: true),
    a!richTextDisplayField(
      value: a!richTextItem(text: "Error: " & local!result.error.message, color: "NEGATIVE")
    )
  )
)
```

### POST Request
```
/* Integration: APP_createOrder */
/* Connected System: cons!APP_ORDER_API */
/* Method: POST */
/* Body: JSON from ri!orderData */

/* Usage: */
a!buttonWidget(
  label: "Create Order",
  style: "SOLID",
  color: "ACCENT",
  saveInto: {
    a!save(
      local!result,
      rule!APP_createOrder(orderData: local!orderPayload)
    ),
    if(
      local!result.success,
      a!save(local!confirmation, local!result.result.body),
      a!save(local!error, local!result.error.message)
    )
  }
)
```

### Integration Response Structure
```
/* Integration result structure: */
{
  success: true/false,
  result: {
    statusCode: 200,
    headers: { ... },
    body: { ... }    /* parsed JSON */
  },
  error: {
    message: "Error description",
    detail: "Detailed error"
  }
}
```

---

## Calling Integrations from Process Models

In process model nodes, integrations run as **Smart Services**:
```
/* Integration node output: */
pv!apiResult = rule!APP_getUser(userId: pv!userId)
```

---

## Web API Objects

Appian Web APIs expose endpoints that external systems can call:

```
/* Web API: APP_getEmployeeData */
/* URL: /suite/webapi/employee/{id} */
/* Method: GET */
/* Security: API Key or OAuth */

a!localVariables(
  local!id: http!request.pathParameters.id,
  local!employee: a!queryRecordByIdentifier(
    recordType: recordType!Employee,
    identifier: tointeger(local!id)
  ),
  a!httpResponse(
    statusCode: if(a!isNullOrEmpty(local!employee), 404, 200),
    headers: {
      a!httpHeader(name: "Content-Type", value: "application/json")
    },
    body: if(
      a!isNullOrEmpty(local!employee),
      a!toJson(a!map(error: "Employee not found")),
      a!toJson(local!employee)
    )
  )
)
```

---

## Component Plugin Development

Based on the [rich-text-editor-plugin](https://github.com/appian/rich-text-editor-plugin) pattern:

### Plugin Structure
```
my-plugin/
├── appian-component-plugin.xml      /* Component manifest */
├── myComponent/v1/
│   ├── index.html                   /* Entry point */
│   ├── index.js                     /* Component logic */
│   ├── custom.css                   /* Styles */
│   ├── icon.svg                     /* Component icon */
│   └── *.properties                 /* i18n bundles */
```

### Component Manifest (appian-component-plugin.xml)
```xml
<?xml version="1.0" encoding="UTF-8"?>
<appian-component-plugin key="com.example.myPlugin" name="My Plugin">
  <component rule-name="myComponent" version="1" height="auto"
             icon-path="myComponent/v1/icon.svg"
             html-entry-point="myComponent/v1/index.html">
    <parameter name="value" type="Text" send-changes-to-server="true" />
    <parameter name="readOnly" type="Boolean" />
    <parameter name="placeholder" type="Text" />
    <parameter name="connectedSystem" type="ConnectedSystem" />
    <parameter name="onUpload" type="Dictionary[]" event="true" />
  </component>
</appian-component-plugin>
```

### Component JavaScript (index.js)
```javascript
// Appian Component SDK v2.0.0 pattern:

// Receive parameters from SAIL
Appian.Component.onNewValue(function(allParameters) {
  var value = allParameters.value;
  var readOnly = allParameters.readOnly;
  // Update component UI...
});

// Send value back to SAIL
Appian.Component.saveValue("value", newValue);

// Fire event back to SAIL
Appian.Component.fireEvent("onUpload", uploadedFiles);

// Call Connected System Client API
Appian.Component.invokeClientApi(
  "connectedSystem",     // CS parameter name
  { data: payload },     // Request payload
  function(result) { /* success */ },
  function(error) { /* error */ }
);
```

### SAIL Usage of Component Plugin
```
fn!myComponent(
  label: "My Custom Component",
  value: local!value,
  saveInto: local!value,
  readOnly: false,
  placeholder: "Enter value...",
  connectedSystem: cons!MY_CONNECTED_SYSTEM
)
```

---

## Connected System Plugin Development (Java)

### Plugin Structure
```
my-csp/
├── build.gradle
├── src/main/java/com/example/
│   ├── MyConnectedSystem.java       /* extends SimpleConnectedSystemTemplate */
│   └── MyClientApi.java             /* extends SimpleClientApi */
├── src/main/resources/
│   ├── appian-plugin.xml            /* Server-side manifest */
│   └── *.properties                 /* i18n */
```

### Connected System Template (Java)
```java
public class MyConnectedSystem extends SimpleConnectedSystemTemplate {
  @Override
  protected SimpleConfiguration getConfiguration(
      SimpleConfiguration simpleConfiguration,
      ExecutionContext executionContext) {
    return simpleConfiguration.setProperties(
      textProperty("apiUrl")
        .label("API URL")
        .isRequired(true)
        .isImportCustomizable(true)
        .build(),
      textProperty("apiKey")
        .label("API Key")
        .masked(true)
        .isImportCustomizable(true)
        .build()
    );
  }
}
```

### Client API (Java)
```java
public class MyClientApi extends SimpleClientApi {
  @Override
  protected SimpleClientApiResponse execute(
      SimpleConfiguration connectedSystemConfig,
      SimpleClientApiRequest request) {

    String payload = request.getPayload().getString("data");
    String apiUrl = connectedSystemConfig.getValue("apiUrl");

    // Process the request...

    Map<String, Object> result = new HashMap<>();
    result.put("status", "success");
    result.put("data", processedData);

    return new SimpleClientApiResponse(result);
  }
}
```

---

## Process Model Integration

### Starting a Process
```
a!buttonWidget(
  label: "Submit Request",
  style: "SOLID",
  color: "ACCENT",
  submit: true,
  saveInto: {
    a!startProcess(
      processModel: cons!APP_PROCESS_MODEL,
      processParameters: {
        employeeId: local!employeeId,
        requestType: local!requestType,
        submittedBy: loggedInUser()
      },
      onSuccess: a!save(local!submitted, true),
      onError: a!save(local!errorMsg, "Failed to start process")
    )
  }
)
```

### Completing a Task Programmatically
```
a!completeTask(
  taskId: ri!taskId,
  taskOutputs: {
    approved: true,
    comments: local!comments
  },
  onSuccess: a!save(local!done, true),
  onError: a!save(local!error, "Task completion failed")
)
```

---

## JSON Handling

### Parse JSON
```
a!localVariables(
  local!jsonString: "{\"name\": \"John\", \"age\": 30}",
  local!parsed: a!fromJson(local!jsonString),
  local!parsed.name  /* "John" */
)
```

### Create JSON
```
a!toJson(
  a!map(
    name: local!employee.firstName,
    department: local!employee.department,
    items: a!forEach(
      items: local!lineItems,
      expression: a!map(
        id: fv!item.id,
        quantity: fv!item.quantity
      )
    )
  )
)
```

### JSON Path
```
a!jsonPath(
  value: local!jsonResponse,
  path: "$.results[0].name"
)
```

---

## Best Practices

1. **Store connection details in Connected Systems** — never hardcode URLs or credentials
2. **Use constants** for Connected System references: `cons!APP_MY_CS`
3. **Handle errors** — always check `.success` and provide user-friendly messages
4. **Use integration rules** — wrap integrations in expression rules for reuse
5. **Retry logic** — implement in process models, not interfaces
6. **Rate limiting** — be aware of external API limits; use async patterns for bulk calls
7. **Security** — use OAuth where possible; rotate API keys regularly
8. **Testing** — test with mock responses before connecting to production APIs
9. **Web APIs** — validate inputs, return proper status codes, use `a!httpResponse()`
10. **Plugin development** — follow Appian SDK patterns, use i18n for all user-facing strings
