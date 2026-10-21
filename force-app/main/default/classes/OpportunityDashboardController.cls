public with sharing class OpportunityDashboardController {

    // --------------------------------------------------
    // SECURITY HELPERS
    // --------------------------------------------------

    private static void requireOpportunityReadAccess() {
        if (!Opportunity.SObjectType.getDescribe().isAccessible()) {
            throw new AuraHandledException(
                'You do not have permission to view opportunities.'
            );
        }
    }

    private static void requireReadableFields() {
        requireOpportunityReadAccess();

        Map<String, Schema.SObjectField> opportunityFields =
            Schema.SObjectType.Opportunity.fields.getMap();

        Map<String, Schema.SObjectField> accountFields =
            Schema.SObjectType.Account.fields.getMap();

        if (
            !opportunityFields.get('Name').getDescribe().isAccessible() ||
            !opportunityFields.get('Amount').getDescribe().isAccessible() ||
            !opportunityFields.get('StageName').getDescribe().isAccessible() ||
            !opportunityFields.get('CloseDate').getDescribe().isAccessible() ||
            !opportunityFields.get('Probability').getDescribe().isAccessible() ||
            !opportunityFields.get('IsClosed').getDescribe().isAccessible() ||
            !opportunityFields.get('IsWon').getDescribe().isAccessible() ||
            !Account.SObjectType.getDescribe().isAccessible() ||
            !accountFields.get('Name').getDescribe().isAccessible()
        ) {
            throw new AuraHandledException(
                'You do not have permission to view all dashboard fields.'
            );
        }
    }

    private static void requireCreatableFields() {
        if (!Opportunity.SObjectType.getDescribe().isCreateable()) {
            throw new AuraHandledException(
                'You do not have permission to create opportunities.'
            );
        }

        Map<String, Schema.SObjectField> fields =
            Schema.SObjectType.Opportunity.fields.getMap();

        if (
            !fields.get('Name').getDescribe().isCreateable() ||
            !fields.get('Amount').getDescribe().isCreateable() ||
            !fields.get('CloseDate').getDescribe().isCreateable() ||
            !fields.get('StageName').getDescribe().isCreateable()
        ) {
            throw new AuraHandledException(
                'You do not have permission to set all required opportunity fields.'
            );
        }
    }

    private static Boolean isValidActiveStage(String requestedStage) {
        if (String.isBlank(requestedStage)) {
            return false;
        }

        Map<String, Schema.SObjectField> fields =
            Schema.SObjectType.Opportunity.fields.getMap();

        Schema.DescribeFieldResult stageDescribe =
            fields.get('StageName').getDescribe();

        for (Schema.PicklistEntry entry : stageDescribe.getPicklistValues()) {
            if (
                entry.isActive() &&
                entry.getValue() == requestedStage
            ) {
                return true;
            }
        }

        return false;
    }

    // --------------------------------------------------
    // GET OPPORTUNITIES
    // --------------------------------------------------

    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunities(
        String searchKey,
        String stageName
    ) {
        requireReadableFields();

        String searchPattern = '%' +
            (String.isBlank(searchKey) ? '' : searchKey.trim()) + '%';

        String selectedStage = String.isBlank(stageName)
            ? 'All'
            : stageName;

        if (
            selectedStage != 'All' &&
            !isValidActiveStage(selectedStage)
        ) {
            throw new AuraHandledException(
                'The selected opportunity stage is invalid.'
            );
        }

        if (selectedStage == 'All') {
            return [
                SELECT Id, Name, Account.Name, Amount, StageName,
                       CloseDate, Probability
                FROM Opportunity
                WHERE Name LIKE :searchPattern
                WITH USER_MODE
                ORDER BY LastModifiedDate DESC
                LIMIT 100
            ];
        }

        return [
            SELECT Id, Name, Account.Name, Amount, StageName,
                   CloseDate, Probability
            FROM Opportunity
            WHERE Name LIKE :searchPattern
              AND StageName = :selectedStage
            WITH USER_MODE
            ORDER BY LastModifiedDate DESC
            LIMIT 100
        ];
    }

    // --------------------------------------------------
    // CREATE OPPORTUNITY
    // --------------------------------------------------

    @AuraEnabled
    public static Id createOpportunity(
        String name,
        Decimal amount,
        Date closeDate,
        String stageName
    ) {
        if (String.isBlank(name)) {
            throw new AuraHandledException(
                'Opportunity name is required.'
            );
        }

        if (closeDate == null) {
            throw new AuraHandledException(
                'Close date is required.'
            );
        }

        if (closeDate < Date.today()) {
            throw new AuraHandledException(
                'Close date cannot be in the past.'
            );
        }

        if (!isValidActiveStage(stageName)) {
            throw new AuraHandledException(
                'Select a valid active opportunity stage.'
            );
        }

        requireCreatableFields();

        Opportunity opp = new Opportunity(
            Name = name.trim(),
            Amount = amount,
            CloseDate = closeDate,
            StageName = stageName
        );

        try {
            insert as user opp;
            return opp.Id;
        } catch (DmlException ex) {
            throw new AuraHandledException(
                'Unable to create the opportunity. Check your field values and permissions.'
            );
        } catch (Exception ex) {
            throw new AuraHandledException(
                'Unable to create the opportunity. Check your permissions and try again.'
            );
        }
    }

    // --------------------------------------------------
    // DASHBOARD KPI METRICS
    // --------------------------------------------------

    @AuraEnabled(cacheable=true)
    public static Map<String, Decimal> getOpportunityMetrics() {
        requireReadableFields();

        AggregateResult allSummary = [
            SELECT COUNT(Id) totalCount
            FROM Opportunity
            WITH USER_MODE
        ];

        AggregateResult pipelineSummary = [
            SELECT SUM(Amount) pipelineAmount
            FROM Opportunity
            WHERE IsClosed = false
            WITH USER_MODE
        ];

        AggregateResult wonSummary = [
            SELECT SUM(Amount) closedWonRevenue
            FROM Opportunity
            WHERE IsWon = true
            WITH USER_MODE
        ];

        AggregateResult openSummary = [
            SELECT COUNT(Id) openCount
            FROM Opportunity
            WHERE IsClosed = false
            WITH USER_MODE
        ];

        Map<String, Decimal> metrics = new Map<String, Decimal>();

        metrics.put(
            'totalOpportunities',
            Decimal.valueOf(
                String.valueOf(allSummary.get('totalCount'))
            )
        );

        metrics.put(
            'totalPipelineAmount',
            pipelineSummary.get('pipelineAmount') == null
                ? 0
                : (Decimal) pipelineSummary.get('pipelineAmount')
        );

        metrics.put(
            'closedWonRevenue',
            wonSummary.get('closedWonRevenue') == null
                ? 0
                : (Decimal) wonSummary.get('closedWonRevenue')
        );

        metrics.put(
            'openOpportunities',
            Decimal.valueOf(
                String.valueOf(openSummary.get('openCount'))
            )
        );

        return metrics;
    }

    // --------------------------------------------------
    // OPPORTUNITY STAGE ANALYTICS
    // --------------------------------------------------

    @AuraEnabled(cacheable=true)
    public static List<StageAnalytics> getOpportunityStageAnalytics() {
        requireReadableFields();

        List<AggregateResult> results = [
            SELECT StageName stageName,
                   COUNT(Id) opportunityCount,
                   SUM(Amount) totalAmount
            FROM Opportunity
            WITH USER_MODE
            GROUP BY StageName
            ORDER BY StageName
        ];

        List<StageAnalytics> analytics = new List<StageAnalytics>();

        for (AggregateResult result : results) {
            StageAnalytics item = new StageAnalytics();

            item.stageName = (String) result.get('stageName');

            item.opportunityCount =
                (Integer) result.get('opportunityCount');

            item.totalAmount = result.get('totalAmount') == null
                ? 0
                : (Decimal) result.get('totalAmount');

            analytics.add(item);
        }

        return analytics;
    }

    // --------------------------------------------------
    // LWC RESPONSE WRAPPER
    // --------------------------------------------------

    public class StageAnalytics {
        @AuraEnabled
        public String stageName { get; set; }

        @AuraEnabled
        public Integer opportunityCount { get; set; }

        @AuraEnabled
        public Decimal totalAmount { get; set; }
    }
}
