import { LightningElement, track } from 'lwc';
import { leftToRightLuhnChecksum } from 'c/luhnChecksum';
import getHolidaysForID from '@salesforce/apex/IDSearchController.getHolidaysForID';

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

        getHolidaysForID({ idNumber: this.idNumber })
        .then(result => {
            this.showSpinner = false;

            if(result.includes('Error')) {
                console.log(`handleSearch error: ${result}`);
            } else {
                console.log(`handleSearch result: ${result}`);
            }
        })
        .catch(error => {
            console.log(JSON.stringify(error));
        })
    }
}