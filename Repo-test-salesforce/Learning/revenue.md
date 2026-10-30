# Salesforce Revenue Cloud Learning Notes

## Overview

This section covers the concepts I learned while exploring **Salesforce Revenue Cloud**, with a focus on the end-to-end revenue lifecycle, subscription products, pricing, and Lead-to-Cash automation.

## Topics Covered

### 1. Revenue Cloud Fundamentals
Started learning the core concepts of **Salesforce Revenue Cloud** and how it helps organizations manage and automate the complete revenue lifecycle from customer acquisition to revenue realization.

### 2. Installation Boundary in SteelBrick CPQ
Learned about the **Installation Boundary** concept in Salesforce CPQ (SteelBrick) and understood how it defines the scope within which CPQ functionality and managed-package components operate.

### 3. Lead-to-Cash Automation
Understood how Revenue Cloud supports automation of the **Lead-to-Cash** process:

**Lead → Opportunity → Quote → Order → Contract → Billing → Revenue**

This helps reduce manual processes, improve accuracy, and provide a connected revenue management process.

### 4. Subscription-Based Products
Learned about **subscription products** and how they are managed throughout the revenue lifecycle, including:

- Subscription terms
- Recurring pricing
- Subscription quantities
- Contract-based subscriptions
- Renewals and ongoing customer relationships

### 5. Product Pricing Methodologies
Started learning different **product pricing methodologies** and how pricing can be calculated based on different business requirements, such as:

- Quantity-based pricing
- Subscription-term pricing
- Usage-based pricing
- Recurring pricing
- Customer-specific pricing



=====================================================================================================================================================================================================================================================================
                    
                    
                     09/10/2026



# Salesforce Revenue Cloud – Bundle Products

## 1. Introduction

A **Bundle Product** in Salesforce Revenue Cloud is a product offering that combines multiple related products or services into a single commercial offering. Instead of selecting and purchasing every product separately, customers can select a predefined package and configure its available components according to their requirements.

Bundles help businesses simplify product selection, maintain product compatibility, automate pricing, and streamline the complete **Lead-to-Cash** process.

### Example

A telecommunications company offers an Internet Connection Bundle containing:

- Internet Service
- Wi-Fi Router
- Installation Service
- Premium Support

A customer can purchase the complete package and, depending on the configuration, choose different router models or support plans.

**Business benefit:** Customers get a simplified buying experience, while the company can manage product selection, pricing, and order fulfillment more efficiently.

---

## 2. Why Do We Use Bundle Products?

Bundle products are useful when a business sells multiple products or services together.

Key benefits include:

1. **Simplified product selection:** Customers select one main offering instead of searching for multiple individual products.
2. **Product compatibility:** Businesses can control which products and options can be selected together.
3. **Flexible configuration:** Customers can choose optional components or select from predefined alternatives.
4. **Centralized pricing:** Bundle pricing can be designed around the overall package or the prices of its components, depending on the product catalog and pricing configuration.
5. **Reduced manual effort:** Product configuration and validation rules help reduce sales errors.
6. **Improved customer experience:** Sales representatives can configure packages based on customer requirements.
7. **Order management:** Configured products can flow into order capture and downstream fulfillment processes when the relevant Revenue Cloud capabilities are implemented.

---

## 3. Important Components of a Bundle

A typical bundle consists of a parent product and its related child products or options.

### 3.1 Parent Product

The parent product represents the main commercial offering.

Example: **Business Internet Bundle**

The parent product acts as the main entry point for configuring the package.

### 3.2 Child Products

Child products are individual products or services included in the bundle.

Example:

- Internet Connection
- Wi-Fi Router
- Installation Service
- Technical Support

Child products may be mandatory or optional, depending on the configuration.

### 3.3 Product Options

Product options define the products customers can select within a bundle.

For example, the Wi-Fi Router option may offer:

- Standard Router
- Advanced Router
- Premium Router

The available choices depend on the product catalog and configuration rules.


=====================================================================================================================================================================================================================================================================


                  CHANGES 12/10/2026 


# Salesforce Revenue Cloud – Quoting Lifecycle

## 1. Overview

The Salesforce Revenue Cloud Quoting Lifecycle describes the process of creating a quote, selecting products, calculating prices, obtaining approvals, generating orders, and creating assets.

It helps businesses automate the Lead-to-Cash process, manage product pricing, maintain quote accuracy, and streamline the transition from an opportunity to order fulfillment.

## 2. Quoting Lifecycle

