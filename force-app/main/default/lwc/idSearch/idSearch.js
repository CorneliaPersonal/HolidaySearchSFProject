import { LightningElement, track } from 'lwc';
import { leftToRightLuhnChecksum } from 'c/luhnChecksum';
import processIDAndExtractYear from '@salesforce/apex/IDSearchController.processIDAndExtractYear';
import executeCallout from '@salesforce/apex/IDSearchApiService.executeCallout';

export default class Search_by_ID_Number extends LightningElement {

    @track showSpinner = false;
    @track isSearchDisabled = true;
    @track idNumber = '';
    @track showValidationText = false;

    connectedCallback() {
    }

    handleInputChange(event) {
        this.idNumber = event.target.value;

        if((this.idNumber.length === 13) && (/^\d+$/.test(this.idNumber))){
            this.showValidationText = false;
            this.isSearchDisabled = !leftToRightLuhnChecksum(this.idNumber);
            console.log(this.idNumber);
        } 
        else {
            this.showValidationText = true;
            this.isSearchDisabled = true;
        }
    }

    handleSearch() {
        this.showSpinner = true;
        let countryCode = 'ZA';
        let holidayType = 'national';
        let year = '';

        processIDAndExtractYear({ idNumber: this.idNumber })
        .then(result => {
            year = result;
            console.log(`Year: ${year}`);
            return executeCallout({ year: year, countryCode: countryCode, holidayType: holidayType });
        })
        .then(response => {
            console.log(`Holidays: ${response}`);
            this.showSpinner = false;
        })
        .catch(error => {
            console.log(JSON.stringify(error));
            this.showSpinner = false;
        })
    }
}