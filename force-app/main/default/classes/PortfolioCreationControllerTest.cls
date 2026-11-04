@IsTest
private class PortfolioCreationControllerTest {

    @IsTest
    static void testCreatePortfolio() {

        // Get an active template picklist value
        List<Schema.PicklistEntry> templates =
            Portfolio__c.Selected_Template__c
                .getDescribe()
                .getPicklistValues();

        String templateValue;

        for (Schema.PicklistEntry entry : templates) {
            if (entry.isActive()) {
                templateValue = entry.getValue();
                break;
            }
        }

        System.assertNotEquals(
            null,
            templateValue,
            'An active portfolio template must exist.'
        );

        Test.startTest();

        Id portfolioId =
            PortfolioCreationController.createPortfolio(
                'Test Developer',
                'Salesforce Developer',
                'test@example.com',
                '9876543210',
                'Experienced Salesforce Developer',
                'https://example.com/profile.jpg',
                'https://linkedin.com/in/test',
                'https://github.com/test',
                'Test Portfolio',
                templateValue
            );

        Test.stopTest();

        // Verify inserted record
        Portfolio__c result = [
            SELECT Id, Name, Full_Name__c, Job_Title__c,
                   Email__c, Phone__c, About_Me__c,
                   Selected_Template__c, User__c,
                   Is_Published__c
            FROM Portfolio__c
            WHERE Id = :portfolioId
        ];

        System.assertEquals('Test Portfolio', result.Name);
        System.assertEquals('Test Developer', result.Full_Name__c);
        System.assertEquals('Salesforce Developer', result.Job_Title__c);
        System.assertEquals('test@example.com', result.Email__c);
        System.assertEquals(UserInfo.getUserId(), result.User__c);
        System.assertEquals(false, result.Is_Published__c);
    }
}