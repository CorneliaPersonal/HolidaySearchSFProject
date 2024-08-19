import { LightningElement, track } from 'lwc';

export default class Search_by_ID_Number extends LightningElement {

    @track showSpinner = false;
    @track isSearchDisabled = true;
    @track idNumber = '';
    @track showValidationText = false;

    handleInputChange(event) {
        this.idNumber = event.target.value;

        if((this.idNumber.length === 13) && (/^\d+$/.test(idNumber))){
            this.showValidationText = false;
            this.isSearchDisabled = idValidationLuhn(idNumber);
        } 
        else {
            this.showValidationText = true;
        }
    }

    handleSearch() {
        this.showSpinner = true;

    }

    idValidationLuhn(idNumber) {
        let sum = 0;

        for (let i = 0; i < idNumber.length; i++) {
            let currentNumber = parseInt(idNumber[i]);

            if (i % 2 === 0) {
                currentNumber *= 2;
                if (currentNumber > 9) {
                    currentNumber -= 9;
                }
            }
            sum += currentNumber;
        }
        return sum % 10 === 0;
    }





}