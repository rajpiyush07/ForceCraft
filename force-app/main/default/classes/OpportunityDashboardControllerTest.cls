
@IsTest
private class OpportunityDashboardControllerTest {

    // --------------------------------------------------
    // TEST DATA
    // --------------------------------------------------

    @TestSetup
    static void setupTestData() {
        List<Opportunity> opportunities = new List<Opportunity>{
            new Opportunity(
                Name = 'Dashboard Alpha',
                Amount = 1000,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30)
            ),
            new Opportunity(
                Name = 'Dashboard Beta',
                Amount = 2000,
                StageName = 'Qualification',
                CloseDate = Date.today().addDays(45)
            ),
            new Opportunity(
                Name = 'Dashboard Gamma Won',
                Amount = 5000,
                StageName = 'Closed Won',
                CloseDate = Date.today()
            )
        };

        insert opportunities;
    }

    // --------------------------------------------------
    // TEST OPPORTUNITY CREATION AND SEARCH
    // --------------------------------------------------

    @IsTest
    static void createsAndFindsOpportunity() {
        Date closeDate = Date.today().addDays(30);

        Test.startTest();

        Id createdId =
            OpportunityDashboardController.createOpportunity(
                'LWC Dashboard Test',
                25000,
                closeDate,
                'Prospecting'
            );

        List<Opportunity> results =
            OpportunityDashboardController.getOpportunities(
                'LWC Dashboard Test',
                'All'
            );

        Test.stopTest();

        System.assertNotEquals(
            null,
            createdId,
            'The opportunity should be created.'
        );

        System.assertEquals(
            1,
            results.size(),
            'The search should return the created opportunity.'
        );

        System.assertEquals(
            25000,
            results[0].Amount,
            'The opportunity amount should match.'
        );

        System.assertEquals(
            closeDate,
            results[0].CloseDate,
            'The close date should match.'
        );
    }

    // --------------------------------------------------
    // TEST BLANK NAME VALIDATION
    // --------------------------------------------------

    @IsTest
    static void rejectsBlankName() {
        Boolean exceptionThrown = false;

        Test.startTest();

        try {
            OpportunityDashboardController.createOpportunity(
                '',
                100,
                Date.today().addDays(7),
                'Prospecting'
            );
        } catch (AuraHandledException ex) {
            exceptionThrown = true;
        }

        Test.stopTest();

        System.assert(
            exceptionThrown,
            'A blank opportunity name should be rejected.'
        );
    }

    // --------------------------------------------------
    // TEST INVALID STAGE VALIDATION
    // --------------------------------------------------

    @IsTest
    static void rejectsInvalidStage() {
        Boolean exceptionThrown = false;

        Test.startTest();

        try {
            OpportunityDashboardController.createOpportunity(
                'Invalid Stage Test',
                1000,
                Date.today().addDays(10),
                'Not A Valid Stage'
            );
        } catch (AuraHandledException ex) {
            exceptionThrown = true;
        }

        Test.stopTest();

        System.assert(
            exceptionThrown,
            'An invalid opportunity stage should be rejected.'
        );
    }

    // --------------------------------------------------
    // TEST CLOSE DATE VALIDATION
    // --------------------------------------------------

    @IsTest
    static void rejectsPastCloseDate() {
        Boolean exceptionThrown = false;

        Test.startTest();

        try {
            OpportunityDashboardController.createOpportunity(
                'Past Close Date Test',
                1000,
                Date.today().addDays(-1),
                'Prospecting'
            );
        } catch (AuraHandledException ex) {
            exceptionThrown = true;
        }

        Test.stopTest();

        System.assert(
            exceptionThrown,
            'A close date in the past should be rejected.'
        );
    }

    // --------------------------------------------------
    // TEST SEARCH AND STAGE FILTERING
    // --------------------------------------------------

    @IsTest
    static void filtersOpportunitiesByNameAndStage() {
        Test.startTest();

        List<Opportunity> searchResults =
            OpportunityDashboardController.getOpportunities(
                'Dashboard Alpha',
                'All'
            );

        List<Opportunity> stageResults =
            OpportunityDashboardController.getOpportunities(
                '',
                'Qualification'
            );

        Test.stopTest();

        System.assertEquals(
            1,
            searchResults.size(),
            'Name search should return the matching opportunity.'
        );

        System.assertEquals(
            'Dashboard Alpha',
            searchResults[0].Name
        );

        System.assertEquals(
            1,
            stageResults.size(),
            'Stage filtering should return the matching opportunity.'
        );

        System.assertEquals(
            'Qualification',
            stageResults[0].StageName
        );
    }
    
    // --------------------------------------------------
    // TEST DASHBOARD METRICS
    // --------------------------------------------------

    @IsTest
    static void calculatesOpportunityMetrics() {
        Test.startTest();

        Map<String, Decimal> metrics =
            OpportunityDashboardController.getOpportunityMetrics();

        Test.stopTest();

        System.assertEquals(
            Decimal.valueOf('3'),
            metrics.get('totalOpportunities'),
            'The total should include all three test opportunities.'
        );

        System.assertEquals(
            Decimal.valueOf('3000'),
            metrics.get('totalPipelineAmount'),
            'Pipeline amount should include open opportunities only.'
        );

        System.assertEquals(
            Decimal.valueOf('5000'),
            metrics.get('closedWonRevenue'),
            'Closed Won revenue should be calculated separately.'
        );

        System.assertEquals(
            Decimal.valueOf('2'),
            metrics.get('openOpportunities'),
            'There should be two open opportunities.'
        );
    }

    // --------------------------------------------------
    // TEST STAGE ANALYTICS
    // --------------------------------------------------

    @IsTest
    static void calculatesStageAnalytics() {
        Test.startTest();

        List<OpportunityDashboardController.StageAnalytics> analytics =
            OpportunityDashboardController.getOpportunityStageAnalytics();

        Test.stopTest();

        System.assertEquals(
            3,
            analytics.size(),
            'Analytics should contain the three stages represented in test data.'
        );

        Map<String, OpportunityDashboardController.StageAnalytics>
            analyticsByStage =
            new Map<String, OpportunityDashboardController.StageAnalytics>();

        for (
            OpportunityDashboardController.StageAnalytics item :
            analytics
        ) {
            analyticsByStage.put(item.stageName, item);
        }

        System.assert(
            analyticsByStage.containsKey('Prospecting'),
            'Prospecting analytics should exist.'
        );

        System.assertEquals(
            1,
            analyticsByStage.get('Prospecting').opportunityCount
        );

        System.assertEquals(
            Decimal.valueOf('1000'),
            analyticsByStage.get('Prospecting').totalAmount
        );

        System.assertEquals(
            1,
            analyticsByStage.get('Qualification').opportunityCount
        );

        System.assertEquals(
            Decimal.valueOf('2000'),
            analyticsByStage.get('Qualification').totalAmount
        );

        System.assertEquals(
            Decimal.valueOf('5000'),
            analyticsByStage.get('Closed Won').totalAmount
        );
    }
}
