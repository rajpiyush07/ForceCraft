import { LightningElement, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getActiveTemplates from '@salesforce/apex/PortfolioController.getActiveTemplates';

export default class PortfolioTemplateSelector extends NavigationMixin(LightningElement) {

    templates = [];
    selectedTemplateId;
    error;

    @wire(getActiveTemplates)
    wiredTemplates({ data, error }) {
        if (data) {
            this.templates = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.templates = [];
        }
    }

    get templateCards() {
        return this.templates.map(template => ({
            ...template,
            isSelected: template.Id === this.selectedTemplateId,
            cardClass: template.Id === this.selectedTemplateId
                ? 'template-card selected'
                : 'template-card'
        }));
    }

    
    handleSelect(event) {
        this.selectedTemplateId = event.currentTarget.dataset.id;

        const selected = this.templates.find(
            template => template.Id === this.selectedTemplateId
        );

        if (!selected) {
            return;
        }

        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Create_Portfolio__c'
            },
            state: {
                c__selectedTemplate: selected.Name
            }
        });
    }


    get hasTemplates() {
        return this.templates.length > 0;
    }

    get hasError() {
        return !!this.error;
    }

    get selectedTemplate() {
        return this.templates.find(
            template => template.Id === this.selectedTemplateId
        );
    }
}