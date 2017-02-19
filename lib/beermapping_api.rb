class BeermappingApi
  def self.places_in(city)
    city = city.downcase
    Rails.cache.fetch(city, :expires_in => 1.minute, race_condition_ttl:10) { fetch_places_in(city) }
  end

  def self.place_in(place_id)
    place = place_id
    Rails.cache.fetch(place, :expires_in => 1.minute, race_condition_ttl:10) { fetch_place(place) }
  end


  private

  def self.fetch_place(city_id)
    url = "http://stark-oasis-9187.herokuapp.com/api/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city_id)}"
    place = response.parsed_response["bmp_locations"]["location"]

    Place.new(place)
  end

  def self.fetch_places_in(city)
    url = "http://stark-oasis-9187.herokuapp.com/api/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.map do | place |
      Place.new(place)
    end
  end
end