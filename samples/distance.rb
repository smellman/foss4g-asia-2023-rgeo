require "open-uri"
require "json"
require "rgeo"
require "rgeo-geojson"

lng, lat = [139.764786, 35.677724]
tokyo_station = RGeo::Cartesian.
                factory.
                point(lng, lat)
url = "https://raw.githubusercontent.com/smellman/foss4g-asia-2023-rgeo/main/data/hotels.geojson"
geojson = URI.open(url).read
hotels = RGeo::GeoJSON.decode(geojson)
nearest_hotel = hotels.min_by do |hotel|
  hotel.geometry.distance(tokyo_station)
end
puts nearest_hotel.properties["name:en"] # => "Tokyo Station Hotel"
farthest_hotel = hotels.max_by do |hotel|
  hotel.geometry.distance(tokyo_station)
end
puts farthest_hotel.properties["name"] # => "Appt Ikebukuro"