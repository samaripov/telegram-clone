import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="message"
export default class extends Controller {
  static targets = ["text", "submit"];
  connect() {
    this.submitTarget.style.display = this.textTarget.value.length > 0 ? "inline" : "none";
    this.textTarget.addEventListener("input", (e) => {
      this.submitTarget.style.display = this.textTarget.value.length > 0 ? "inline" : "none";
    })
  }
}
