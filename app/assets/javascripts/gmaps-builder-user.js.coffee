class @Gmaps

  constructor: (@latitude, @longitude) ->
    @newMap()
    @init()
    return



  init: ->
    Gmaps.buttonToGetLocation()
    Gmaps.inputToGetLocationOnKeyup()
    return



  newMap: ->

    style = [{"featureType":"road","elementType":"geometry","stylers":[{"lightness":100},{"visibility":"simplified"}]},{"featureType":"water","elementType":"geometry","stylers":[{"visibility":"on"},{"color":"#d6defa"}]},{"featureType":"poi.business","stylers":[{"visibility":"off"}]},{"featureType":"poi","elementType":"geometry.fill","stylers":[{"color":"#dff5e6"}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#D1D1B8"}]},{"featureType":"landscape","elementType":"geometry.fill","stylers":[{"color":"#ffffff"}]}]

    Gmaps.showMapCanvasIfHidden()

    $("#map").gmap3
      map:
        options:
          center: [
            @latitude
            @longitude
          ]
          zoom: 13
          mapTypeId: google.maps.MapTypeId.ROADMAP
          mapTypeControl: false
          mapTypeControlOptions:
            style: google.maps.MapTypeControlStyle.DROPDOWN_MENU

          navigationControl: false
          scrollwheel: true
          streetViewControl: false
          zoomControl: true
          zoomControlOptions:
            style: google.maps.ZoomControlStyle.SMALL,
            position: google.maps.ControlPosition.RIGHT_TOP
          styles: style

      marker:
        values:
          gon.events_local_formatted

        options:
          draggable: false

        events:
          dragend: (marker) ->
            $(this).gmap3 getaddress:
              latLng: marker.getPosition()
              callback: (results) ->
                map = $(this).gmap3("get")
                infowindow = $(this).gmap3(get: "infowindow")

                $.each results[0].address_components, (x, y) ->
                  $.each this, (name, value) ->
                    if value[0] is "route"
                      address = y.long_name
                      $("#event_address, #event_place_attributes_address, #address").val address

                    else if value[0] is "street_number"
                      @number = y.long_name
                      $("#number, #place-number").val @number

                    else if value[0] is "neighborhood"
                      @neighborhood = y.long_name
                      $("#neighborhood, #neighborhood-place, #neighborhood-name").val @neighborhood
                    return

                  return

                content = (if results and results[0] then "Endereço encontrado!" else "Endereço não encontrado")

                if infowindow
                  infowindow.open map, marker
                  infowindow.setContent content
                else
                  $(this).gmap3 infowindow:
                    anchor: marker
                    options:
                      content: content

                map = $(this).gmap3("get")
                google.maps.event.trigger(map, 'resize');
                latLng = results[0].geometry.location
                map.panTo latLng

                return

            return
    return


  @panTo: (latitude, longitude) ->
    latLng = new google.maps.LatLng(latitude, longitude)

    map = $("#map").gmap3("get")
    map.panTo latLng
    return


  @centerTo: (latitude, longitude) ->
    latLng = new google.maps.LatLng(latitude, longitude)
    map = $("#map").gmap3("get")

    map.setCenter latLng
    return


  @clearMarker: ->
    $('#map').gmap3(
      clear:
        name: "marker"
    )
    return


  @getLocationFromAddress: (address) ->
    $("#map").gmap3
      clear:
        name: "marker"

      getlatlng:
        address: address
        callback: (results) ->
          unless results
            $(".address-place-inputs").css("border-color", "#A94442")
            alert "Endereço não encontrado. Tente buscar outro."
          else
            $(".address-place-inputs").css("border-color", "#5fcf80")
            $(this).gmap3 marker:
              latLng: results[0].geometry.location
              options:
                draggable: true
                icon: "/images/marker-default.png"

              events:
                dragend: (marker) ->
                  $(this).gmap3 getaddress:
                    latLng: marker.getPosition()
                    callback: (results) ->
                      map = $(this).gmap3("get")
                      infowindow = $(this).gmap3(get: "infowindow")
                      content = (if results and results[0] then results and results[0].formatted_address else "no address")
                      if infowindow
                        $('#address').val(content)
                        infowindow.open map, marker
                        infowindow.setContent content
                      else
                        $('#address').val(content)
                        $(this).gmap3 infowindow:
                          anchor: marker
                          options:
                            content: content


                      map = $(this).gmap3("get")
                      latLng = results[0].geometry.location
                      map.panTo latLng
                      return

                  return

            map = $(this).gmap3("get")
            latLng = results[0].geometry.location
            map.panTo latLng

          return

    return




  @buttonToGetLocation: ->
    $('.btn-geocoder-address-for-map').click ->
      address = $('.input-address-search').val()
      @getLocationFromAddress(address)
      return
    return



  @inputToGetLocationOnKeyup: ->
    $('#address').keyup ->
      address = this.value
      if address.length > 5
        delay( ->
          @getLocationFromAddress(address)
          return
        , 900)

      return

    delay = (->
      timer = 0
      (callback, ms) ->
        clearTimeout timer
        timer = setTimeout(callback, ms)
        return
    )()

    return


  @showMapCanvasIfHidden: ->
    if $('#map').css('display') is 'none'
      $('#map').show()

    return

