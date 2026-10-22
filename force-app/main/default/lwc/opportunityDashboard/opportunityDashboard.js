import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { NavigationMixin } from 'lightning/navigation';

import getOpportunitiesPage from '@salesforce/apex/OpportunityDashboardController.getOpportunitiesPage';
import createOpportunity from '@salesforce/apex/OpportunityDashboardController.createOpportunity';
import getOpportunityMetrics from '@salesforce/apex/OpportunityDashboardController.getOpportunityMetrics';
import getOpportunityStageAnalytics from '@salesforce/apex/OpportunityDashboardController.getOpportunityStageAnalytics';


const STAGES = [
    { label: 'Prospecting', value: 'Prospecting' },
    { label: 'Qualification', value: 'Qualification' },
    { label: 'Needs Analysis', value: 'Needs Analysis' },
    { label: 'Value Proposition', value: 'Value Proposition' },
    { label: 'Id. Decision Makers', value: 'Id. Decision Makers' },
    { label: 'Perception Analysis', value: 'Perception Analysis' },
    { label: 'Proposal', value: 'Proposal' },
    { label: 'Negotiation', value: 'Negotiation' },
    { label: 'Closed Won', value: 'Closed Won' },
    { label: 'Closed Lost', value: 'Closed Lost' }
];

const DONUT_COLORS = [
    '#2563eb',
    '#7c3aed',
    '#0d9488',
    '#ea580c',
    '#db2777',
    '#0891b2',
    '#65a30d',
    '#9333ea',
    '#ca8a04',
    '#64748b'
];

export default class OpportunityDashboard extends NavigationMixin(LightningElement) {
 
   
    searchKey = '';
    stageName = 'All';
    opportunities = [];

    // Phase 2.3: Advanced filter values
    minAmount = '';
    maxAmount = '';
    closeDateFrom = '';
    closeDateTo = '';

    // Applied filters, kept separate until Apply Filters is clicked
    appliedMinAmount = null;
    appliedMaxAmount = null;
    appliedCloseDateFrom = null;
    appliedCloseDateTo = null;

    _wiredMetricsResult;
    _wiredStageAnalyticsResult;

    isLoading = true;
    isSaving = false;
    isCreateFormOpen = false;
    isAnalyticsLoading = true;

    sortBy = 'LastModifiedDate';
    sortDirection = 'desc';
    pageSize = 10;
    currentPage = 1;
    

    totalRecords = 0;
    serverTotalPages = 0;
    requestSequence = 0;


    get pageSizeValue() {
        return String(this.pageSize);
    }

    pageSizeOptions = [
        { label: '10', value: '10' },
        { label: '25', value: '25' },
        { label: '50', value: '50' },
        { label: '100', value: '100' }
    ];

    metrics = {
        totalOpportunities: 0,
        totalPipelineAmount: 0,
        closedWonRevenue: 0,
        openOpportunities: 0
    };

    metricsError;
    analyticsError;
    stageAnalytics = [];

    newName = '';
    newAmount = null;
    newStage = 'Prospecting';
    newCloseDate = this.getTodayDate();

    getTodayDate() {
        const now = new Date();

        return new Date(now.getTime() - now.getTimezoneOffset() * 60000)
            .toISOString()
            .slice(0, 10);
    }

    // Load KPI metrics.
    @wire(getOpportunityMetrics)
    wiredMetrics(result) {
        this._wiredMetricsResult = result;

        const { data, error } = result;

        if (data) {
            this.metrics = data;
            this.metricsError = undefined;
        } else if (error) {
            this.metricsError = error;
            this.showToast(
                'Error loading metrics',
                this.getErrorMessage(error),
                'error'
            );
        }
    }

    // Load opportunity stage analytics.
    @wire(getOpportunityStageAnalytics)
    wiredStageAnalytics(result) {
        this._wiredStageAnalyticsResult = result;

        const { data, error } = result;

        if (data) {
            this.stageAnalytics = data;
            this.analyticsError = undefined;
            this.isAnalyticsLoading = false;
        } else if (error) {
            this.stageAnalytics = [];
            this.analyticsError = error;
            this.isAnalyticsLoading = false;

            this.showToast(
                'Error loading analytics',
                this.getErrorMessage(error),
                'error'
            );
        }
    }

