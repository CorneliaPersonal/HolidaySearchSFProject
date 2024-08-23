/**
 * @description       : Uses an ID number from user input to retrieve a list of public- and bank
 *                      holidays for the year of the birth date on the ID number
 * @author            : Cornelia Smit
 * @group             :
 * @last modified on  : 19-08-2024
 * @last modified by  : Cornelia Smit
 * Modifications Log
 * Ver   Date         Author                    Modification
 * 1.0   19-08-2024   Cornelia Smit             Initial Version
 **/
import { LightningElement } from "lwc";
import { leftToRightLuhnChecksum } from "c/luhnChecksum";
import processIDAndExtractYear from "@salesforce/apex/IDSearchController.processIDAndExtractYear";
import executeCallout from "@salesforce/apex/IDSearchApiService.executeCallout";
import BEACH_IMAGE from "@salesforce/resourceUrl/Beach_png";

export default class IdSearch extends LightningElement {
  columns = [
    { label: "Name", fieldName: "name" },
    { label: "Date", fieldName: "date" }
  ];
  data = [];
  showSpinner = false;
  isSearchDisabled = true;
  idNumber = "";
  showValidationText = false;
  validationMessage = "Please input a valid 13-digit ID number.";
  noHolidays = false;
  noHolidaysMessage = "Something went wrong, please try again later";
  imageUrl = BEACH_IMAGE;

  connectedCallback() {}

  handleInputChange(event) {
    this.idNumber = event.target.value;
    this.isSearchDisabled = true;
    this.showValidationText = false;

    if (!/^\d+$/.test(this.idNumber)) {
      this.showValidationText = true;
    } else if (this.idNumber.length === 13) {
      this.isSearchDisabled = !leftToRightLuhnChecksum(this.idNumber);
      this.showValidationText = this.isSearchDisabled;
    }
  }

  handleSearch() {
    this.showSpinner = true;
    let countryCode = "ZA";
    let holidayType = "national";
    let year = "";

    processIDAndExtractYear({ idNumber: this.idNumber })
      .then((result) => {
        year = result;
        return executeCallout({
          year: year,
          countryCode: countryCode,
          holidayType: holidayType
        });
      })
      .then((response) => {
        let parsedResponse;
        try {
          parsedResponse = JSON.parse(response);
        } catch (error) {
          console.error("Error parsing response:", error);
          this.showSpinner = false;
          this.noHolidays = true;
          this.data = [];
          return;
        }
        let holidays =
          parsedResponse.response &&
          Array.isArray(parsedResponse.response.holidays)
            ? parsedResponse.response.holidays
            : [];

        if (holidays.length === 0) {
          this.noHolidays = true;
          this.data = [];
        } else {
          this.noHolidays = false;
          this.data = holidays.map((holiday) => {
            return {
              name: holiday.name,
              date: holiday.date.iso
            };
          });
        }
      })
      .catch((error) => {
        console.error(error);
        this.showSpinner = false;
        this.noHolidays = true;
      });
    this.showSpinner = false;
  }
}
