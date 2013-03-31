class window.SWMap
  map: null
  geocoder: new google.maps.Geocoder

  mapOptions:
    # center = new google.maps.LatLng(-34.397, 150.644)
    center: new google.maps.LatLng(-34.397, 150.644),
    zoom: 8,
    mapTypeId: google.maps.MapTypeId.ROADMAP

  panTo: (glatLng) ->
    @map.panTo(glatLng)

  addMarker: (event) ->
    pos = new google.maps.LatLng event.location['lat'], event.location['lng']
    new google.maps.Marker
      position: pos
      map: @map
      title: event.city

  draw: ->
    @map = new google.maps.Map document.getElementById("map-canvas"), @mapOptions


  addEvents: (events) =>
    for event,i in events
      if event.location['lat'] && event.location['lng']
        @addMarker(event)
        @panTo(pos) if i == 0
      else
        @getLatLng event, (ev) =>
          @addMarker(ev)
          console.log ev.city
          # @panTo(pos) if i == 0

  getLatLng: (event, cb) ->
    address = "#{event.city || ''}, #{event.state || ''} #{event.country || ''}"
    @geocoder.geocode {address: address}, (results, status) ->
      if status == google.maps.GeocoderStatus.OK
        # console.log results[0]
        event.location = results[0].geometry.location
        cb(event)


class window.SWEvent
  @all: (cb) ->
    $.get "/datasets/events.json", (events) ->
      events = _.sortBy events, (event) ->
        new Date(event['start_date'])
      allEvents = []
      for event in events
        allEvents.push new SWEvent(event)
      cb(allEvents)
    , "json"

  constructor: (attrs) ->
    @id       = attrs['id']
    @city     = attrs['city']
    @state    = attrs['state']
    @country  = attrs['country']
    @location = attrs['location']


$ ->
  map = new SWMap()
  map.draw()
  setTimeout ->
    SWEvent.all (events) ->
      map.addEvents(events)
  , 1000

# Order events by dates

