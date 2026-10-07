##Subscription Products
•	Used to sell products or services for a specific period. 
•	Supports subscription pricing, renewals, amendments, proration, and co-termination. 
•	Subscription products can be configured with different subscription terms. 

#Usage-Based Products
•	Pricing is based on the customer's usage or consumption. 
•	Supports predefined usage-based pricing. 
•	Pricing can increase based on usage volume. 


##Pricing Methods
Salesforce CPQ provides four pricing methods:
•	List Price 
•	Cost Price 
•	Block Price 
•	Percent of Total 

List Price
•	Price is taken from the associated Price Book Entry. 
•	Uses the Price Book and currency associated with the Quote. 
•	Native Salesforce Price Book and multi-currency features are supported. 
•	Only the eligible Price Book Entries are available for selection. 

Cost Price
•	Price is sourced from the Cost Entry associated with the product. 
•	Cost is maintained as a child record of the Product. 
•	Cost can be maintained per product and currency. 
•	Price Book Entries are not required for Cost Price. 

Block Price
•	Uses tiered pricing based on quantity ranges. 
•	Price is applied according to the applicable block. 
•	Useful when pricing is defined for quantity ranges. 
•	Block Price totals are treated as quantity 1 to avoid rounding issues. 

Percent of Total
•	Calculates the product price as a percentage of other quote line items. 
•	Percent of Total Base defines which price is used for the calculation. 
•	Percent of Total Constraint defines the maximum or minimum calculated price. 
•	Percent of Total Target allows another product's price to be used as the calculation basis. 
•	Include in Percent of Total controls whether the product participates in the calculation. 
•	Exclude from Percent of Total prevents the product from participating in the calculation. 


##Bundles
•	A bundle is a collection of products offered together. 
•	Bundles can contain optional features or components. 
•	Bundles can be pre-packaged or configurable. 
•	Bundles help control compatible product combinations. 
•	Bundles can support special pricing for components. 
Multi-Dimensional Quoting
•	MDQ divides a subscription product into multiple time-based segments. 
•	Each segment represents a unit of time. 
•	Quantity and pricing can vary between segments. 
•	Useful when subscription requirements change over time. 


##Configuration Type and Configuration Event
Configuration Type: None
•	Product is not taken to the configurator. 
•	Product is added directly to the Quote Line Editor. 
•	Product cannot be reconfigured from the Line Editor. 
Configuration Type: Required
•	Product is taken to the configurator initially. 
•	Product can be reconfigured from the Line Editor. 
•	Configuration is required. 
Configuration Type: Allowed
•	Product can be configured through the configurator. 
•	Supports different events such as Always, Add, and Edit. 
•	Can allow reconfiguration from the Line Editor depending on the event. 
Configuration Type: Disabled
•	Product is not taken to the configurator. 
•	Product is added directly to the Line Editor. 
•	Product cannot be reconfigured through the configurator. 


##Option Layout
•	Controls how bundle options are displayed in the configurator. 
•	Main layouts are: 
o	Sections 
o	Tabs 
o	Wizard 
•	Category can be used to organize features into different categories. 
Option Selection Method
•	Defines how bundle options are presented and selected. 
•	Options can use checkbox, radio button, or Add selection methods. 
•	Selection method can be configured at bundle and feature level. 
•	Feature-level selection method can override the bundle-level method. 


##Configuration Logic
•	Configuration logic ensures that the selected bundle configuration is valid. 
•	Helps guide users through the configuration process. 
•	Implemented using Option Constraints and Product Rules.

------------------------------------------------------------------------------------


### Option Constraints
- Learned about **Option Constraints** used to control product option behavior within bundles.
- **Dependency:** Automatically requires or enables a related product option.
- **Exclusion:** Prevents incompatible product options from being selected together.

### Twin Fields & Special Fields
- Learned about **Twin Fields** and how values can be synchronized between related CPQ records.
- Explored **Special Fields** used for specific CPQ configuration and pricing requirements.

### Product Attributes
- Learned about **Product Attributes** and their different types.
- Understood how attributes capture configuration-specific values during product selection.

### Bundled Products
- Learned how to create and configure **Bundle Products**.
- Explored product options, configuration rules, and option constraints within bundles.

### Subscription Products
- Learned how to create and configure **Subscription Products**.
- Understood how subscription products are carried through the **Quote → Order → Contract** lifecycle.



---------------------------------------------------------------------------------------

# Salesforce CPQ — Product Rules, Price Methods & MDQ

## Product Rules

Product Rules in Salesforce CPQ are used to control and automate product configuration and pricing behavior during the quoting process.

They help ensure that users select valid product combinations and that business rules are followed while configuring a quote.

### Types of Product Rules

