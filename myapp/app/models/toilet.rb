class Toilet < ApplicationRecord
  def as_geojson
    {
      type: "Feature",
      geometry: RGeo::GeoJSON.encode(self.location),
      properties: self.attributes.except("location")
    }
  end
    
  def as_json(options = {})
    as_geojson
  end
end
