public with sharing class PortfolioController {

    /**
     * Fetch all active portfolio templates.
     * Called from LWC using @wire or imperative Apex.
     */
    @AuraEnabled(cacheable=true)
    public static List<Portfolio_Template__c> getActiveTemplates() {

        try {
            return [
                SELECT Id,
                       Name,
                       Template_Code__c,
                       Template_Description__c,
                       Preview_Image_URL__c,
                       Display_Order__c
                FROM Portfolio_Template__c
                WHERE Is_Active__c = true
                WITH USER_MODE
                ORDER BY Display_Order__c ASC
            ];

        } catch (Exception ex) {
            throw new AuraHandledException(
                'Unable to fetch portfolio templates. Please contact support.'
            );
        }
    }
}