    // Load a page of opportunities from Salesforce.
    connectedCallback() {
        this.loadOpportunities();
    }

    async loadOpportunities() {
        const requestId = ++this.requestSequence;
        this.isLoading = true;

        try {
            const result = await getOpportunitiesPage({
                searchKey: this.searchKey,
                stageName: this.stageName,
                sortBy: this.sortBy,
                sortDirection: this.sortDirection,
                pageNumber: this.currentPage,
                pageSize: this.pageSize,
                minAmount: this.appliedMinAmount,
                maxAmount: this.appliedMaxAmount,
                closeDateFrom: this.appliedCloseDateFrom,
                closeDateTo: this.appliedCloseDateTo
            });

            // Ignore stale responses from earlier requests.
            if (requestId !== this.requestSequence) {
                return;
            }

            this.opportunities = (result.records || []).map((opp) => ({
                ...opp,
                accountName: opp.Account ? opp.Account.Name : 'No Account',
                isExpanded: false,
                detailsButtonLabel: 'More Details'
            }));

            this.totalRecords = result.totalRecords || 0;
            this.currentPage = result.currentPage || 1;
            this.serverTotalPages = result.totalPages || 0;
        } catch (error) {
            if (requestId !== this.requestSequence) {
                return;
            }

            this.opportunities = [];
            this.totalRecords = 0;
            this.serverTotalPages = 0;
            this.currentPage = 1;

            this.showToast(
                'Error loading opportunities',
                this.getErrorMessage(error),
                'error'
            );
        } finally {
            if (requestId === this.requestSequence) {
                this.isLoading = false;
            }
        }
    }

    // Filter and sort options.
    get stageOptions() {
        return [
            { label: 'All Stages', value: 'All' },
            ...STAGES
        ];
    }

    get createStageOptions() {
        return STAGES;
    }

    get sortOptions() {
        return [
            { label: 'Last Modified', value: 'LastModifiedDate' },
            { label: 'Opportunity Name', value: 'Name' },
            { label: 'Amount', value: 'Amount' },
            { label: 'Close Date', value: 'CloseDate' },
            { label: 'Stage', value: 'StageName' }
        ];
    }

    get sortDirectionLabel() {
        return this.sortDirection === 'asc' ? 'Ascending' : 'Descending';
    }

    // Opportunity list getters.
    get hasRecords() {
        return this.opportunities.length > 0;
    }

    get displayedOpportunities() {
        return this.opportunities;
    }

    get totalPages() {
        return Math.max(1, this.serverTotalPages);
    }

    get isFirstPage() {
        return this.currentPage <= 1;
    }

    get isLastPage() {
        return (
            this.serverTotalPages === 0 ||
            this.currentPage >= this.serverTotalPages
        );
    }

    get recordCountLabel() {
        return `${this.totalRecords} matching opportunities`;
    }

    get paginationLabel() {
        if (this.totalRecords === 0) {
            return 'No opportunities';
        }

        const start = (this.currentPage - 1) * this.pageSize + 1;
        const end = Math.min(
            start + this.opportunities.length - 1,
            this.totalRecords
        );

        return `Showing ${start}-${end} of ${this.totalRecords} opportunities`;
    }

    // Stage analytics getters.
    get hasStageAnalytics() {
        return this.stageAnalytics.length > 0;
    }

    

        get totalOpportunityCount() {
            return this.stageAnalytics.reduce(
                (total, item) => total + (Number(item.opportunityCount) || 0),
                0
            );
        }

        get pipelineTotal() {
            return this.stageAnalytics.reduce(
                (total, item) => total + (Number(item.totalAmount) || 0),
                0
            );
        }

        get pipelineTotalLabel() {
            return new Intl.NumberFormat('en-IN', {
                style: 'currency',
                currency: 'INR',
                notation: 'compact',
                maximumFractionDigits: 1
            }).format(this.pipelineTotal);
        }

        get countDonutDescription() {
            return `Opportunity count distribution across ${this.stageAnalytics.length} stages`;
        }

        get amountDonutDescription() {
            return `Pipeline amount distribution across ${this.stageAnalytics.length} stages`;
        }

