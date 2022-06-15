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
    from: String,
    to: String,
    setJourneyFrom: String,
    setJourneyTo: String,
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

    this.map.on("click", (e) => {this.mapClick(e)})

    this.popup = L.popup()
    this.marker = L.marker()
    this.fromMarker = L.marker()
    this.toMarker = L.marker()

    // this.map.on("moveend", async () => this.showBusStops())
    // this.showBusStops()
    // this.map.panToCurrentPosition(this.map)
  }

  async search(e) {
    e.preventDefault()
    if (this.fromValue !== "" && this.toValue !== "") {
      this.updateDisplay()
      return
    }
  }

  mapClick(e) {
    const popupHtml = `
      <div class="map popup">
        <a class="set-journey-from">${this.setJourneyFromValue}</a>
        |
        <a class="set-journey-to">${this.setJourneyToValue}</a>
      </div>
    `

    this.marker
      .setLatLng(e.latlng).addTo(this.map)
      .bindPopup(popupHtml, {closeButton: false})
      .openPopup()

    // Bind events to popup links
    const fromLink = document.getElementsByClassName("set-journey-from")[0]
    fromLink.onclick = () => this.setJourneyFrom(e.latlng)

    const toLink = document.getElementsByClassName("set-journey-to")[0]
    toLink.onclick = () => this.setJourneyTo(e.latlng)

    // this.popup
    //   .setLatLng(e.latlng)
    //   .setContent(`Clicked at ${e.latlng.toString()}`)
    //   .openOn(this.map)
  }

  disconnect() {
    this.map.remove()
  }

  clearJourney() {
    this.fromValue = ""
    this.toValue = ""
    this.marker.remove()
    this.fromMarker.remove()
    this.toMarker.remove()
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

  // TODO: shared with MapController
  icon(colour) {
    const MyIcon = L.Icon.extend({
      options: {
        iconSize: [25, 41],
        iconAnchor: [12, 41],
        popupAnchor: [1, -34],
        tooltipAnchor: [16, -28],
      }
    });

    return new MyIcon({iconUrl: `/${colour}-map-marker.png`})
  }

  setJourneyFrom(point) {
    this.marker.remove()

    this.fromValue = `${point.lat},${point.lng}`

    this.fromMarker
      .setLatLng(point)
      .setIcon(this.icon("green"))
      .addTo(this.map)

    this.updateDisplay()
  }

  setJourneyTo(point) {
    this.marker.remove()

    this.toValue = `${point.lat},${point.lng}`

    this.toMarker
      .setLatLng(point)
      .setIcon(this.icon("red"))
      .addTo(this.map)

    this.updateDisplay()
  }
}
