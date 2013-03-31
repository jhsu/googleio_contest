class window.SWMap

class window.SWEvent
  @all: ->
    $.get "/datasets/events.json", (events) ->
      events = _.sortBy events, (event) ->
        new Date(event['start_date'])
      for event in events
        console.log(event['start_date'])
    , "json"


$ ->
  SWEvent.all()

# Order events by dates

