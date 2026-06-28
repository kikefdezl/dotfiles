---
name: appmixer
description: Use when building, customizing, or embedding Appmixer. Contains official documentation mapping, REST API endpoints, UI SDK widget configuration, and custom connector patterns.
---

# Appmixer Skill

Use this skill whenever working on Appmixer integrations, embedding widgets, deploying self-managed Appmixer clusters, or building custom connectors.

## Official Documentation Map (No Hallucinations)
Always use these exact URLs to fetch detailed guides or reference files:

### Getting Started & Concepts
- Introduction: https://docs.appmixer.com/readme.md
- Build Your Automation Hub: https://docs.appmixer.com/getting-started/build-your-automation-hub.md
- Build and Publish a Template: https://docs.appmixer.com/getting-started/integrations.md
- Build a Custom Connector: https://docs.appmixer.com/getting-started/custom-connectors.md
- Embed into Your Application: https://docs.appmixer.com/getting-started/embed.md
- Access Appmixer REST API: https://docs.appmixer.com/getting-started/api.md

### REST API Reference
- Authentication: https://docs.appmixer.com/api/authentication.md
- Automation Hub Configuration: https://docs.appmixer.com/api/automation-hub.md
- Flows & Integrations: https://docs.appmixer.com/api/flows.md
- App & Connector Management: https://docs.appmixer.com/api/apps.md
- Accounts & Auth: https://docs.appmixer.com/api/accounts.md
- User & Groups: https://docs.appmixer.com/api/user.md
- Insights & Logs: https://docs.appmixer.com/api/insights.md
- Files & Storage: https://docs.appmixer.com/api/files.md
- Data Stores: https://docs.appmixer.com/api/data-stores.md
- ACL (Access Control Lists): https://docs.appmixer.com/api/acl.md

### UI SDK Reference (Frontend)
- Installation & Quickstart: https://docs.appmixer.com/appmixer-ui-sdk/installation.md
- Constructor: https://docs.appmixer.com/appmixer-ui-sdk/constructor.md
- Flow Manager: https://docs.appmixer.com/appmixer-ui-sdk/ui-and-widgets/flow-manager.md
- Designer Widget: https://docs.appmixer.com/appmixer-ui-sdk/ui-and-widgets/designer.md
- Insights Logs Widget: https://docs.appmixer.com/appmixer-ui-sdk/ui-and-widgets/insights-logs.md
- Accounts & Integrations: https://docs.appmixer.com/appmixer-ui-sdk/ui-and-widgets/accounts.md
- Custom Theme: https://docs.appmixer.com/customizing-embedded-ui/custom-theme.md
- Custom Strings & Localization: https://docs.appmixer.com/customizing-embedded-ui/custom-strings.md

### Building Custom Connectors & Components
- Basic Structure: https://docs.appmixer.com/building-connectors/basic-structure.md
- Manifest Schema: https://docs.appmixer.com/building-connectors/manifest.md
- Custom MCP Servers: https://docs.appmixer.com/building-connectors/mcp-servers.md
- Twilio SendSMS Example: https://docs.appmixer.com/building-connectors/example-component.md
- Webhook Trigger Example: https://docs.appmixer.com/building-connectors/custom-webhook-trigger.md

---

## 1. Custom Connector Conventions & Architecture
Every Appmixer connector is a folder structure containing:
- `component.js` (or execution logic)
- `manifest.json` (metadata, ports, configuration)
- `icon.svg`

### Manifest (`manifest.json`)
The manifest must follow the strict Appmixer schema:
```json
{
  "name": "vendor.service.Component",
  "label": "Send Message",
  "category": "Communication",
  "icon": "icon.svg",
  "inPorts": [
    { "name": "message", "label": "Message Content" }
  ],
  "outPorts": [
    { "name": "sent", "label": "Sent Details" },
    { "name": "error", "label": "Error Output" }
  ],
  "properties": [
    { "name": "apiKey", "type": "string", "label": "API Key", "required": true }
  ]
}
```

### Component Logic (`component.js`)
An Appmixer component implements a `receive(context)` function or standard methods:
```javascript
module.exports = {
    async receive(context) {
        const message = context.messages.message.content;
        const apiKey = context.properties.apiKey;

        try {
            // Ponytail: Keep standard HTTP calls clean and native
            const response = await context.helpers.request({
                method: 'POST',
                url: 'https://api.example.com/v1/send',
                headers: { 'Authorization': `Bearer ${apiKey}` },
                data: { text: message }
            });
            
            await context.sendJson(response.data, 'sent');
        } catch (err) {
            await context.sendJson({ error: err.message }, 'error');
        }
    }
};
```

---

## 2. Embedded UI SDK Conventions
To embed Appmixer widgets:
```javascript
import Appmixer from 'appmixer-js-sdk';

const apiConfig = {
    baseUrl: 'https://api.appmixer.com',
    accessToken: 'YOUR_JWT_ACCESS_TOKEN'
};

const appmixer = new Appmixer(apiConfig);

// Example: Embedding the Designer widget
const designer = appmixer.ui.Designer({
    el: '#designer-container',
    options: {
        menu: {
            'custom': ['appmixer.utils.ai']
        }
    }
});
designer.open();
```

---

## 3. Best Practices & Ponytail Guidelines
1. **Prefer Native Utilities (`appmixer.utils`)**: Do not write custom string manipulators or basic delays. Use standard built-in components and flow modifiers.
2. **Error Handling**: Always forward errors through dedicated `error` outPorts so flows can handle failures gracefully.
3. **Authentication**: Inject authentication credentials via `context.auth` using service configurations rather than hardcoding.
