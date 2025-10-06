import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="message"
export default class extends Controller {
  static targets = ["text", "submit"];

 connect() {
    // Ensure to bind the method on connect
    this.removeSubmitOnEnter = this.removeSubmitOnEnter.bind(this);
    
    // Check the text input once to set up the initial state
    this.submitIfTextExists();
    
    // Add an event listener for input changes
    this.textTarget.addEventListener("input", this.submitIfTextExists.bind(this));
  }

  removeSubmitOnEnter(e) {
    if (e.key === "Enter") {
      e.preventDefault(); // Prevent form submission on Enter key
    }
  }

  submitIfTextExists() {
    const displayStatus = this.textTarget.value.length > 0 ? "inline" : "none";
    this.submitTarget.style.display = displayStatus;

    // Manage the event listener based on the text input
    if (displayStatus === "none") {
      this.element.addEventListener("keypress", this.removeSubmitOnEnter);
    } else {
      this.element.removeEventListener("keypress", this.removeSubmitOnEnter);
    }
  }
}