The typical quoting process includes the following stages:

1. **Opportunity Creation** – Create an opportunity to track a potential sales deal, including customer requirements and estimated revenue.
2. **Quote Creation** – Generate a quote associated with the opportunity to present proposed products, pricing, discounts, and commercial terms.
3. **Product Selection** – Select the required products or services based on customer requirements.
4. **Pricing and Calculation** – Calculate product prices, apply eligible discounts, and determine the quote totals according to the configured pricing rules.
5. **Approval Process** – Submit the quote for approval when required, such as when discounts exceed permitted limits.
6. **Order Creation** – Convert an approved or accepted quote into an order, depending on the configured business process.
7. **Asset Generation** – Create or update asset records when applicable, representing products or services purchased by the customer.

**Note:** The exact sequence and automation depend on the Revenue Cloud implementation and business configuration.

## 3. Important Pricing and Summary Fields

### 3.1 Grand Total

Grand Total represents the final quote amount, including applicable taxes, fees, and other charges, according to the configured pricing and calculation model.

**Example:** If the quote subtotal is ₹50,000, applicable tax is ₹9,000, and additional fees are ₹1,000, the grand total is ₹60,000.

### 3.2 Subtotal

Subtotal represents the combined value of the quote line items before applicable taxes and additional charges. The precise treatment of discounts depends on the pricing implementation.

**Example:** If three products cost ₹10,000, ₹15,000, and ₹25,000, the subtotal before discounts and taxes is ₹50,000.

### 3.3 Total Price

Total Price represents the calculated price of a quote line or group of line items, depending on the field and quoting implementation.

In a Salesforce CPQ-style pricing waterfall, line-item pricing progresses through list price, discounts, and other adjustments to arrive at the applicable net price.

### 3.4 Discount

A discount reduces the price of a product or quote according to the configured discounting rules.

Discounts can include:
- Product-level discounts
- Volume-based discounts
- Partner or distributor discounts
- Quote-level discounts
- Special or negotiated discounts

**Example:** A product costs ₹10,000 and receives a 10% discount. The discounted amount is ₹9,000 before applicable taxes and additional charges.

Quote-level discounts must be evaluated according to the quote's eligibility and allocation rules.

## 4. Metadata and Quote Control Fields

### 4.1 Expiration Date

The Expiration Date defines how long a quote remains valid under the agreed commercial terms.

**Benefits:**
- Establishes quote validity.
- Helps sales representatives follow up with customers.
- Creates urgency for purchasing decisions.
- Supports quote-expiration management.

### 4.2 Calculation Status

Calculation Status indicates the state of quote pricing calculations, where supported by the quoting system.

Possible states depend on the implementation and may include processing, completed, or error conditions.

**Importance:**
- Helps identify whether pricing calculations have completed.
- Supports troubleshooting calculation errors.
- Helps users verify quote accuracy before submission or approval.

### 4.3 Price Book

A Price Book defines the catalog of products and their associated prices for a particular selling context.

In Salesforce, standard and custom price books can support different pricing requirements.

**Example:** A company may maintain separate price books for domestic and international customers.

**Benefits:**
- Maintains product pricing information.
- Supports different selling markets.
- Helps sales representatives select products with the appropriate prices.

### 4.4 Quote Number

The Quote Number is a unique identifier used to distinguish a quote from other quotes.

**Uses:**
- Quote identification and tracking.
- Customer communication.
- Reporting and record searches.
- Referencing a quote during approval and order processing.

### 4.5 Is Syncing

In Salesforce CPQ, the `IsSyncing` field indicates whether a quote is synchronized with its associated opportunity.

When a quote is synchronized, supported quote information can be reflected in the opportunity's synchronized fields.

**Importance:**
- Helps maintain consistency between the quote and opportunity.
- Supports opportunity revenue and product tracking.
- Helps users identify the synchronized quote.

## 5. Standard Quote Status Lifecycle

The available statuses and their exact behavior depend on the Salesforce quoting solution and its configuration.

### 5.1 Draft

A quote is being prepared and can generally be edited.

**Example:** A sales representative selects products and adjusts pricing before sharing the quote.

### 5.2 In Review

The quote is undergoing internal review or an approval process.

**Example:** A quote containing a discount above the permitted threshold is submitted for manager approval.

### 5.3 Presented

The quote has been presented or sent to the customer for consideration.

**Example:** The sales representative sends the quote document to the customer.

### 5.4 Accepted

