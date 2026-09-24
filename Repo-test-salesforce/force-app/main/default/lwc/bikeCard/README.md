Bike Card - Salesforce Lightning Web Component

 Overview

'bikeCard' is a simple Salesforce Lightning Web Component (LWC) that displays bike information in a card-style layout.

 Bike Details

- **Name:** Electra X4
- **Description:** A sweet bike built for comfort.
- **Category:** Mountain
- **Material:** Steel
- **Price:** $2,700

 Component Files

- `bikeCard.html` – Displays the bike information and image.
- `bikeCard.js` – Defines the bike properties.
- `bikeCard.js-meta.xml` – Configures the component for Lightning pages.

 Technologies Used

- Salesforce Lightning Web Components (LWC)
- JavaScript
- HTML
- Salesforce Metadata XML

 Supported Lightning Pages

- Lightning App Page
- Lightning Record Page
- Lightning Home Page

 Deployment

Deploy the component using Salesforce CLI:

```bash
sf project deploy start --source-dir force-app/main/default/lwc/bikeCard
```

Or right-click the `bikeCard` folder in VS Code and select **SFDX: Deploy Source to Org**.

 Git Workflow

```bash
git add force-app/main/default/lwc/bikeCard
git commit -m "Add Bike Card LWC with documentation"
git push -u origin feature/Force-LWC
```

 Author

**Piyush gupta**

 Purpose

Created for Salesforce Lightning Web Components learning and development practice.