#### 1. Validation Rule
- Prevents users from saving an invalid configuration.
- Displays an error message when a specific condition is not satisfied.
- Example: If Product A is selected, Product B must also be selected.

#### 2. Selection Rule
- Automatically adds, removes, enables, disables, or hides products/options based on conditions.
- Useful for automating product selections.
- Example: Selecting a Laptop automatically adds a required Charger.

#### 3. Filter Rule
- Controls which products or options are displayed to the user.
- Helps narrow down available products based on configuration criteria.
- Example: Show only compatible accessories for a selected product.

#### 4. Alert Rule
- Displays an informational or warning message to the user.
- Does not necessarily prevent the user from continuing.
- Example: Display a message when a premium support package is selected.

### Product Rule Execution

Product Rules can execute during different configuration events such as:
- Load
- Add
- Remove
- Edit
- Save

The appropriate event depends on when the business rule needs to be evaluated.

---

# Price Methods

Price Method determines how Salesforce CPQ calculates the price of a product.

### Common Price Methods

#### 1. List Price
- Uses the product's standard List Price from the Price Book.
- Example: Product List Price = $1,000.

#### 2. Block Price
- Price is determined based on a predefined quantity range/block.
- The customer pays the price associated with the applicable block rather than simply multiplying quantity × unit price.

**Example:**

| Quantity Range | Block Price |
|---|---:|
| 1–10 | $500 |
| 11–20 | $900 |
| 21–50 | $1,500 |

If the customer purchases 15 units, the applicable block is **11–20**, so the price is **$900**.

### Block Price with Coverage / Quantity Range

In Salesforce CPQ, Block Pricing can be used when a fixed price applies to a defined quantity range.

The important concept is that the block represents a **coverage/quantity range**, and the price is associated with that range.

**Example:**

A support package covers up to 100 users for $2,000.

- 1–100 users → $2,000
- 101–200 users → $3,500
- 201–500 users → $6,000

If the customer selects 75 users, the applicable block is **1–100**, so the price is **$2,000**.

This is useful for:
- Support packages
- User licenses
- Service tiers
- Usage-based offerings
- Capacity-based pricing

---

# MDQ — Multi-Dimensional Quoting

MDQ stands for **Multi-Dimensional Quoting**.

It allows a subscription product to be divided into multiple time segments, where quantity, discount, and pricing can vary for each segment.

Instead of having one price for the entire subscription term, CPQ allows different values for different periods.

### Example

A 3-year subscription can be divided into:

| Segment | Period | Quantity | Price |
|---|---|---:|---:|
| 1 | Year 1 | 10 | $1,000 |
| 2 | Year 2 | 20 | $1,800 |
| 3 | Year 3 | 30 | $2,500 |

This allows the business to model expected growth or changes over time.

### MDQ Segmentation

Common segmentation approaches include:

- **Year**
- **Quarter**
- **Month**

The segmentation determines how the subscription is divided into separate pricing periods.

### MDQ Use Cases

MDQ is useful when:
- Customer quantity changes over time.
- Pricing changes during the subscription term.
- Discounts vary by period.
- Business expects gradual user/customer growth.
- Subscription requirements are different for each period.

### MDQ vs Standard Subscription

**Standard Subscription:**
- Generally maintains the same quantity/pricing structure throughout the subscription term.

**MDQ Subscription:**
- Allows different quantities, prices, or discounts for individual time segments.

---
=====================================================================================================================================================================================================================================================================


Salesforce CPQ – Pricing, Guided Selling & Discounting
1. Account Contract Pricing
Definition
Account Contract Pricing allows Salesforce CPQ to apply customer-specific pricing based on an account's negotiated contract or pricing agreement.
Explanation
It is useful when a customer has a predefined price that is different from the standard product price.
Example
- Standard Product Price = $1,000
- Customer ABC Corp has a negotiated contract price = $850
- When ABC Corp creates a quote, CPQ can apply the $850 contract price instead of the standard price.
Use Case
- Enterprise customer-specific pricing
- Long-term negotiated contracts
- Partner/customer agreements
- Special pricing arrangements
2. Option Level Pricing
Definition
Option Level Pricing controls how the price of an individual product option is calculated when it is added to a bundle.
Explanation
In Salesforce CPQ, a bundle can contain multiple options. Each option can have its own pricing behavior depending on the bundle configuration.
Example
Suppose we have a Laptop Bundle:
Product Option	Price
Laptop	$1,000
Extra RAM	$100
Extended Warranty	$150


If the customer selects Extra RAM + Extended Warranty, CPQ adds the respective option prices to the bundle based on the configured pricing method.
Use Case
- Configurable bundles
- Optional add-ons
- Accessories
- Product upgrades
3. Guided Selling
Definition
Guided Selling is a Salesforce CPQ feature that helps sales users select the right products by asking a series of business-related questions.
Explanation
Instead of searching through a large product catalog manually, the sales representative answers questions and CPQ recommends or filters the relevant products.
Example
For a software product, CPQ may ask:
1. How many users do you need?
   → 100+

