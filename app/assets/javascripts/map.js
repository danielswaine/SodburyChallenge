var markers = []

function updateMap () {
  var table = $('table.locations tbody')
  var tableRef = document.getElementById('team-locations')

  $.ajax({
    type: 'GET',
    url: window.location.pathname + '/update'
  }).done(function evaluate (data) {
    var index = 0

    /* Clear down ready for new data */
    markers.forEach(function (e) { e.setMap(null) })
    $(table).children('tr').remove()

    $.each(data.locations, function (_, value) {
      ts = new Date(value.timestamp).toLocaleString('en-GB', { timeZone: 'Europe/London' })

      table.append('<tr>' +
                    '<td>' + value.team_number + '</td>' +
                    '<td>' + ts + '</td>' +
                    '<td>' + value.latitude + '</td>' +
                    '<td>' + value.longitude + '</td>' +
                    '<td>' + value.speed + '</td>' +
                    '<td>' + value.battery + '</td>' +
                    '<td>' + value.rssi + '</td>' +
                    '<td>' + value.mobile_number + '</td>' +
                  '</tr>')

      var position = {
        lat: parseFloat(value.latitude),
        lng: parseFloat(value.longitude)
      }

      var info = '<b>Team:</b> ' + value.team_number + '<br><b>Time:</b> ' + ts

      /* Add event listener to the row just appended (last row in table)    */
      /* which will pan to that location in the map                         */
      var currentRow = tableRef.rows[tableRef.rows.length - 1]
      var teamPosition = new google.maps.LatLng(position.lat, position.lng)
      currentRow.addEventListener('click', function () {
        map.panTo(teamPosition)
        map.setZoom(15)
      })

      markers[index] = addMarker(map, position, value.team_number, 'green', info)
      markers[index].setMap(map)
      index++
    })

    $.each(data.goals, function (_, value) {
      var info = ''
      var position = gridref2latlon(value.grid_reference.toString())

      info += '<b>Grid Ref:</b> ' + value.grid_reference + '<br>'
      info += '<b>Description:</b> ' + value.description + '<br>'

      info += value.points_value.map(function (e) {
        var start = e.start ? ' (Start)' : ''
        var compulsory = e.compulsory ? ' (Compulsory)' : ''
        var type = start + compulsory
        return '<b>' + e.time_allowed + ' Hour:</b> ' + e.points_value + ' points' + type + '<br>'
      }).join('')

      var colour = value.points_value.some(function (e) {
        return (e.start || e.compulsory) === true
      }) ? 'purple' : 'red'
      markers[index] = addMarker(map, position, value.number, colour, info)
      markers[index].setMap(map)
      index++
    })
  })
}

function pinSymbol (color) {
  return {
    path: 'M 0,0 C -2,-20 -10,-22 -10,-30 A 10,10 0 1,1 10,-30 C 10,-22 2,-20 0,0 z',
    fillColor: color,
    fillOpacity: 1,
    labelOrigin: new google.maps.Point(0, -30),
    strokeColor: '#000',
    strokeWeight: 2,
    scale: 1
  }
}

function addMarker (map, pos, num, color, info) {
  var infowindow = new google.maps.InfoWindow({
    content: info
  })
  var markerOptions = {
    position: new google.maps.LatLng(pos.lat, pos.lng),
    label: {
      color: '#FFF',
      fontSize: '11px',
      text: num.toString()
    },
    icon: pinSymbol(color),
    optimized: true
  }
  var marker = new google.maps.Marker(markerOptions)
  marker.infowindow = infowindow
  marker.addListener('click', function () {
    return this.infowindow.open(map, this)
  })

  return marker
}

function gridref2latlon (gridref) {
  var split = gridref.split('-')
  var easting = '3' + split[0] + '0'
  var northing = '1' + split[1] + '0'

  osgb = new GT_OSGB()
  osgb.setGridCoordinates(easting, northing)
  wgs84 = osgb.getWGS84()

  return {
    lat: wgs84.latitude,
    lng: wgs84.longitude
  }
}

var map

function initMap () {
  updateMap()
  setInterval(updateMap, 150000)

  var center = new google.maps.LatLng(51.593418, -2.399274)
  map = new google.maps.Map(document.getElementById('map'), {center: center, zoom: 12})

  /* Close all info windows when clicking on map */
  google.maps.event.addListener(map, 'click', function(event) {
    markers.forEach(function (e) { e.infowindow.close() })
  })
}
