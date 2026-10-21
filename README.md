# Salesforce Opportunity Dashboard (LWC)

A deployable Lightning Web Component that reads Salesforce Opportunity records, searches by name, filters by stage, and creates new opportunities through Apex.

## Stack
- Lightning Web Components (HTML, JavaScript)
- Apex controller and SOQL
- `@wire` and `refreshApex`
- Lightning Base Components and toast notifications
- Apex unit test

## Requirements
- Salesforce CLI (`sf`)
- Salesforce org access with permission to deploy Apex and Lightning components
- A Salesforce org where the standard Opportunity object is enabled

## Deploy
Run these commands from this project directory:

```bash
sf org login web --alias MyOrg
sf project deploy start --target-org MyOrg
```

## Add to Salesforce UI
1. In Setup, open **Lightning App Builder**.
2. Create or edit a Home Page, App Page, or Opportunity Record Page.
3. Find **Opportunity Dashboard** in the custom components panel and drag it onto the page.
4. Save and Activate the page, assigning it to the appropriate app/profile if needed.

## Run tests
```bash
sf apex run test --class-names OpportunityDashboardControllerTest --target-org MyOrg --result-format human
```

## Notes
- The component queries at most 100 opportunities and uses the current user's record access (`with sharing`).
- Stage values are the standard Salesforce opportunity stages; adjust `STAGES` in the LWC if your org uses custom stage values.
- If your org has required custom fields or validation rules on Opportunity, add those fields to the create form/controller before creating records.
- API version is set to 66.0; change it if your target org requires a different supported API version.
