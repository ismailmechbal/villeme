module Gmaps


  private

  def format_for_map_this(events)
    letter = ('A'..'Z').to_a
    i = 0
    @array_of_events = Array.new

    get_events_in_a_hash(events).each do |index, value|
      @array_of_events << {latLng: [value[:latitude].to_s, value[:longitude].to_s],
                           id: letter[i].to_s,
                           data: {link: value[:url].to_s,
                                  name: index.to_s,
                                  address: value[:address]
                           },
                           options: {icon: '/images/marker-default-' + value[:strong_category].to_s.parameterize + '.png'}
      }
      i += 1
    end

    @array_of_events << get_current_user_in_a_hash

    @array_of_events
  end



  def get_events_in_a_hash(events)
    @hash_of_events = Hash.new
    events.each do |event|
      @hash_of_events[event.name] = {
          latitude: event.get_latitude,
          longitude: event.get_longitude,
          address: event.address,
          url: event_url(event),
          strong_category: strong_category(event, 'slug')
      }
    end
    @hash_of_events
  end


  def get_current_user_in_a_hash
    {latLng: current_user.coordinates,
     data: current_user.name.to_s,
     options: {
         icon: "/images/marker-default-home.png"
     }
    }
  end



end
