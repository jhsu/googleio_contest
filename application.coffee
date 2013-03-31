class window.SWMap
  map: null

  mapOptions:
    # center = new google.maps.LatLng(-34.397, 150.644)
    center: new google.maps.LatLng(-34.397, 150.644),
    zoom: 8,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  draw: ->
    @map = new google.maps.Map document.getElementById("map-canvas"), @mapOptions

  addEvents: (events) =>
    for event in events
      pos = new google.maps.LatLng event.location['lat'], event.location['lng']
      new google.maps.Marker
        position: pos
        map: @map
        title: event.city

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

  constructor: (attributes) ->
    @id = attributes['id']
    @city = attributes['city']
    @location = attributes['location']


$ ->
  map = new SWMap()
  map.draw()
  SWEvent.all (events) ->
    map.addEvents(events)

# Order events by dates

