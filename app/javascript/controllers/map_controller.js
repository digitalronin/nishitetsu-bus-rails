import {Controller} from "@hotwired/stimulus"
import {put, patch} from '@rails/request.js'

import {BusStopMapUtils} from "./lib/bus_stop_map_utils.js"

export default class extends Controller {
  static targets = [
    "placeholder",
    "search",
    "fromtext",
    "totext",
  ]

  static values = {
    mapurl: String,
    latitude: Number,
    longitude: Number,
    from: String,
    to: String,
    setJourneyFrom: String,
    setJourneyTo: String,
    busRoute: String,
    viewType: String,
    searchurl: String,
  }

  connect() {
    this.bsmu = new BusStopMapUtils()

    this.map = L.map(this.placeholderTarget).setView([this.latitudeValue, this.longitudeValue], 16);

    L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
      subdomains: ['a', 'b', 'c']
    }).addTo(this.map);

    L.easyButton('<i class="material-icons crosshairs">gps_fixed</i>', (_btn, map) => {
      this.bsmu.panToCurrentPosition(map)
    }).addTo(this.map);

    this.map.on("moveend", async () => this.showBusStops())

    this.showBusStops()
    this.bsmu.panToCurrentPosition(this.map)
  }

  disconnect() {
    this.map.remove()
  }

  async search() {
    let searchString = ""

    if (this.fromValue !== "" && this.toValue !== "") {
      // both from and to bus stops have been set
      window.location = this.searchurlValue.replace("FROM", this.fromValue).replace("TO", this.toValue)
      return
    }

    const from = this.fromtextTarget.value
    const to = this.totextTarget.value

    if (this.fromValue === "" && this.toValue === "") {
      // neither from/to bus stop is set
      searchString = from !== "" ? from : to
    } else if (this.fromValue === "") {
      // to bus stop is set
      searchString = from
    } else if (this.toValue === "") {
      // from bus stop is set
      searchString = to
    }

    if (searchString !== "") {
      const str = `${searchString}, FUKUOKA`
      const url = new URL("https://nominatim.openstreetmap.org/search")
      url.searchParams.append("country", "JP")
      url.searchParams.append("format", "json")
      url.searchParams.append("q", str)
      const result = await fetch(url, {
        headers: {
          "mode": "no-cors",
          "User-Agent": "Unofficial Nishitetsu Bus Rails app.",
          "Referer": "https://github.com/digitalronin/nishitetsu-bus-rails"
        }
      })
      const data = await result.json()
      const {lat, lon} = data[0]
      this.map.panTo([lat, lon])
    }
  }

  // Get list of bus stops inside the bounds of the currently-displayed map
  async fetchBusStops() {
    const bounds = this.map.getBounds()
    const ne = bounds.getNorthEast()
    const sw = bounds.getSouthWest()

    const params = {
      maxLat: ne.lat,
      minLat: sw.lat,
      maxLon: ne.lng,
      minLon: sw.lng,
      from_bus_stop: this.fromValue,
      to_bus_stop: this.toValue,
      bus_route: this.busRouteValue,
    }
    const response = await put(this.mapurlValue, {
      body: JSON.stringify(params)
    })

    return response.json
  }

  async showBusStops() {
    const data = await this.fetchBusStops()
    const markers = data.busStops.map(bs => this.getMarker(bs))
    this.markersLayer = this.bsmu.displayStops({markers, layer: this.markersLayer, map: this.map})
  }

  getMarker(busStop) {
    return this.bsmu.getMarker({
      busStop,
      colour: this.getColour(busStop),
      popupHtml: this.popupHtml(busStop),
      showPopup: (marker, busStop) => {this.showPopup(marker, busStop)}
    })
  }

  popupHtml(busStop) {
    const routes = this.busRoutesToHtmlString(busStop.routes)
    return `
      <div class="map popup">
        <b>${busStop.display_name}</b><br />
        <a class="set-journey-from">${this.setJourneyFromValue}</a>
        |
        <a class="set-journey-to">${this.setJourneyToValue}</a>
        <br />
        <hr />
        ${routes}
      </div>
    `
  }

  showPopup(marker, busStop) {
    marker.openPopup()

    // Bind events to popup links
    const fromLink = document.getElementsByClassName("set-journey-from")[0]
    fromLink.onclick = () => this.setJourneyFrom(busStop)

    const toLink = document.getElementsByClassName("set-journey-to")[0]
    toLink.onclick = () => this.setJourneyTo(busStop)
  }

  busRoutesToHtmlString(routes) {
    let rtn = ''
    const chunkSize = 4;
    for (let i = 0; i < routes.length; i += chunkSize) {
      const chunk = routes.slice(i, i + chunkSize);
      rtn += `${chunk.join(", ")}<br />`
    }
    return rtn
  }

  getColour(busStop) {
    if (String(busStop.id) === this.fromValue) {
      return "green"
    } else if (String(busStop.id) === this.toValue) {
      return "red"
    } else {
      return "blue"
    }
  }

  setJourneyFrom(busStop) {
    this.fromValue = busStop.id
    this.updateDisplay()
  }

  setJourneyTo(busStop) {
    this.toValue = busStop.id
    this.updateDisplay()
  }

  // set from|to, or clear the journey endpoints
  updateDisplay() {
    this.showBusStops()

    const params = {
      from_bus_stop: this.fromValue,
      to_bus_stop: this.toValue,
      bus_route: this.busRouteValue,
      view_type: this.viewTypeValue,
    }

    patch(this.mapurlValue, {
      body: JSON.stringify(params),
      responseKind: "turbo-stream"
    })
  }

  clearJourney() {
    this.fromValue = ""
    this.toValue = ""
    this.updateDisplay()
  }
}
