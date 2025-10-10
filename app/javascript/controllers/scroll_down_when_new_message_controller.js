import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scroll-down-when-new-message"
export default class extends Controller {
  connect() {
    console.log(this.element.scrollHeight);
    this.resizeObserver = new ResizeObserver(this.scrollToTheBottom.bind(this));
    this.resizeObserver.observe(this.element);
  }
  disconnect() {
    this.resizeObserver.disconnect();
  }
  scrollToTheBottom() {
    const lastDiv = document.querySelector('#messages div:last-of-type');
    lastDiv.scrollIntoView({ behavior: "smooth" });
  }
}
