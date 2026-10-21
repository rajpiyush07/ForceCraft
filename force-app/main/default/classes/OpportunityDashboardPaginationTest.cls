
@IsTest
private class OpportunityDashboardPaginationTest {

    @TestSetup
    static void setupData() {
        List<Opportunity> records = new List<Opportunity>();

        for (Integer i = 1; i <= 25; i++) {
            records.add(new Opportunity(
                Name = 'Pagination Test ' + i,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(i),
                Amount = i * 100
            ));
        }

        insert records;
    }

    @IsTest
    static void returnsRequestedPage() {
        Test.startTest();
        OpportunityDashboardController.OpportunityPage result =
            OpportunityDashboardController.getOpportunitiesPage(
                '',
                'All',
                'Name',
                'ASC',
                2,
                10,
                null,
                null,
                null,
                null
            );
        Test.stopTest();

        System.assertEquals(25, result.totalRecords);
        System.assertEquals(2, result.currentPage);
        System.assertEquals(10, result.pageSize);
        System.assertEquals(3, result.totalPages);
        System.assertEquals(10, result.records.size());
        System.assertEquals(
            'Pagination Test 19',
            result.records[0].Name
        );
    }

    @IsTest
    static void filtersByNameAndStage() {
        Test.startTest();
        OpportunityDashboardController.OpportunityPage result =
            OpportunityDashboardController.getOpportunitiesPage(
                'Pagination Test 1',
                'Prospecting',
                'Amount',
                'DESC',
                1,
                10,
                null,
                null,
                null,
                null
            );
        Test.stopTest();

        System.assertEquals(11, result.totalRecords);
        System.assertEquals(10, result.records.size());

        for (Opportunity record : result.records) {
            System.assert(
                record.Name.contains('Pagination Test 1')
            );
            System.assertEquals('Prospecting', record.StageName);
        }
    }

    @IsTest
    static void rejectsUnsupportedSortField() {
        Boolean exceptionThrown = false;

        Test.startTest();
        try {
            OpportunityDashboardController.getOpportunitiesPage(
                '',
                'All',
                'Name DESC LIMIT 1',
                'ASC',
                1,
                10,
                null,
                null,
                null,
                null
            );
        } catch (AuraHandledException ex) {
            exceptionThrown = true;
        }
        Test.stopTest();

        System.assert(
            exceptionThrown,
            'Unsupported sort fields must be rejected.'
        );
    }

    @IsTest
    static void rejectsInvalidPageSize() {
        Boolean exceptionThrown = false;

        Test.startTest();
        try {
            OpportunityDashboardController.getOpportunitiesPage(
                '',
                'All',
                'Name',
                'ASC',
                1,
                500,
                null,
                null,
                null,
                null
            );
        } catch (AuraHandledException ex) {
            exceptionThrown = true;
        }
        Test.stopTest();

        System.assert(
            exceptionThrown,
            'Page sizes greater than 100 must be rejected.'
        );
    }

    
    @IsTest
    static void filtersByAmountRange() {
        Test.startTest();
        OpportunityDashboardController.OpportunityPage result =
            OpportunityDashboardController.getOpportunitiesPage(
                '',
                'All',
                'Amount',
                'ASC',
                1,
                100,
                1000,
                2000,
                null,
                null
            );
        Test.stopTest();

        System.assertEquals(11, result.totalRecords);
        System.assertEquals(11, result.records.size());

        for (Opportunity record : result.records) {
            System.assert(
                record.Amount >= 1000 && record.Amount <= 2000,
                'Amount must be within the requested range.'
            );
        }
    }

    @IsTest
    static void filtersByCloseDateRange() {
        Date startDate = Date.today().addDays(5);
        Date endDate = Date.today().addDays(10);

        Test.startTest();
        OpportunityDashboardController.OpportunityPage result =
            OpportunityDashboardController.getOpportunitiesPage(
                '',
                'All',
                'CloseDate',
                'ASC',
                1,
                100,
                null,
                null,
                startDate,
                endDate
            );
        Test.stopTest();

        System.assertEquals(6, result.totalRecords);
        System.assertEquals(6, result.records.size());

        for (Opportunity record : result.records) {
            System.assert(
                record.CloseDate >= startDate &&
                record.CloseDate <= endDate,
                'Close date must be within the requested range.'
            );
        }
    }

    @IsTest
    static void rejectsInvalidAmountRange() {
        Boolean exceptionThrown = false;

        Test.startTest();
        try {
            OpportunityDashboardController.getOpportunitiesPage(
                '',
                'All',
                'Name',
                'ASC',
                1,
                10,
                2000,
                1000,
                null,
                null
            );
        } catch (AuraHandledException ex) {
            exceptionThrown = true;
        }
        Test.stopTest();

        System.assert(
            exceptionThrown,
            'Minimum amount greater than maximum amount must be rejected.'
        );
    }

    @IsTest
    static void rejectsInvalidCloseDateRange() {
        Boolean exceptionThrown = false;

        Test.startTest();
        try {
            OpportunityDashboardController.getOpportunitiesPage(
                '',
                'All',
                'Name',
                'ASC',
                1,
                10,
                null,
                null,
                Date.today().addDays(10),
                Date.today().addDays(5)
            );
        } catch (AuraHandledException ex) {
            exceptionThrown = true;
        }
        Test.stopTest();

        System.assert(
            exceptionThrown,
            'Start close date after end close date must be rejected.'
        );
    }

}
