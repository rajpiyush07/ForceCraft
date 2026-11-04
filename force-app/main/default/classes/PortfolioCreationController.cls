public with sharing class PortfolioCreationController {

    @AuraEnabled
    public static Id createPortfolio(
        String fullName,
        String professionalTitle,
        String email,
        String phone,
        String aboutMe,
        String profileImageUrl,
        String linkedinUrl,
        String githubUrl,
        String portfolioName,
        String selectedTemplate
    ) {
        try {
            Portfolio__c portfolio = new Portfolio__c();

            portfolio.Name = String.isBlank(portfolioName)
                ? fullName
                : portfolioName;

            portfolio.Full_Name__c = fullName;
            portfolio.Job_Title__c = professionalTitle;
            portfolio.Email__c = email;
            portfolio.Phone__c = phone;
            portfolio.About_Me__c = aboutMe;
            portfolio.Profile_Image_URL__c = profileImageUrl;
            portfolio.LinkedIn_URL__c = linkedinUrl;
            portfolio.GitHub_URL__c = githubUrl;
            portfolio.Selected_Template__c = selectedTemplate;
            portfolio.User__c = UserInfo.getUserId();
            portfolio.Is_Published__c = false;

            // Enforce field-level security
            SObjectAccessDecision decision =
                Security.stripInaccessible(
                    AccessType.CREATABLE,
                    new List<Portfolio__c>{ portfolio }
                );

            List<Portfolio__c> safeRecords =
                (List<Portfolio__c>) decision.getRecords();

            if (safeRecords.isEmpty()) {
                throw new AuraHandledException(
                    'You do not have permission to create a portfolio.'
                );
            }

            insert safeRecords;

            return safeRecords[0].Id;

        } catch (Exception e) {
            throw new AuraHandledException(
                'Unable to create portfolio: ' + e.getMessage()
            );
        }
    }
}