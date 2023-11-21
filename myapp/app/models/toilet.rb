class Toilet < ApplicationRecord
  scope :distance_sphere, lambda { |longitude, latitude, meter|
    where("ST_DWithin(toilets.location, ST_GeomFromText('POINT(:longitude :latitude)', 4326), :meter)",
      { longitude: longitude, latitude: latitude, meter: meter })
  }
  
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
