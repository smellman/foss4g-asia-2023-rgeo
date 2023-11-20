require "open-uri"
require "json"
require "rgeo"
require "rgeo-geojson"

my_lat, my_lng = [45, 5]
my_position = RGeo::Cartesian.
              factory.
              point(my_lng, my_lat)

geojson = URI.
    	  open("https://git.io/rhone-alpes.geojson").
    	  read
rhone_alpes = RGeo::GeoJSON.decode(geojson).geometry

if rhone_alpes.contains?(my_position)
  puts "Let's ski ⛷"
end
