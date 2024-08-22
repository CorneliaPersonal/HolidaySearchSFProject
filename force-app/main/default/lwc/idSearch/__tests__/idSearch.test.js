import { createElement } from "@lwc/engine-dom";
import IdSearch from "c/idSearch"; // Ensure this is the correct name of your component
import processIDAndExtractYear from "@salesforce/apex/IDSearchController.processIDAndExtractYear";
import executeCallout from "@salesforce/apex/IDSearchApiService.executeCallout";
import BEACH_IMAGE from "@salesforce/resourceUrl/Beach_png";

// Mock data
const mockResponse = JSON.stringify({
  holidays: [
    {
      name: "New Year's Day",
      date: { iso: "1985-01-01" }
    }
  ]
});

const mockErrorResponse = JSON.stringify({ holidays: [] });

describe("c-id-search", () => {
  beforeEach(() => {
    // Clear all existing mocks
    jest.clearAllMocks();
  });

  it("should initialize with default values", async () => {
    const element = createElement("c-id-search", { is: IdSearch });
    document.body.appendChild(element);

    // Ensure the component is rendered
    await Promise.resolve();
    await Promise.resolve(); // Await multiple times to ensure all async operations are complete

    // Log values to debug
    console.log("showSpinner:", element.showSpinner);
    console.log("isSearchDisabled:", element.isSearchDisabled);
    console.log("showValidationText:", element.showValidationText);
    console.log("noHolidays:", element.noHolidays);
    console.log("imageUrl:", element.imageUrl);

    expect(element.showSpinner).toBe(false);
    expect(element.isSearchDisabled).toBe(true);
    expect(element.showValidationText).toBe(false);
    expect(element.noHolidays).toBe(false);
    expect(element.imageUrl).toBe(BEACH_IMAGE);
  });

  it("should handle input change correctly", async () => {
    const element = createElement("c-id-search", { is: IdSearch });
    document.body.appendChild(element);

    const input = element.shadowRoot.querySelector("lightning-input");
    input.value = "1234567890123"; // Valid input
    input.dispatchEvent(
      new CustomEvent("change", { detail: { value: input.value } })
    );

    // Wait for the component to update
    await Promise.resolve();
    await Promise.resolve(); // Await multiple times to ensure all async operations are complete

    expect(element.idNumber).toBe("1234567890123");
    expect(element.isSearchDisabled).toBe(false);
    expect(element.showValidationText).toBe(false);
  });

  it("should disable search button on invalid input", async () => {
    const element = createElement("c-id-search", { is: IdSearch });
    document.body.appendChild(element);

    const input = element.shadowRoot.querySelector("lightning-input");
    input.value = "123"; // Invalid input
    input.dispatchEvent(
      new CustomEvent("change", { detail: { value: input.value } })
    );

    // Wait for the component to update
    await Promise.resolve();
    await Promise.resolve(); // Await multiple times to ensure all async operations are complete

    expect(element.isSearchDisabled).toBe(true);
    expect(element.showValidationText).toBe(true);
  });

  it("should handle successful callout response", async () => {
    // Mock the Apex methods
    processIDAndExtractYear.mockResolvedValue("1985");
    executeCallout.mockResolvedValue(mockResponse);

    const element = createElement("c-id-search", { is: IdSearch });
    document.body.appendChild(element);

    const input = element.shadowRoot.querySelector("lightning-input");
    input.value = "1234567890123"; // Valid input
    input.dispatchEvent(
      new CustomEvent("change", { detail: { value: input.value } })
    );

    const button = element.shadowRoot.querySelector("lightning-button");
    button.click();

    // Wait for the async operations to complete
    await Promise.resolve();
    await Promise.resolve(); // Await multiple times to ensure all async operations are complete

    expect(element.data).toHaveLength(1);
    expect(element.data[0].name).toBe("New Year's Day");
  });

  it("should handle empty holidays response", async () => {
    // Mock the Apex methods
    processIDAndExtractYear.mockResolvedValue("1985");
    executeCallout.mockResolvedValue(mockErrorResponse);

    const element = createElement("c-id-search", { is: IdSearch });
    document.body.appendChild(element);

    const input = element.shadowRoot.querySelector("lightning-input");
    input.value = "1234567890123"; // Valid input
    input.dispatchEvent(
      new CustomEvent("change", { detail: { value: input.value } })
    );

    const button = element.shadowRoot.querySelector("lightning-button");
    button.click();

    // Wait for the async operations to complete
    await Promise.resolve();
    await Promise.resolve(); // Await multiple times to ensure all async operations are complete

    expect(element.noHolidays).toBe(true);
  });

  it("should handle callout error", async () => {
    // Mock the Apex methods
    processIDAndExtractYear.mockResolvedValue("1985");
    executeCallout.mockRejectedValue(new Error("Callout error"));

    const element = createElement("c-id-search", { is: IdSearch });
    document.body.appendChild(element);

    const input = element.shadowRoot.querySelector("lightning-input");
    input.value = "1234567890123"; // Valid input
    input.dispatchEvent(
      new CustomEvent("change", { detail: { value: input.value } })
    );

    const button = element.shadowRoot.querySelector("lightning-button");
    button.click();

    // Wait for the async operations to complete
    await Promise.resolve();
    await Promise.resolve(); // Await multiple times to ensure all async operations are complete

    expect(element.noHolidays).toBe(true);
  });
});
