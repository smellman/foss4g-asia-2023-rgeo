require "open-uri"
require "json"
require "rgeo"
require "rgeo-geojson"

# FeatureCollection
line1 = 'https://raw.githubusercontent.com/smellman/foss4g-asia-2023-rgeo/main/data/line1.geojson'
line2 = 'https://raw.githubusercontent.com/smellman/foss4g-asia-2023-rgeo/main/data/line2.geojson'
geojson1 = URI.open(line1).read
geojson2 = URI.open(line2).read
geometry1 = RGeo::GeoJSON.decode(geojson1)[0].geometry
geometry2 = RGeo::GeoJSON.decode(geojson2)[0].geometry
p geometry1.intersects?(geometry2) # => true