The customer has accepted the quote according to the applicable business process.

**Example:** The customer confirms the proposed products and commercial terms.

Acceptance does not automatically mean an order or contract has been created; that depends on the configured process.

### 5.5 Declined

The customer rejects the proposed quote.

**Example:** The customer does not agree with the proposed price or contract terms.

### 5.6 Expired

The quote has passed its validity period without being accepted or renewed, according to the configured expiration process.

**Example:** A quote expires after 30 days if the customer does not respond.


=====================================================================================================================================================================================================================================================================


                   13/10/2026


# Salesforce Revenue Cloud – Dynamic Attributes, Product Configuration Rules & Data Interaction Framework

## 1. Dynamic Attributes – Hands-on Practice

### What are Dynamic Attributes?

Dynamic Attributes allow product configuration experiences to display relevant attributes and capture product-specific information based on the configured business requirements.

Instead of relying only on fixed product fields, businesses can use configurable attributes to collect information needed during product selection and configuration.

### Key Concepts

- **Flexible Configuration:** Supports capturing product-specific information during the configuration process.
- **Attribute Visibility:** Helps present relevant attributes in the product configuration experience.
- **Business Requirements:** Allows product configuration to collect information based on the product or use case.
- **Improved User Experience:** Helps users provide the necessary product details without navigating multiple records.

### Example

Consider a company selling laptops with different configuration requirements.

Depending on the product, users may need to provide details such as:

- RAM: 8 GB, 16 GB, or 32 GB
- Storage: 256 GB, 512 GB, or 1 TB
- Warranty: Standard or Extended

Dynamic Attributes can support the collection of these configurable values when appropriately set up.

### Learning Outcome

Gained hands-on experience with Dynamic Attributes and understood their role in making product configuration more flexible and user-friendly.

## 2. Product Configuration Rules – Theoretical Understanding

### What are Product Configuration Rules?

Product Configuration Rules define business logic that guides users when selecting and configuring products. They help ensure that the selected products, options, and attribute values satisfy the required configuration conditions.

### Why Are They Important?

- **Configuration Validation:** Helps prevent invalid product configurations.
- **Product Compatibility:** Supports rules governing which products or options can be selected together.
- **Business Logic:** Applies product selection requirements during configuration.
- **Consistency:** Helps maintain valid product combinations across the quoting process.

### Example

Suppose a laptop bundle includes a laptop, memory, storage, and warranty options.

Business requirements may specify that:
- A high-performance laptop must have at least 16 GB RAM.
- Certain warranty options are available only for eligible products.
- Incompatible product options must not be selected together.

Product configuration rules can help enforce these requirements, depending on the capabilities and configuration of the Revenue Cloud implementation.

### Learning Outcome

Understood the purpose of Product Configuration Rules and how they support valid product selection, compatibility, and business-driven configuration.

## 3. Data Interaction Framework – Theoretical Understanding

### What is the Data Interaction Framework?

The Data Interaction Framework supports the definition and handling of data used by Revenue Cloud runtime processes. It helps establish how relevant source information is structured, mapped, and made available for operations such as pricing and other business calculations.

One important concept studied within this framework is the **Context Definition Layer**.

## 4. Context Definition Layer

### What is a Context Definition?

A Context Definition establishes the structure of the data context used by a runtime process. It helps define the relevant data elements, their relationships, and the mappings required to make source information available for processing.

In simple terms, it helps the runtime engine understand which data is available and how that data is organized for the required operation.

### Key Responsibilities

- **Data Structure:** Defines the structure of information required by a runtime process.
- **Field Mapping:** Supports mapping relevant source data to the appropriate context fields.
- **Data Relationships:** Represents relationships between relevant data elements.
- **Runtime Processing:** Helps make the required data available to configured runtime operations.
- **Reusable Configuration:** Supports structured data handling across applicable processes.




==========================================================================================================================================================================================================================================================================================================================================




                       14/10/2026



# Salesforce Revenue Cloud: Context Definition, Pricing Procedure & Decision Tables

## 1. Overview

Salesforce Revenue Cloud uses Context Definitions, Pricing Procedures, and Decision Tables to support configurable, data-driven pricing calculations.

These components work together to retrieve relevant business data, evaluate pricing conditions, calculate product prices, and return the results to the transaction context.

This document explains the execution flow, Salesforce data mapping, pricing data synchronization, and the role of each component.

## 2. Execution Flow

The conceptual pricing flow is:

