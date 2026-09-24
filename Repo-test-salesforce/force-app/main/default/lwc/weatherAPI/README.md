
#  Weather API - Salesforce LWC

A Salesforce Lightning Web Component (LWC) that fetches and displays current weather information for a searched city using an external Weather API.

##  Features

- Search weather by city name
- Display weather condition and icon
- Integrate external API using Apex HTTP Callout
- Use Salesforce Named Credential
- Apex unit testing with HttpCalloutMock
- Error handling for invalid locations

##  Technologies

- Salesforce Lightning Web Components (LWC)
- Apex
- JavaScript
- HTML
- HTTP Callouts
- Named Credentials
- Salesforce CLI
- Git & GitHub

##  Component Files

| File | Description |
|---|---|
| weatherAPI.html | Weather search UI |
| weatherAPI.js | Handles API response and UI |
| weatherAPI.js-meta.xml | Component metadata |
| WeatherAPI.cls | Apex HTTP Callout |
| WeatherAPITest.cls | Apex test class |

##  Named Credential

Named Credential: `WeatherAPI`

Endpoint:

```apex
callout:WeatherAPI/current.json?q=<city>
```

The Named Credential is used to securely configure access to the external API.

> Never commit API keys, passwords, or sensitive credentials to a public GitHub repository.

##  Application Flow

1. User enters a city name.
2. LWC calls the Apex method.
3. Apex sends an HTTP GET request using the Named Credential.
4. External API returns JSON data.
5. LWC displays the weather condition and icon.

##  Deployment

Deploy the LWC:

```bash
sf project deploy start --source-dir force-app/main/default/lwc/weatherAPI
```

Deploy Apex classes:

```bash
sf project deploy start --source-dir force-app/main/default/classes/WeatherAPI.cls
sf project deploy start --source-dir force-app/main/default/classes/WeatherAPITest.cls
```

##  Run Apex Test

```bash
sf apex run test --tests WeatherAPITest --result-format human --wait 10
```

The test uses `HttpCalloutMock` to simulate the external API response.

##  Git Workflow

```bash
git add force-app/main/default/lwc/weatherAPI
git add force-app/main/default/classes/WeatherAPI.cls
git add force-app/main/default/classes/WeatherAPI.cls-meta.xml
git add force-app/main/default/classes/WeatherAPITest.cls
git add force-app/main/default/classes/WeatherAPITest.cls-meta.xml

git diff --cached --name-status

git commit -m "Add Weather API LWC and Apex callout"

git push -u origin feature/Force-LWC
```

##  Author

**Piyush Gupta**

##  Purpose

Created for Salesforce LWC learning, Apex integration, external API callouts, Named Credential configuration, unit testing, and GitHub development practice.