        get countDonutStyle() {
            const total = this.totalOpportunityCount;

            if (total <= 0) {
                return 'background: conic-gradient(#e5e7eb 0deg 360deg);';
            }

            let currentAngle = 0;
            const segments = this.stageAnalytics.map((item, index) => {
                const value = Math.max(0, Number(item.opportunityCount) || 0);
                const start = currentAngle;
                currentAngle += (value / total) * 360;

                return `${DONUT_COLORS[index % DONUT_COLORS.length]} ${start}deg ${currentAngle}deg`;
            });

            return `background: conic-gradient(${segments.join(', ')});`;
        }

        get amountDonutStyle() {
            const total = this.pipelineTotal;

            if (total <= 0) {
                return 'background: conic-gradient(#e5e7eb 0deg 360deg);';
            }

            let currentAngle = 0;
            const segments = this.stageAnalytics.map((item, index) => {
                const value = Math.max(0, Number(item.totalAmount) || 0);
                const start = currentAngle;
                currentAngle += (value / total) * 360;

                return `${DONUT_COLORS[index % DONUT_COLORS.length]} ${start}deg ${currentAngle}deg`;
            });

            return `background: conic-gradient(${segments.join(', ')});`;
        }

        get stageCountChart() {
            return this.stageAnalytics.map((item, index) => ({
                ...item,
                countLabel: String(Number(item.opportunityCount) || 0),
                legendStyle: `background-color: ${DONUT_COLORS[index % DONUT_COLORS.length]};`
            }));
        }

        get stageAmountChart() {
            return this.stageAnalytics.map((item, index) => ({
                ...item,
                amountLabel: new Intl.NumberFormat('en-IN', {
                    style: 'currency',
                    currency: 'INR',
                    maximumFractionDigits: 0
                }).format(Number(item.totalAmount) || 0),
                legendStyle: `background-color: ${DONUT_COLORS[index % DONUT_COLORS.length]};`
            }));
        }


    // Sorting and pagination handlers.
    handleSortChange(event) {
        this.sortBy = event.detail.value;
        this.currentPage = 1;
        this.loadOpportunities();
    }

    handleSortDirectionChange() {
        this.sortDirection =
            this.sortDirection === 'asc' ? 'desc' : 'asc';

        this.currentPage = 1;
        this.loadOpportunities();
    }

    // Phase 2.4: Change records per page
    handlePageSizeChange(event) {
        this.pageSize = Number(event.detail.value);
        this.currentPage = 1;
        this.loadOpportunities();
    }

    handlePreviousPage() {
        if (!this.isFirstPage) {
            this.currentPage -= 1;
            this.loadOpportunities();
        }
    }

    // Refresh dashboard opportunities
    