**Salesforce Source Data → Context Definition → Pricing Procedure → Decision Table Lookup → Pricing Calculation → Context Update**

> Note: A Pricing Procedure can invoke a Decision Table at a particular step. The Decision Table returns its result to the relevant pricing element, so this is not necessarily a strictly linear sequence in every implementation.

### Step 1: Salesforce Source Data

Salesforce stores the original business records and pricing information required for the transaction.

Examples include:
- Quote and Quote Line records
- Product and Price Book Entry records
- Customer and Account information
- Quantity, currency, and other pricing inputs
- Custom pricing configuration records

These records provide the information required to calculate the appropriate price.

### Step 2: Context Definition

A Context Definition establishes the data structure required by the pricing process. It defines nodes, attributes, relationships, context tags, and mappings.

Mapping connects the required context attributes to the appropriate Salesforce object fields.

**Key responsibilities:**
- Define the structure of pricing inputs.
- Map Salesforce data into context attributes.
- Organize related transaction and customer information.
- Provide context tags that pricing elements can reference.
- Receive pricing outputs through the associated context tags.

Salesforce provides the `SalesTransactionContext` context definition for sales transactions involving objects such as Quotes, Assets, and Orders. Pricing implementations can extend the base context to accommodate additional requirements.

### Step 3: Pricing Procedure

A Pricing Procedure defines the sequence of pricing elements used to calculate a product's price.

Each pricing element receives inputs, performs its configured operation, and produces outputs that can be used by subsequent elements.

Depending on the pricing strategy, a procedure can include:
- List Price calculation
- Volume Discount calculation
- Attribute-based pricing
- Manual Discount
- Additional price adjustments
- Net Price and total price calculations

**Example:**

A product has a list price of ₹50,000. The Pricing Procedure determines the applicable pricing steps and invokes the relevant pricing logic to calculate the final amount.

### Step 4: Decision Table

Decision Tables store structured conditions and corresponding results. A Pricing Procedure can invoke a Decision Table to retrieve the appropriate pricing information or rule outcome.

For example:

| Customer Type | Quantity | Discount |
|---|---:|---:|
| Retail | 1–5 | 0% |
| Enterprise | 1–5 | 10% |
| Enterprise | 6–10 | 15% |

If an Enterprise customer purchases 3 units, the applicable row returns a 10% discount.

The pricing element then uses that output in the remaining calculation steps.

**Benefits:**
- Centralized pricing rules
- Reduced need for hardcoded conditions
- Easier maintenance of pricing policies
- Better visibility into decision logic

### Step 5: Pricing Result and Context Update

After the pricing elements execute, the procedure returns its outputs through the relevant context tags.

The resulting pricing information can then be used by the transaction process to update the applicable quote or quote line information.

The exact fields updated depend on the pricing configuration and transaction flow.

## 3. Real-Time Pricing Data Synchronization

### What is Pricing Data Synchronization?

Salesforce Pricing provides a synchronization operation that refreshes the pricing lookup data used by Decision Tables.

For example, a company maintains product prices and discount information in Salesforce records. When the pricing administrator performs the configured **Sync Pricing Data** operation, the relevant pricing data is refreshed in the decision-table lookup layer.

This helps pricing calculations use the appropriate synchronized pricing data.



==========================================================================================================================================================================================================================================================================================================================================


                                       15/10/2026

# Salesforce Revenue Cloud – Qualification Rules & Usage-Based Products

## 1. Qualification Rules

Qualification Rules in Salesforce Revenue Cloud help determine whether a product, offer, or option meets specific business eligibility criteria.

### Key Learnings
- Learned the purpose of Qualification Rules and their role in product qualification.
- Practiced defining conditions to evaluate whether a product or option qualifies for a particular scenario.
- Understood how qualification logic can use contextual data and decision outcomes to support business requirements.

## 2. Context Definition

A Context Definition specifies the data structure and context required to evaluate business rules.

### Hands-on Practice
- Created a Context Definition for the qualification process.
- Identified the data inputs required for evaluating qualification conditions.
- Explored how relevant Salesforce data can be made available to the rule evaluation process.
- Understood the role of context in connecting input data with decision logic.

## 3. Decision Table

A Decision Table represents business logic through configurable conditions and corresponding outcomes.

### Hands-on Practice
- Created and configured a Decision Table.
- Defined input conditions and expected output values.
- Practiced organizing qualification logic into structured business rules.
- Understood how decision tables make business logic easier to maintain and update.

