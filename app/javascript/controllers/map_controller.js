import {Controller} from "@hotwired/stimulus"
import {post, put, patch} from '@rails/request.js'

export default class extends Controller {
  static targets = ["placeholder"]
  static values = {
    latitude: Number,
    longitude: Number,
    from: String,
    to: String
  }

  connect() {
    this.map = L.map(this.placeholderTarget).setView([this.latitudeValue, this.longitudeValue], 16);
    L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
      subdomains: ['a', 'b', 'c']
    }).addTo(this.map);

    this.map.on("moveend", async () => this.showBusStops())
    this.showBusStops()
  }

  disconnect() {
    this.map.remove()
  }

  async showBusStops() {
    const data = await this.fetchBusStops()
    data.busStops.map(bs => {this.addMarker(bs)})
  }

  // Get list of bus stops inside the bounds of the currently-displayed map
  async fetchBusStops() {
    const bounds = this.map.getBounds()
    const ne = bounds.getNorthEast()
    const sw = bounds.getSouthWest()

    const box = {
      maxLat: ne.lat,
      minLat: sw.lat,
      maxLon: ne.lng,
      minLon: sw.lng
    }
    const response = await put("/map", {
      body: JSON.stringify(box)
    })

    return response.json
  }

  addMarker(busStop) {
    // this.addMarker(bs.id, bs.tei_name, bs.latitude, bs.longitude)
    const marker = L.marker([busStop.latitude, busStop.longitude])
    marker.on("click", () => {this.updateJourney(marker, busStop)})
    marker.bindTooltip(busStop.tei_name).openTooltip();
    marker.addTo(this.map);
  }

  // set from|to, or reset the journey endpoints
  async updateJourney(marker, busStop) {
    if (this.fromValue === "") {
      this.fromValue = busStop.id
    } else {
      this.toValue = busStop.id
    }

    const params = {
      from_bus_stop: this.fromValue,
      to_bus_stop: this.toValue
    }

    const response = await patch("/map", {
      body: JSON.stringify(params),
      responseKind: "turbo-stream"
    })
  }

  resetJourney() {
    console.log("resetJourney")
    this.fromValue = ""
    this.toValue = ""
  }
}

