import {Controller} from "@hotwired/stimulus"
import {put, patch} from '@rails/request.js'

export default class extends Controller {
  static targets = ["placeholder"]
  static values = {
    mapurl: String,
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

    // This only seems to work *some* of the time on the desktop. I'm not sure yet whether it
    // works at all on my phone.
    L.easyButton('<i class="material-icons crosshairs">gps_fixed</i>', (_btn, map) => {
      map.locate({setView: true, maxZoom: 16});
    }).addTo(this.map);

    this.map.on("moveend", async () => this.showBusStops())
    this.showBusStops()
  }

  disconnect() {
    this.map.remove()
  }

  async showBusStops() {
    const data = await this.fetchBusStops()
    const markers = data.busStops.map(bs => this.getMarker(bs))
    const lg = L.layerGroup(markers)

    if (this.markersLayer !== undefined) {
      this.map.removeLayer(this.markersLayer)
    }

    this.markersLayer = lg
    this.map.addLayer(this.markersLayer)
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
    }
    const response = await put(this.mapurlValue, {
      body: JSON.stringify(params)
    })

    return response.json
  }

  getMarker(busStop) {
    const colour = this.getColour(busStop)
    const marker = L.marker([busStop.latitude, busStop.longitude], {icon: this.icon(colour)})

    // On my phone, a touch generates this event, but the openPopup call doesn't seem to work
    marker.on("click", () => {
      marker.openPopup()
      this.updateJourney(marker, busStop)
    })

    // On my phone, a longish press generates this event
    marker.on("touch", () => {
      marker.openPopup()
    })

    const routes = this.busRoutesToHtmlString(busStop.routes)
    const popupHtml = `<b>${busStop.display_name}</b><br /><hr />${routes}`

    marker.on("mouseover", () => {marker.openPopup()})
    marker.bindPopup(popupHtml, {closeButton: false}).openPopup();

    return marker
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

  // set from|to, or reset the journey endpoints
  updateJourney(_marker, busStop) {
    if (this.fromValue === "") {
      this.fromValue = busStop.id
    } else {
      this.toValue = busStop.id
    }

    this.showBusStops()

    const params = {
      from_bus_stop: this.fromValue,
      to_bus_stop: this.toValue
    }

    patch(this.mapurlValue, {
      body: JSON.stringify(params),
      responseKind: "turbo-stream"
    })
  }

  resetJourney() {
    this.fromValue = ""
    this.toValue = ""
    this.showBusStops()
  }
}

