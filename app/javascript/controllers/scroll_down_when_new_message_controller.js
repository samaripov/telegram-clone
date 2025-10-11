import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scroll-down-when-new-message"
export default class extends Controller {
  connect() {
    this.resizeObserver = new ResizeObserver(this.scrollToTheBottom.bind(this));
    this.resizeObserver.observe(this.element);

    const messageInput = document.getElementById("message_text");
    console.log(messageInput)
    messageInput.addEventListener("focus", this.scrollToTheBottom.bind(this))
  }
  disconnect() {
    this.resizeObserver.disconnect();
  }
  scrollToTheBottom() {
    setTimeout(()=>{}, 500);
    const lastDiv = document.querySelector('#messages div:last-of-type');
    lastDiv.scrollIntoView({ behavior: "smooth" });
  }
}