### Example
A business can use a Decision Table to evaluate customer eligibility based on product type, usage level, or customer category.

## 4. Qualification Table

A Qualification Table is used in the qualification setup to represent and manage the criteria or outcomes required for product qualification.

### Hands-on Practice
- Created a Qualification Table as part of the qualification implementation.
- Explored how qualification criteria are represented and evaluated.
- Practiced working with the qualification configuration alongside Context Definitions and Decision Tables.

## 5. Qualification Process – Conceptual Flow

The following represents the general relationship between the components practiced:

1. **Context Definition:** Defines the required input data and context.
2. **Decision Table:** Evaluates configured conditions and produces decision outcomes.
3. **Qualification Rule and Table:** Use the configured qualification logic to determine eligibility according to the implementation.
4. **Qualification Outcome:** Determines whether the relevant product or option meets the configured business criteria.

*Note: The exact execution sequence and relationship between these components depend on the Revenue Cloud configuration.*

---

## 6. Usage-Based Products

Usage-Based Products are products or services whose charges depend on measured consumption, usage quantities, or commitment agreements.

### Key Learnings
- Learned the fundamentals of usage-based products in Salesforce Revenue Cloud.
- Explored different usage models and their pricing concepts.
- Understood how usage models support consumption-based monetization.
- Studied how customer commitments can define included usage, quantities, or monetary limits.

## 7. Types of Usage Models

### 7.1 Anchor Model

The Anchor model uses a defined reference point or anchor to associate usage with the relevant product or commercial arrangement.

**Learning points:**
- Studied the concept of an anchor in usage-based product modeling.
- Explored how the anchor can help associate usage with the applicable product or agreement.
- Learned its role in structuring usage-related configuration.

### 7.2 Pack Model

The Pack model organizes usage into predefined units or packs.

**Example:** A customer purchases a pack of 1,000 API calls.

**Learning points:**
- Understood how usage can be organized into predefined packs.
- Explored how pack sizes can represent a specific quantity of usage.
- Learned how pack-based offerings can support predefined consumption options.

### 7.3 Quantity Commitment Model

The Quantity Commitment model defines a commitment to consume or purchase a specified quantity of usage.

**Example:** A customer commits to consuming 10,000 API calls during a contract period.

**Learning points:**
- Studied quantity-based commitments.
- Understood how a defined usage quantity can form part of a commercial agreement.
- Explored the relationship between committed quantity and actual consumption.

### 7.4 Token Commitment Model

The Token Commitment model uses a defined token allocation or commitment for usage.

**Example:** A customer receives a commitment of 50,000 tokens for an AI-powered service.

**Learning points:**
- Learned how tokens can represent units of consumption for a service.
- Explored token-based usage commitments.
- Understood the importance of tracking consumption against the allocated token commitment.

### 7.5 Monetary Commitment Model

The Monetary Commitment model defines a committed monetary amount for usage during a specified period.

**Example:** A customer commits to spending ₹50,000 on a cloud service during a contract period.

**Learning points:**
- Studied monetary commitments for usage-based services.
- Understood how a financial commitment can define the commercial arrangement.
- Explored how usage charges may be tracked against the committed amount.




======================================================================================================================================================================================================================================================================================================================================================================================================



                                 19/10/2026



# Salesforce Revenue Cloud – Rate Card & Price Management

## 1. Rate Card: Base, Tiers, and Attributes

- **Rate Card:** Defines the pricing structure for usage-based products or services.
- **Base Rate:** The standard rate charged per unit of usage.
- **Tier-Based Rate:** Pricing changes according to usage ranges or quantity slabs.
- **Attribute-Based Rate:** Pricing varies based on attributes such as region, service type, or customer category.

**Example:**
A cloud service charges ₹10 per API call, but the rate changes based on monthly usage or the selected service tier.

---

## 2. Rate Card Management

Rate Card Management helps maintain rates and determine how charges are calculated.

- **Rate Card:** The main container that organizes pricing rates.
- **Rate Card Entry:** An individual pricing entry defining a rate for a particular product, usage type, or condition.
- **Rate Adjustment by Tiers:** Adjusts rates based on usage slabs.
  - 1–100 calls: ₹10 per call
  - 101–500 calls: ₹8 per call
- **Rate Adjustment by Attributes:** Adjusts rates based on attributes such as region, service level, or customer category.

---

## 3. Price Management → Pricing Procedure

**Price Management** manages how prices are determined and calculated in Salesforce Revenue Cloud.

