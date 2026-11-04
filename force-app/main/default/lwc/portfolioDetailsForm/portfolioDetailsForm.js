import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import Toast from 'lightning/toast';
import createPortfolio from '@salesforce/apex/PortfolioCreationController.createPortfolio';

export default class PortfolioDetailsForm extends NavigationMixin(LightningElement) {

    @api selectedTemplate;

    isSaving = false;
    isSaved = false;

    formData = {
        fullName: '',
        jobTitle: '',
        email: '',
        phone: '',
        aboutMe: '',
        profileImageUrl: '',
        linkedinUrl: '',
        githubUrl: ''
    };

    
    handleGoHome() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Home'
            }
        });
    }


    handleChange(event) {
        const field = event.target.dataset.field;
        const value = event.target.value;

        this.formData = {
            ...this.formData,
            [field]: value
        };
    }

    async handleSubmit() {
        if (this.isSaving || this.isSaved) {
            return;
        }

        const fields = this.template.querySelectorAll(
            'lightning-input, lightning-textarea'
        );

        let isValid = true;

        fields.forEach(field => {
            if (!field.reportValidity()) {
                isValid = false;
            }
        });

        if (!isValid) {
            Toast.show({
                label: 'Check Your Details',
                message: 'Please complete all required fields correctly.',
                variant: 'error'
            }, this);
            return;
        }

        this.isSaving = true;

        try {
            await createPortfolio({
                fullName: this.formData.fullName,
                professionalTitle: this.formData.jobTitle,
                email: this.formData.email,
                phone: this.formData.phone,
                aboutMe: this.formData.aboutMe,
                profileImageUrl: this.formData.profileImageUrl,
                linkedinUrl: this.formData.linkedinUrl,
                githubUrl: this.formData.githubUrl,
                portfolioName: this.formData.fullName,
                selectedTemplate: this.selectedTemplate || null
            });

            this.isSaved = true;

            Toast.show({
                label: 'Portfolio Created Successfully!',
                message: 'Your portfolio has been saved. Redirecting you to Home...',
                variant: 'success'
            }, this);

            // Automatically navigate to Home after success
            window.setTimeout(() => {
                this[NavigationMixin.Navigate]({
                    type: 'comm__namedPage',
                    attributes: {
                        name: 'Home'
                    }
                });
            }, 2000);

        } catch (error) {
            // Keep technical error details out of the customer UI
            console.error('Portfolio creation failed:', error);

            Toast.show({
                label: 'Unable to Create Portfolio',
                message: 'Something went wrong while saving your portfolio. Please try again.',
                variant: 'error'
            }, this);

        } finally {
            this.isSaving = false;
        }
    }
}