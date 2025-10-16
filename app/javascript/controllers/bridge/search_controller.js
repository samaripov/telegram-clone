import { BridgeComponent } from "@hotwired/hotwire-native-bridge";

export default class extends BridgeComponent {
  static component = "search";
  static targets = ["input"];

  connect() {
    super.connect();

    const placeholder = this.inputTarget.placeholder;
    this.send("connect", { placeholder }, (message) => {
      const query = message.data.query;
      this.inputTarget.value = query;

      this.element.requestSubmit();
    })
  }
}