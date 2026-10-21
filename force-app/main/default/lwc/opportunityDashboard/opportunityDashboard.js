import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { NavigationMixin } from 'lightning/navigation';

import getOpportunities from '@salesforce/apex/OpportunityDashboardController.getOpportunities';
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

export default class OpportunityDashboard extends NavigationMixin(LightningElement) {
    searchKey = '';
    stageName = 'All';
    opportunities = [];

    wiredOpportunitiesResult;
    _wiredMetricsResult;
    _wiredStageAnalyticsResult;

    isLoading = true;
    isSaving = false;
    isCreateFormOpen = false;
    isAnalyticsLoading = true;

    // Client-side sorting and pagination of the records returned by Apex.
    sortBy = 'LastModifiedDate';
    sortDirection = 'desc';
    pageSize = 10;
    currentPage = 1;

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

    // KPI METRICS
    @wire(getOpportunityMetrics)
    wiredMetrics(result) {
        this._wiredMetricsResult = result;
        const { data, error } = result;

        if (data) {
            this.metrics = data;
            this.metricsError = undefined;
        } else if (error) {
            this.metricsError = error;
            this.showToast('Error loading metrics', this.getErrorMessage(error), 'error');
        }
    }

    // OPPORTUNITY STAGE ANALYTICS
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
            this.showToast('Error loading analytics', this.getErrorMessage(error), 'error');
        }
    }

    // OPPORTUNITY RECORDS
    @wire(getOpportunities, {
        searchKey: '$searchKey',
        stageName: '$stageName'
    })
    wiredOpportunities(result) {
        this.wiredOpportunitiesResult = result;

        if (result.data) {
            this.opportunities = result.data.map((opp) => ({
                ...opp,
                accountName: opp.Account ? opp.Account.Name : 'No Account',
                isExpanded: false,
                detailsButtonLabel: 'More Details'
            }));
            this.currentPage = 1;
            this.isLoading = false;
        } else if (result.error) {
            this.opportunities = [];
            this.currentPage = 1;
            this.isLoading = false;
            this.showToast('Error loading opportunities', this.getErrorMessage(result.error), 'error');
        }
    }

    // FILTER AND SORT OPTIONS
    get stageOptions() {
        return [{ label: 'All Stages', value: 'All' }, ...STAGES];
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

    // OPPORTUNITY LIST GETTERS
    get hasRecords() {
        return this.opportunities.length > 0;
    }

    get sortedOpportunities() {
        const records = [...this.opportunities];
        const direction = this.sortDirection === 'asc' ? 1 : -1;

        records.sort((a, b) => {
            let first = a[this.sortBy];
            let second = b[this.sortBy];

            if (first === null || first === undefined) first = '';
            if (second === null || second === undefined) second = '';

            let comparison;
            if (typeof first === 'number' && typeof second === 'number') {
                comparison = first - second;
            } else {
                comparison = String(first).localeCompare(String(second), undefined, {
                    numeric: true,
                    sensitivity: 'base'
                });
            }
            return comparison * direction;
        });

        return records;
    }

    get totalPages() {
        return Math.max(1, Math.ceil(this.sortedOpportunities.length / this.pageSize));
    }

    get paginatedOpportunities() {
        const start = (this.currentPage - 1) * this.pageSize;
        return this.sortedOpportunities.slice(start, start + this.pageSize);
    }

    get displayedOpportunities() {
        return this.paginatedOpportunities;
    }

    get isFirstPage() {
        return this.currentPage <= 1;
    }

    get isLastPage() {
        return this.currentPage >= this.totalPages;
    }

    get recordCountLabel() {
        return `${this.opportunities.length} loaded opportunities`;
    }

    get paginationLabel() {
        const total = this.sortedOpportunities.length;
        if (total === 0) return 'No opportunities';

        const start = (this.currentPage - 1) * this.pageSize + 1;
        const end = Math.min(start + this.pageSize - 1, total);
        return `Showing ${start}-${end} of ${total} loaded opportunities`;
    }

    // STAGE ANALYTICS GETTERS
    get hasStageAnalytics() {
        return this.stageAnalytics.length > 0;
    }

    get stageCountChart() {
        const maxCount = Math.max(
            1,
            ...this.stageAnalytics.map((item) => item.opportunityCount || 0)
        );

        return this.stageAnalytics.map((item) => ({
            ...item,
            barStyle: `width: ${((item.opportunityCount || 0) / maxCount) * 100}%`,
            countLabel: String(item.opportunityCount || 0)
        }));
    }

    get stageAmountChart() {
        const maxAmount = Math.max(
            0,
            ...this.stageAnalytics.map((item) => item.totalAmount || 0)
        );

        return this.stageAnalytics.map((item) => ({
            ...item,
            barStyle: `width: ${maxAmount > 0 ? ((item.totalAmount || 0) / maxAmount) * 100 : 0}%`,
            amountLabel: new Intl.NumberFormat('en-IN', {
                style: 'currency',
                currency: 'INR',
                maximumFractionDigits: 0
            }).format(item.totalAmount || 0)
        }));
    }

    // SORTING AND PAGINATION HANDLERS
    handleSortChange(event) {
        this.sortBy = event.detail.value;
        this.currentPage = 1;
    }

    handleSortDirectionChange() {
        this.sortDirection = this.sortDirection === 'asc' ? 'desc' : 'asc';
        this.currentPage = 1;
    }

    handlePreviousPage() {
        if (!this.isFirstPage) this.currentPage -= 1;
    }

    handleNextPage() {
        if (!this.isLastPage) this.currentPage += 1;
    }

    // EXPAND / COLLAPSE OPPORTUNITY DETAILS
    handleToggleDetails(event) {
        const recordId = event.currentTarget.dataset.id;
        this.opportunities = this.opportunities.map((opp) => {
            if (opp.Id === recordId) {
                const isExpanded = !opp.isExpanded;
                return {
                    ...opp,
                    isExpanded,
                    detailsButtonLabel: isExpanded ? 'Hide Details' : 'More Details'
                };
            }
            return opp;
        });
    }

    // NAVIGATE TO OPPORTUNITY RECORD
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

    // CREATE OPPORTUNITY MODAL
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

    // SEARCH AND FILTER
    handleSearch(event) {
        this.searchKey = event.target.value;
        this.currentPage = 1;
        this.isLoading = true;
    }

    handleStageChange(event) {
        this.stageName = event.detail.value;
        this.currentPage = 1;
        this.isLoading = true;
    }

    // CREATE FORM INPUT HANDLERS
    handleNameChange(event) {
        this.newName = event.target.value;
    }

    handleAmountChange(event) {
        this.newAmount = event.target.value === '' ? null : Number(event.target.value);
    }

    handleCloseDateChange(event) {
        this.newCloseDate = event.target.value;
    }

    handleNewStageChange(event) {
        this.newStage = event.detail.value;
    }

    // CREATE OPPORTUNITY
    async handleCreate() {
        const inputs = [
            ...this.template.querySelectorAll('lightning-input, lightning-combobox')
        ].filter((input) => input.closest('section[role="dialog"]'));

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

            this.showToast('Success', 'Opportunity created successfully.', 'success');
            this.newName = '';
            this.newAmount = null;
            this.newStage = 'Prospecting';
            this.isCreateFormOpen = false;
            this.currentPage = 1;
            this.newCloseDate = this.getTodayDate();

            await Promise.all([
                refreshApex(this.wiredOpportunitiesResult),
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

    // ERROR HANDLING
    getErrorMessage(error) {
        return error?.body?.message || error?.message || 'An unexpected error occurred.';
    }

    // TOAST NOTIFICATIONS
    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}
