import {Controller} from "@hotwired/stimulus"
import {put, patch} from '@rails/request.js'
import whatever from "./lib/foo.js"

export default class extends Controller {
  static targets = [
    "placeholder",
    "search",
    "fromtext",
    "totext",
  ]

  static values = {
    url: String,
    latitude: Number,
    longitude: Number,
  }

  connect() {
    this.map = L.map(this.placeholderTarget).setView([this.latitudeValue, this.longitudeValue], 16);

    L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
      subdomains: ['a', 'b', 'c']
    }).addTo(this.map);

    L.easyButton('<i class="material-icons crosshairs">gps_fixed</i>', (_btn, map) => {
      this.panToCurrentPosition(map)
    }).addTo(this.map);

    // this.map.on("moveend", async () => this.showBusStops())
    // this.showBusStops()
    // this.map.panToCurrentPosition(this.map)
  }

  disconnect() {
    this.map.remove()
  }

  clearJourney() {
    this.fromValue = ""
    this.toValue = ""
    this.updateDisplay()
  }

  // set from|to, or clear the journey endpoints
  updateDisplay() {
    const params = {
      from: this.fromValue,
      to: this.toValue,
    }

    patch(this.urlValue, {
      body: JSON.stringify(params),
      responseKind: "turbo-stream"
    })
  }
}
