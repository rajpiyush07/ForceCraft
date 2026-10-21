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
    // SERVER-SIDE PAGINATION, FILTERING AND SORTING
    // --------------------------------------------------

    public class OpportunityPage {
        @AuraEnabled public List<Opportunity> records { get; set; }
        @AuraEnabled public Integer totalRecords { get; set; }
        @AuraEnabled public Integer currentPage { get; set; }
        @AuraEnabled public Integer pageSize { get; set; }
        @AuraEnabled public Integer totalPages { get; set; }
    }

    @AuraEnabled(cacheable=true)
        public static OpportunityPage getOpportunitiesPage(
            String searchKey,
            String stageName,
            String sortBy,
            String sortDirection,
            Integer pageNumber,
            Integer pageSize,
            Decimal minAmount,
            Decimal maxAmount,
            Date closeDateFrom,
            Date closeDateTo
        ) {
        requireReadableFields();

        // Validate pagination parameters.
        Integer safePage = pageNumber == null ? 1 : pageNumber;
        Integer safePageSize = pageSize == null ? 10 : pageSize;

        if (safePage < 1) {
            throw new AuraHandledException(
                'Page number must be greater than zero.'
            );
        }

        if (safePageSize < 1 || safePageSize > 100) {
            throw new AuraHandledException(
                'Page size must be between 1 and 100.'
            );
        }

                // Validate amount filters.
        if (minAmount != null && minAmount < 0) {
            throw new AuraHandledException(
                'Minimum amount cannot be negative.'
            );
        }

        if (maxAmount != null && maxAmount < 0) {
            throw new AuraHandledException(
                'Maximum amount cannot be negative.'
            );
        }

        if (
            minAmount != null &&
            maxAmount != null &&
            minAmount > maxAmount
        ) {
            throw new AuraHandledException(
                'Minimum amount cannot exceed maximum amount.'
            );
        }

        // Validate close date filters.
        if (
            closeDateFrom != null &&
            closeDateTo != null &&
            closeDateFrom > closeDateTo
        ) {
            throw new AuraHandledException(
                'Start close date cannot be after end close date.'
            );
        }

        Integer rowOffset = (safePage - 1) * safePageSize;

        // SOQL OFFSET supports a maximum of 2,000 skipped rows.
        if (rowOffset > 2000) {
            throw new AuraHandledException(
                'This page is beyond the supported pagination range. ' +
                'Use a smaller page number or page size.'
            );
        }

        String selectedStage = String.isBlank(stageName)
            ? 'All'
            : stageName.trim();

        if (
            selectedStage != 'All' &&
            !isValidActiveStage(selectedStage)
        ) {
            throw new AuraHandledException(
                'The selected opportunity stage is invalid.'
            );
        }

        // Only allow known fields in ORDER BY.
        Map<String, String> sortableFields = new Map<String, String>{
            'Name' => 'Name',
            'Amount' => 'Amount',
            'CloseDate' => 'CloseDate',
            'StageName' => 'StageName',
            'LastModifiedDate' => 'LastModifiedDate'
        };

        String requestedSort = String.isBlank(sortBy)
            ? 'LastModifiedDate'
            : sortBy.trim();

        if (!sortableFields.containsKey(requestedSort)) {
            throw new AuraHandledException(
                'The selected sort field is not supported.'
            );
        }

        String direction = String.isBlank(sortDirection)
            ? 'DESC'
            : sortDirection.trim().toUpperCase();

        if (direction != 'ASC' && direction != 'DESC') {
            throw new AuraHandledException(
                'Sort direction must be ASC or DESC.'
            );
        }

        String trimmedSearch = String.isBlank(searchKey)
            ? ''
            : searchKey.trim();

        Map<String, Object> binds = new Map<String, Object>();
        List<String> conditions = new List<String>();

        if (!String.isBlank(trimmedSearch)) {
            conditions.add('Name LIKE :searchPattern');
            binds.put('searchPattern', '%' + trimmedSearch + '%');
        }

        if (selectedStage != 'All') {
            conditions.add('StageName = :selectedStage');
            binds.put('selectedStage', selectedStage);
        }

                // Minimum opportunity amount.
        if (minAmount != null) {
            conditions.add('Amount >= :minAmount');
            binds.put('minAmount', minAmount);
        }

        // Maximum opportunity amount.
        if (maxAmount != null) {
            conditions.add('Amount <= :maxAmount');
            binds.put('maxAmount', maxAmount);
        }

        // Close date start.
        if (closeDateFrom != null) {
            conditions.add('CloseDate >= :closeDateFrom');
            binds.put('closeDateFrom', closeDateFrom);
        }

        // Close date end.
        if (closeDateTo != null) {
            conditions.add('CloseDate <= :closeDateTo');
            binds.put('closeDateTo', closeDateTo);
        }

        String whereClause = conditions.isEmpty()
            ? ''
            : ' WHERE ' + String.join(conditions, ' AND ');

        // Count only records matching the current filters.
        String countQuery =
            'SELECT COUNT() FROM Opportunity' + whereClause;

        Integer matchingRecords = (Integer) Database.countQueryWithBinds(
            countQuery,
            binds,
            AccessLevel.USER_MODE
        );

        Integer calculatedPages = matchingRecords == 0
        ? 0
        : (matchingRecords + safePageSize - 1) / safePageSize;

        // If filters change and the requested page no longer exists,
        // return the last available page (or page 1 when no rows match).
        if (calculatedPages == 0) {
            safePage = 1;
            rowOffset = 0;
        } else if (safePage > calculatedPages) {
            safePage = calculatedPages;
            rowOffset = (safePage - 1) * safePageSize;
        }

        String sortField = sortableFields.get(requestedSort);

        String recordsQuery =
        'SELECT Id, Name, Account.Name, Amount, StageName, ' +
        'CloseDate, Probability, LastModifiedDate ' +
        'FROM Opportunity' +
        whereClause +
        ' ORDER BY ' + sortField + ' ' + direction + ', Id ASC' +
        ' LIMIT :limitSize OFFSET :rowOffset';

        binds.put('limitSize', safePageSize);
        binds.put('rowOffset', rowOffset);

        List<Opportunity> pageRecords = (List<Opportunity>)
            Database.queryWithBinds(
                recordsQuery,
                binds,
                AccessLevel.USER_MODE
            );

        OpportunityPage response = new OpportunityPage();
        response.records = pageRecords;
        response.totalRecords = matchingRecords;
        response.currentPage = safePage;
        response.pageSize = safePageSize;
        response.totalPages = calculatedPages;

        return response;
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