A **Pricing Procedure** defines the sequence of steps used to calculate the final price of a product or service.

### Core Elements to Configure

- **Pricing Procedure:** Defines the overall pricing calculation flow.
- **Pricing Procedure Step:** Specifies an individual calculation step and its sequence.
- **Pricing Element:** Represents a pricing component, such as a base price, discount, surcharge, or tax.
- **Condition / Decision Logic:** Determines when a pricing rule or calculation applies.
- **Formula / Calculation Logic:** Calculates the value for a pricing step when required.
- **Input and Output Mapping:** Passes the required data into the pricing process and returns calculated results.

### Example Pricing Flow

| Pricing Component | Amount |
|---|---:|
| Base Rate | ₹1,000 |
| Tier Adjustment | -₹100 |
| Discount | -₹50 |
| **Final Price** | **₹850** |

> **Note:** This is an illustrative example. Actual calculation order and configuration depend on the pricing setup.

## 4. Key Takeaway

**Rate Card → Rate Card Entry → Tier / Attribute Adjustments → Pricing Procedure → Final Calculated Price**

These concepts help manage usage-based pricing and configure pricing calculations in Salesforce Revenue Cloud.


======================================================================================================================================================================================================================================================================================================================================================================================================



                                      26/10/2026

# Salesforce Revenue Cloud — Technical Note

# 1. Order Management

## Definition

**Order Management** is the process of capturing, validating, processing, and tracking customer orders from order creation through fulfillment and completion.

In Salesforce Revenue Cloud, Order Management connects the commercial transaction with downstream fulfillment processes and helps ensure that customers receive the products or services they purchased.

## Types of Order Management

Order Management can be classified by the business process involved:

- **Sales Order Management:** Capturing and processing customer purchases.
- **Subscription Order Management:** Processing recurring or term-based products and services.
- **Change Order Management:** Handling supported changes to existing orders.
- **Return Order Management:** Processing eligible product returns and associated transactions.
- **Fulfillment Order Management:** Coordinating delivery, provisioning, or activation of products and services.

*Note: These are common order-management process categories, not necessarily separate standard Salesforce object types.*

# 2. Dynamic Revenue Orchestration (DRO)

## Definition

**Dynamic Revenue Orchestration (DRO)** coordinates complex order fulfillment by decomposing commercial orders into fulfillment tasks and dynamically managing their execution across connected systems.

DRO helps organizations execute complex product and service deliveries using dependencies, orchestration plans, and fulfillment processes.

## Core Components of DRO

### 1. Order Decomposition
Breaks a commercial order into service-specific or product-specific fulfillment components.

### 2. Fulfillment
Executes the work required to deliver or activate the ordered products and services.

### 3. Order Orchestration
Coordinates fulfillment activities, dependencies, execution order, and completion status.


# 3. Asset Management

## Definition

**Asset Management** tracks products or services that a customer owns, has purchased, or is entitled to use, according to the product and asset lifecycle configuration.

In Salesforce Revenue Cloud, asset lifecycle management supports eligible commercial changes and provides visibility into the customer's installed or active product base.
ed Base | The collection of products or services associated with a customer. |

# 4. Renewal Management

## Definition

**Renewal Management** manages the continuation of eligible contracts, subscriptions, or term-based entitlements into a new term after the current term expires.

Renewals support recurring revenue, customer retention, and the continuation of contracted products or services.




======================================================================================================================================================================================================================================================================================================================================================================================================


                                    29/10/2026

# Salesforce Revenue Cloud – Transaction Management & Billing

## 1. Transaction Management
- **Transaction Management:** Manages commercial transactions and transaction line processing.
- **Transaction Line Editor (TLE):** Configures and organizes transaction lines using groups for improved usability.
- **Transaction Configuration:** Supports structured transaction processing in Revenue Cloud.

## 2. Salesforce Billing
- **Permission Sets:** Control user access to Salesforce Billing features and objects.
- **Billing & Tax Object Model:** Defines relationships between billing transactions, invoices, invoice lines, and tax-related records.
- **Billing Policies:** Define rules governing billing behavior and processing.
- **Billing Treatments & Treatment Items:** Configure billing-specific processing rules for applicable transaction items.

## 3. Billing Schedules & Invoicing
- **Billing Schedules:** Define when and how billing amounts are scheduled for invoicing.
- **Billing Schedule Groups:** Organize related billing schedules for easier management.
- **Invoice Generation:** Automates invoice creation based on configured billing schedules and processes.
- **Payment Terms & Term Items:** Define payment due dates and payment conditions.

