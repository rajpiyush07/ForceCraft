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

