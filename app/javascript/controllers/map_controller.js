import {Controller} from "@hotwired/stimulus"
import {put, patch} from '@rails/request.js'

export default class extends Controller {
  static targets = ["placeholder"]
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

    this.map.on("moveend", async () => this.showBusStops())

    this.showBusStops()
    this.panToCurrentPosition(this.map)
  }

  disconnect() {
    this.map.remove()
  }

  async panToCurrentPosition(map) {
    if ('geolocation' in navigator) {
      // https://stackoverflow.com/a/31916631/794111
      navigator.geolocation.getCurrentPosition(() => {}, () => {}, {});

      navigator.geolocation.getCurrentPosition(
        position => {
          const p = position.coords
          const point = [p.latitude, p.longitude]
          map.panTo(point)

          // Show user's position on map
          L.circle(point, {
            color: 'blue',
            fillColor: '#30f',
            fillOpacity: 1,
            radius: 8
          }).addTo(map);
        },
        error => {alert(error.message)},
        {maximumAge: 60000, timeout: 5000, enableHighAccuracy: true}
      )
    } else {
      alert(this.locationUnavailableValue)
    }
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
      bus_route: this.busRouteValue,
    }
    const response = await put(this.mapurlValue, {
      body: JSON.stringify(params)
    })

    return response.json
  }

  getMarker(busStop) {
    const colour = this.getColour(busStop)
    const marker = L.marker([busStop.latitude, busStop.longitude], {icon: this.icon(colour)})

    const routes = this.busRoutesToHtmlString(busStop.routes)

    const popupHtml = `
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

    marker.bindPopup(popupHtml, {closeButton: false}).openPopup();

    marker.on("click", () => this.showPopup(marker, busStop))
    marker.on("mouseover", () => this.showPopup(marker, busStop))

    return marker
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
