@IsTest
private class PortfolioControllerTest {

    @TestSetup
    static void setupTestData() {

        List<Portfolio_Template__c> templates =
            new List<Portfolio_Template__c>{

                new Portfolio_Template__c(
                    Name = 'Professional',
                    Template_Code__c = 'PROFESSIONAL',
                    Template_Description__c = 'Corporate portfolio',
                    Is_Active__c = true,
                    Display_Order__c = 1
                ),

                new Portfolio_Template__c(
                    Name = 'Developer',
                    Template_Code__c = 'DEVELOPER',
                    Template_Description__c = 'Developer portfolio',
                    Is_Active__c = true,
                    Display_Order__c = 2
                ),

                new Portfolio_Template__c(
                    Name = 'Creative',
                    Template_Code__c = 'CREATIVE',
                    Is_Active__c = true,
                    Display_Order__c = 3
                ),

                new Portfolio_Template__c(
                    Name = 'Inactive Template',
                    Template_Code__c = 'INACTIVE',
                    Is_Active__c = false,
                    Display_Order__c = 4
                )
            };

        insert templates;
    }

    @IsTest
    static void testGetActiveTemplates() {

        Test.startTest();

        List<Portfolio_Template__c> results =
            PortfolioController.getActiveTemplates();

        Test.stopTest();

        System.assertEquals(
            3,
            results.size(),
            'Only active templates should be returned.'
        );

        System.assertEquals(
            'PROFESSIONAL',
            results[0].Template_Code__c,
            'Templates should be ordered by display order.'
        );

        System.assertEquals(
            'DEVELOPER',
            results[1].Template_Code__c
        );

        System.assertEquals(
            'CREATIVE',
            results[2].Template_Code__c
        );
    }
}