2. What type of deployment?
   → Cloud

3. Required support level?
   → Premium

Based on these answers, CPQ can display the appropriate products.
Benefits
- Simplifies product selection
- Reduces sales-user errors
- Speeds up quote creation
- Helps non-technical users configure complex products
4. Discount Schedules
Definition
A Discount Schedule automatically applies discounts based on criteria such as quantity or subscription term.
Explanation
Discount schedules are commonly used when customers receive better pricing for purchasing larger quantities.
Example
Quantity	Discount
1–10	0%
11–50	5%
51–100	10%
101+	15%


If the customer purchases 75 units:
List Price = $100
Quantity = 75
Discount = 10%

Discounted Price = $90 per unit

Use Case
- Volume-based pricing
- Bulk purchases
- Tiered discounts
- Subscription-term discounts
5. Price Rules
Definition
Price Rules are Salesforce CPQ automation rules used to calculate, modify, or populate pricing and other field values during the quoting process.
Explanation
Price Rules can evaluate conditions and then update a target field with a specific value.
Basic flow:
Condition
   ↓
Price Rule
   ↓
Price Action
   ↓
Update Target Field

Example
Suppose:
Product = Premium Support
Quantity > 100

The Price Rule can automatically apply:
Discount = 15%

Another example:
Region = Enterprise
Product = Software

The Price Rule can populate a specific customer or partner price.
Main Components
- Price Rule – Defines the overall pricing logic.
- Price Conditions – Determine when the rule should execute.
- Price Actions – Define what value should be changed.
- Target Field – Field that receives the calculated value.
- Evaluation Event – Determines when CPQ evaluates the rule.



=====================================================================================================================================================================================================================================================================


Salesforce CPQ — Quote Templates, Contracts, Amendments & Renewals
1. Quote Templates
A Quote Template in Salesforce CPQ is used to generate professional quote documents using Salesforce CPQ quote and quote line data.
Key Points
- Used to generate customer-facing Quote/Proposal documents.
- Can include Account, Quote, Quote Line, Product, Pricing, Discount, and Terms information.
- Supports different output formats such as PDF and Word, depending on configuration.
- Helps standardize the format and branding of customer quotes.
- Quote templates can contain sections, columns, line items, merge fields, and terms.
Example
A sales representative creates a quote containing:
- Account: ABC Corporation
- Product: Salesforce License
- Quantity: 100
- Discount: 10%
- Net Price: $50,000
The Quote Template can generate a professional PDF containing all this information.
2. Contracts
A Contract in Salesforce CPQ represents the customer's commercial agreement after a quote is finalized and contracted.
Key Points
- A quote can be contracted after the customer accepts the commercial terms.
- Contracting can create related Subscriptions and Assets, depending on the product configuration.
- The Contract stores information about the customer's agreement.
- Contract information can be used for future Amendments and Renewals.
- Subscription products can contain information such as:
  - Start Date
  - End Date
  - Subscription Term
  - Quantity
  - Recurring Price
Example
Customer purchases:
100 Salesforce licenses for 12 months.

After the quote is finalized and contracted:
Quote → Contract → Subscription
The subscription represents the customer's active subscription for those licenses.
3. Amendments
An Amendment is used when a customer wants to make changes to an existing contract before the contract expires.
Common amendment scenarios:
- Increase quantity
- Decrease quantity
- Add new products
- Remove products
- Change subscription terms
- Modify subscription quantities
Example
Original contract:
100 licenses for 12 months.

After 6 months, the customer wants:
150 licenses.

Instead of creating a completely new contract, we can create an Amendment Quote against the existing contract.
Flow
Existing Contract
       ↓
Create Amendment
       ↓
Amendment Quote
       ↓
Modify Products / Quantity
       ↓
Calculate
       ↓
Contract Amendment
       ↓
Updated Subscription

4. Renewals
A Renewal is used when an existing subscription or contract is approaching its expiration date and the customer wants to continue the service.
Key Points
- Used to extend an existing subscription.
- CPQ can create a Renewal Opportunity and Renewal Quote.
- Existing subscription information can be carried into the renewal.
- Products and quantities can be reviewed or modified during renewal.
- Renewal pricing can be affected by CPQ pricing and discount rules.
Example
Original contract:
100 licenses
Subscription Term: 12 months
Start Date: Jan 1, 2026
End Date: Dec 31, 2026

Before expiration, the customer wants to continue for another year.
CPQ can create:
Existing Contract
       ↓
Renewal Opportunity
       ↓
Renewal Quote
       ↓
Customer Review
       ↓
New Contract / Subscription