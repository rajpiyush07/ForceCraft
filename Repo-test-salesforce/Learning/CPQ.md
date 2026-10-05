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