## 4. Payments & Invoice Settlement
- **Payment Management:** Tracks payments and their association with invoices.
- **Invoice Lines:** Represent individual products, services, and charges within an invoice.
- **Invoice Settlement:** Manages the process of applying payments and resolving outstanding invoice balances.




====================================================================================================================================================================================================================================================================================================================================================================================


                            30/10/2026



Salesforce Revenue Cloud – Billing Object Model (Detailed Notes)
The Salesforce Billing Object Model defines how products, orders, billing policies, billing schedules, invoices, payments, and credit memos work together to manage the complete customer billing lifecycle.

The main objective is to convert a customer's purchase into billable transactions, generate accurate invoices, collect payments, and manage adjustments.
1. Product
Product represents the goods or services that a company sells to its customers.
- Products are created in the Product Catalog.
- Each product has details such as Product Name, Product Code, Description, and Active Status.
- Products can have different pricing methods and billing configurations.
- Products can be standalone or part of a product bundle.
- Product configuration determines how the product is ordered and eventually billed.
Example:

A telecom company offers:
- Internet Plan – ₹999/month.
- Installation Service – ₹2,000 one-time.
- Premium Support – ₹499/month.
Each of these is a separate product with its own pricing and billing behavior.
2. Billing Policy
Billing Policy defines the billing configuration and rules that determine how a customer's purchased products are billed.
- Defines applicable billing behavior for products or orders.
- Helps control billing-related configurations.
- Supports different billing requirements based on business processes.
- Helps maintain consistency in billing operations.
Real-world example:

A company sells three products:
- Internet Subscription – Monthly billing.
- Installation Service – One-time billing.
- Premium Support – Annual billing.
The billing configuration needs to support different billing frequencies and charge types.

Important: Do not confuse a Billing Policy with a Product or Price Book. A product defines what is sold, pricing defines how much it costs, and billing configuration determines how and when charges are billed.
3. Order
Order represents the customer's confirmed purchase of products or services.
- An order is generally created after the quote is accepted.
- It contains customer purchase information.
- It is associated with an Account.
- It contains Order Products.
- It represents the commercial commitment between the company and customer.
- Orders can progress through different statuses depending on the business process.
Example:

A customer purchases:
- Internet Plan – ₹999/month.
- Installation – ₹2,000.
- Premium Support – ₹499/month.
Salesforce creates an Order containing these purchased products.
4. Order Product (Order Item)
Order Product represents an individual product or service included in an order.

It connects the Order with the Product.

Important information includes:
- Product
- Quantity
- Unit Price
- Total Price
- Start Date
- End Date
- Service-related information
Example:

An order contains three Order Products:
Product	Quantity	Price
Internet Plan	1	₹999
Installation	1	₹2,000
Premium Support	1	₹499

Each line represents a separate purchased item.
5. Billing Schedule
A Billing Schedule determines when a particular charge should be billed.

Depending on the billing configuration, billing can be:
- One-time billing.
- Monthly billing.
- Quarterly billing.
- Half-yearly billing.
- Annual billing.
- Milestone-based billing.
Example:

A customer purchases a one-year subscription worth ₹12,000.

The company can generate 12 monthly charges of ₹1,000 instead of charging the entire amount upfront, depending on the configured billing process.
6. Invoice
An Invoice is a financial document generated to request payment from the customer for purchased products or services.

It contains:
- Invoice Number.
- Account Information.
- Invoice Date.
- Due Date.
- Total Amount.
- Tax Amount.
- Invoice Status.
- Payment information.
Example:

A customer receives an invoice:
Description	Amount
Internet Plan	₹999
Premium Support	₹499
Installation	₹2,000
Total	₹3,498

The invoice represents the amount the customer needs to pay.
7. Invoice Line
Invoice Line represents an individual charge included in an invoice.
- Each invoice can contain multiple invoice lines.
- Each line represents a billed product or service.
- It contains quantity, price, tax, and charge information.
- It helps identify exactly what the customer is paying for.
Example:

An invoice has three invoice lines:
1. Internet Subscription – ₹999.
2. Premium Support – ₹499.
3. Installation – ₹2,000.
The invoice combines all three lines into one payable amount.
8. Payment
Payment represents the money received from a customer against an invoice.
- Tracks the amount received.
- Maintains payment status.
- Helps reconcile customer payments with invoices.
- Supports full and partial payment scenarios, depending on configuration.
Example:

A customer has an invoice of ₹3,498.
- First payment: ₹2,000.
- Second payment: ₹1,498.
After both payments are successfully applied, the invoice can be marked as paid.
9. Credit Memo
A Credit Memo is a financial document used to reduce or reverse an amount previously invoiced to a customer.

Common use cases:
- Product returns.
- Incorrect billing.
- Overcharging.
- Service cancellations.
- Discounts or billing adjustments.
Example:

A customer receives an invoice of ₹10,000, but the company discovers that ₹2,000 was charged incorrectly.

The company generates a Credit Memo for ₹2,000, reducing the customer's outstanding balance.
10. Credit Memo Line
Credit Memo Line represents the individual adjustment or credit applied to a specific invoice line.

Example:

Original invoice:
- Internet Service: ₹5,000.
- Installation: ₹2,000.
The company issues a credit of ₹1,000 against the Internet Service.

The Credit Memo Line identifies the affected charge and its adjustment amount.
11. Billing Treatment
Billing Treatment defines how Salesforce Billing should invoice an Order Product.

It controls how the order item's total value is billed during its lifecycle.

Important concepts:
- Determines whether an order item is included in billing.
- Defines billing behavior.
- Controls how the total amount is distributed across billing schedules.
- Supports advance and arrears billing.
- Can be used for different billing requirements.
Example:

A customer purchases a subscription worth ₹12,000 for 12 months.

There are two possible billing approaches:
- Monthly: ₹1,000 every month.
- Annual: ₹12,000 in one billing period.
The billing treatment determines how the order item's value is allocated for invoicing.
Types of Billing
Advance Billing: The customer is invoiced before receiving the service for the upcoming period.

Example: The customer receives an invoice on January 1 for January's subscription.

Arrears Billing: The customer is invoiced after receiving the service.

Example: The customer receives an invoice on February 1 for the service consumed during January.
12. Billing Treatment Item
Billing Treatment Item defines how much of the Order Product's total amount should be invoiced at each billing stage.
- It is associated with a Billing Treatment.
- Defines the allocation of the order item's value.
- Supports percentage-based and other billing allocation methods.
- Processing Order determines the sequence in which billing treatment items are evaluated.
Example:

A customer purchases a product worth ₹10,000.

The company wants to bill it in two milestones:
- First milestone: 40% = ₹4,000.
- Second milestone: 60% = ₹6,000.
The Billing Treatment Items define these allocations.

In Revenue Management Billing, the treatment configuration has specific constraints; for example, it requires a single treatment item covering 100% of the order item's total value. 
Salesforce Help+1

13. Billing Schedule Group
A Billing Schedule Group provides a consolidated view of billing schedules associated with an asset and its related order items.
- Groups related billing schedules.
- Helps manage subscription billing.
- Supports billing schedule management across new orders and amendments.
- Helps control billing preferences such as billing dates and payment terms.
- Supports invoice grouping and splitting.
Example:

A customer has purchased:
- Internet Subscription.
- Premium Support.
- Additional Storage.
Instead of managing all billing schedules independently, Salesforce can organize related schedules into a Billing Schedule Group.

This makes billing operations easier to manage. 
Salesforce Help+1

14. Billing Frequency
Billing Frequency determines how frequently the customer receives invoices.

Common billing frequencies include:
- Monthly.
- Quarterly.
- Half-yearly.
- Annually.
- Other configured billing intervals.
Example:

A customer purchases a subscription for ₹24,000 annually.

Depending on the configured billing frequency:
- Monthly: ₹2,000.
- Quarterly: ₹6,000.
- Half-yearly: ₹12,000.
- Annually: ₹24,000.
Important: Pricing Frequency and Billing Frequency can be different.

For example, a product can be priced monthly but billed annually. Salesforce supports this configuration. 
Salesforce Help+1

15. Proration
Proration means calculating charges based on the actual period for which a customer uses a product or service.

It is commonly used when:
- A subscription starts in the middle of a billing cycle.
- A customer upgrades a subscription.
- A customer downgrades a subscription.
- A subscription is cancelled before the end date.
Example:

A customer purchases a monthly subscription worth ₹3,000.

The subscription starts on January 16 instead of January 1.

If the month has 30 days and the customer uses the service for 15 days:
\[\text{Prorated Amount} = \frac{3000}{30}\times15\]

\[= ₹1,500\]

The customer is charged ₹1,500 for that partial period, assuming a daily proration method and no additional adjustments.