    async handleRefresh() {
        try {
            await Promise.all([
                this.loadOpportunities(),
                refreshApex(this._wiredMetricsResult),
                refreshApex(this._wiredStageAnalyticsResult)
            ]);

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Dashboard refreshed successfully.',
                    variant: 'success'
                })
            );
        } catch (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Refresh Failed',
                    message: this.getErrorMessage(error),
                    variant: 'error'
                })
            );
        }
    }


    handleNextPage() {
        if (!this.isLastPage) {
            this.currentPage += 1;
            this.loadOpportunities();
        }
    }

    // Expand or collapse opportunity details.
    handleToggleDetails(event) {
        const recordId = event.currentTarget.dataset.id;

        this.opportunities = this.opportunities.map((opp) => {
            if (opp.Id === recordId) {
                const isExpanded = !opp.isExpanded;

                return {
                    ...opp,
                    isExpanded,
                    detailsButtonLabel: isExpanded
                        ? 'Hide Details'
                        : 'More Details'
                };
            }

            return opp;
        });
    }

    // Navigate to the opportunity record.
    handleOpenRecord(event) {
        const recordId = event.currentTarget.dataset.id;

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId,
                objectApiName: 'Opportunity',
                actionName: 'view'
            }
        });
    }

    // Create opportunity modal.
    handleOpenCreateForm() {
        this.isCreateFormOpen = true;
    }

    handleCancelCreate() {
        this.isCreateFormOpen = false;
        this.newName = '';
        this.newAmount = null;
        this.newStage = 'Prospecting';
        this.newCloseDate = this.getTodayDate();
    }

    // Search and stage filter.
    handleSearch(event) {
        this.searchKey = event.target.value;
        this.currentPage = 1;
        this.loadOpportunities();
    }

    handleStageChange(event) {
        this.stageName = event.detail.value;
        this.currentPage = 1;
        this.loadOpportunities();
    }

    // Create form input handlers.

    
    // Phase 2.3: Advanced filter input handlers
    handleMinAmountChange(event) {
        this.minAmount = event.target.value;
    }

    handleMaxAmountChange(event) {
        this.maxAmount = event.target.value;
    }

    handleCloseDateFromChange(event) {
        this.closeDateFrom = event.target.value;
    }

    handleCloseDateToChange(event) {
        this.closeDateTo = event.target.value;
    }

    // Apply advanced filters
    handleApplyFilters() {
        const min = this.minAmount === '' ? null : Number(this.minAmount);
        const max = this.maxAmount === '' ? null : Number(this.maxAmount);

        if (
            (min !== null && (!Number.isFinite(min) || min < 0)) ||
            (max !== null && (!Number.isFinite(max) || max < 0))
        ) {
            this.showToast(
                'Invalid amount',
                'Amounts must be valid non-negative numbers.',
                'warning'
            );
            return;
        }

        if (min !== null && max !== null && min > max) {
            this.showToast(
                'Invalid amount range',
                'Minimum Amount cannot exceed Maximum Amount.',
                'warning'
            );
            return;
        }

        if (
            this.closeDateFrom &&
            this.closeDateTo &&
            this.closeDateFrom > this.closeDateTo
        ) {
            this.showToast(
                'Invalid date range',
                'Close Date From cannot be after Close Date To.',
                'warning'
            );
            return;
        }

        this.appliedMinAmount = min;
        this.appliedMaxAmount = max;
        this.appliedCloseDateFrom = this.closeDateFrom || null;
        this.appliedCloseDateTo = this.closeDateTo || null;

        this.currentPage = 1;
        this.loadOpportunities();
    }

    // Clear advanced filters
    handleClearFilters() {
        this.minAmount = '';
        this.maxAmount = '';
        this.closeDateFrom = '';
        this.closeDateTo = '';

        this.appliedMinAmount = null;
        this.appliedMaxAmount = null;
        this.appliedCloseDateFrom = null;
        this.appliedCloseDateTo = null;

        this.currentPage = 1;
        this.loadOpportunities();
    }


    handleNameChange(event) {
        this.newName = event.target.value;
    }

    handleAmountChange(event) {
        this.newAmount =
            event.target.value === '' ? null : Number(event.target.value);
    }

    handleCloseDateChange(event) {
        this.newCloseDate = event.target.value;
    }

    handleNewStageChange(event) {
        this.newStage = event.detail.value;
    }

    // Create an opportunity.
    async handleCreate() {
        const inputs = [
            ...this.template.querySelectorAll(
                'lightning-input, lightning-combobox'
            )
        ].filter((input) =>
            input.closest('section[role="dialog"]')
        );

        const valid = inputs.reduce((isValid, input) => {
            input.reportValidity();
            return input.checkValidity() && isValid;
        }, true);

        if (!valid) {
            this.showToast(
                'Check required fields',
                'Complete all required fields before saving.',
                'warning'
            );
            return;
        }

        this.isSaving = true;

        try {
            await createOpportunity({
                name: this.newName,
                amount: this.newAmount,
                closeDate: this.newCloseDate,
                stageName: this.newStage
            });

            this.showToast(
                'Success',
                'Opportunity created successfully.',
                'success'
            );

            this.newName = '';
            this.newAmount = null;
            this.newStage = 'Prospecting';
            this.isCreateFormOpen = false;
            this.currentPage = 1;
            this.newCloseDate = this.getTodayDate();

            await Promise.all([
                this.loadOpportunities(),
                refreshApex(this._wiredMetricsResult),
                refreshApex(this._wiredStageAnalyticsResult)
            ]);
        } catch (error) {
            this.showToast(
                'Unable to create opportunity',
                this.getErrorMessage(error),
                'error'
            );
        } finally {
            this.isSaving = false;
        }
    }

    // Error handling.
    getErrorMessage(error) {
        return (
            error?.body?.message ||
            error?.message ||
            'An unexpected error occurred.'
        );
    }

    // Toast notifications.
    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant
            })
        );
    }
}
