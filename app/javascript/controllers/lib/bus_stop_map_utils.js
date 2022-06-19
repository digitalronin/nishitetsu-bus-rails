export class BusStopMapUtils {
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
        error => {console.log(error.message)},
        {maximumAge: 60000, timeout: 5000, enableHighAccuracy: true}
      )
    } else {
      alert(this.locationUnavailableValue)
    }
  }

  displayStops({map, markers, layer}) {
    const lg = L.layerGroup(markers)

    if (layer !== undefined) {
      map.removeLayer(layer)
    }

    layer = lg
    map.addLayer(layer)

    return layer
  }

  getMarker({busStop, colour, popupHtml, showPopup}) {
    const marker = L.marker([busStop.latitude, busStop.longitude], {icon: this.icon(colour)})
    marker.bindPopup(popupHtml, {closeButton: false}).openPopup();
    marker.on("click", () => showPopup(marker, busStop))
    marker.on("mouseover", () => showPopup(marker, busStop))
    return marker
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
}
