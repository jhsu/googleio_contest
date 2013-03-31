// Generated by CoffeeScript 1.6.2
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  window.SWMap = (function() {
    function SWMap() {
      this.addEvents = __bind(this.addEvents, this);
    }

    SWMap.prototype.map = null;

    SWMap.prototype.geocoder = new google.maps.Geocoder;

    SWMap.prototype.mapOptions = {
      center: new google.maps.LatLng(-34.397, 150.644),
      zoom: 8,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };

    SWMap.prototype.panTo = function(glatLng) {
      return this.map.panTo(glatLng);
    };

    SWMap.prototype.addMarker = function(event) {
      var pos;

      pos = new google.maps.LatLng(event.location['lat'], event.location['lng']);
      return new google.maps.Marker({
        position: pos,
        map: this.map,
        title: event.city
      });
    };

    SWMap.prototype.draw = function() {
      return this.map = new google.maps.Map(document.getElementById("map-canvas"), this.mapOptions);
    };

    SWMap.prototype.addEvents = function(events) {
      var event, i, _i, _len, _results,
        _this = this;

      _results = [];
      for (i = _i = 0, _len = events.length; _i < _len; i = ++_i) {
        event = events[i];
        if (event.location['lat'] && event.location['lng']) {
          this.addMarker(event);
          if (i === 0) {
            _results.push(this.panTo(pos));
          } else {
            _results.push(void 0);
          }
        } else {
          _results.push(this.getLatLng(event, function(ev) {
            _this.addMarker(ev);
            return console.log(ev.city);
          }));
        }
      }
      return _results;
    };

    SWMap.prototype.getLatLng = function(event, cb) {
      var address;

      address = "" + (event.city || '') + ", " + (event.state || '') + " " + (event.country || '');
      return this.geocoder.geocode({
        address: address
      }, function(results, status) {
        if (status === google.maps.GeocoderStatus.OK) {
          event.location = results[0].geometry.location;
          return cb(event);
        }
      });
    };

    return SWMap;

  })();

  window.SWEvent = (function() {
    SWEvent.all = function(cb) {
      return $.get("/datasets/events.json", function(events) {
        var allEvents, event, _i, _len;

        events = _.sortBy(events, function(event) {
          return new Date(event['start_date']);
        });
        allEvents = [];
        for (_i = 0, _len = events.length; _i < _len; _i++) {
          event = events[_i];
          allEvents.push(new SWEvent(event));
        }
        return cb(allEvents);
      }, "json");
    };

    function SWEvent(attrs) {
      this.id = attrs['id'];
      this.city = attrs['city'];
      this.state = attrs['state'];
      this.country = attrs['country'];
      this.location = attrs['location'];
    }

    return SWEvent;

  })();

  $(function() {
    var map;

    map = new SWMap();
    map.draw();
    return setTimeout(function() {
      return SWEvent.all(function(events) {
        return map.addEvents(events);
      });
    }, 1000);
  });

}).call(this);
