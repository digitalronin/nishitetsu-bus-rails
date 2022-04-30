import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["placeholder"]
  static values = {
    latitude: Number,
    longitude: Number
  }

  connect() {
    console.log(this.latitudeValue)
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
    const response = await fetch("/map", {
      method: "PUT",
      headers: {
        "X-CSRF-Token": document.head.querySelector("[name='csrf-token']").content,
        Accept: "text/vnd.turbo-stream.html",
        "Content-Type": "application/json"
      },
      body: JSON.stringify(box)
    })

    const rtn = await response.json()

    return rtn
  }

  addMarker(busStop) {
    // this.addMarker(bs.id, bs.tei_name, bs.latitude, bs.longitude)
    const marker = L.marker([busStop.latitude, busStop.longitude])
    // marker.on("click", () => { window.location = url; });
    marker.bindTooltip(busStop.tei_name).openTooltip();
    marker.addTo(this.map);
  }
}

