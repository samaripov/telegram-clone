import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="update-image-on-load-finish"
export default class extends Controller {
  connect() {
    const loadingElements = this.element.querySelectorAll(".thumbnail");
    const fullImage = this.element.querySelector(".full_image");
    function hideLoadingElements() {
      loadingElements.forEach(element => {
        element.style.opacity = 0;
      });
    }
    function removeLoadingElements() {
      loadingElements.forEach(element => {
        element.remove();
      });
    }
    fullImage.onload = () => {
      fullImage.classList.add("loaded");
      fullImage.style.opacity = 1;
      hideLoadingElements();
      setTimeout(removeLoadingElements, 1000);
    }
  }
}
