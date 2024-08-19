import { LightningElement, track, api } from 'lwc';

export default class Search_by_ID_Number extends LightningElement {

    @track showSpinner = false;
    @track disableSearch = true;

    handleIDNumberInput() {
        
    }

    handleSearch() {
        this.showSpinner = true;

    }





}