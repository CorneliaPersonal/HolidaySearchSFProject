import { LightningElement, track } from 'lwc';

export default class Search_by_ID_Number extends LightningElement {

    @track showSpinner = false;
    @track isSearchDisabled = true;
    @track idNumber = '';
    @track showValidationText = false;

    handleInputChange(event) {
        this.idNumber = event.target.value;

        if((this.idNumber.length === 13) && (/^\d+$/.test(this.idNumber))){
            this.showValidationText = false;
            this.isSearchDisabled = !leftToRightLuhnChecksum(this.idNumber);
        } 
        else {
            this.showValidationText = true;
            this.isSearchDisabled = true;
        }
    }

    handleSearch() {
        this.showSpinner = true;

    }
}

function leftToRightLuhnChecksum(idNumber) {
    let sum = 0;

    for (let i = 0; i < idNumber.length; i++) {
        let currentNumber = parseInt(idNumber[i]);

        if ((i + 1) % 2 === 0) {
            currentNumber *= 2;
            if (currentNumber > 9) {
                currentNumber -= 9;
            }
        }
        sum += currentNumber;
    }
    return sum % 10 === 0;
}