# frozen_string_literal: true

require "benchmark/ips"
require "net/http"
require "rgeo"
require "rgeo-geojson"

# Install GEOS to run this benchmark.
exit 1 unless RGeo::Geos.capi_supported?

# https://github.com/gregoiredavid/france-geojson/blob/master/departements/38-isere/departement-38-isere.geojson
geojson = Net::HTTP.get(URI("https://raw.githubusercontent.com/gregoiredavid/france-geojson/master/departements/38-isere/departement-38-isere.geojson"))

ffi_factory   = RGeo::Cartesian.preferred_factory(native_interface: :ffi)
capi_factory  = RGeo::Cartesian.preferred_factory
ruby_factory  = RGeo::Cartesian.simple_factory
ffi_geometry  = RGeo::GeoJSON.decode(geojson, geo_factory: ffi_factory).geometry
capi_geometry = RGeo::GeoJSON.decode(geojson, geo_factory: capi_factory).geometry
ruby_geometry = RGeo::GeoJSON.decode(geojson, geo_factory: ruby_factory).geometry
ffi_point     = ffi_factory.point(5.72662, 45.18203)
capi_point    = capi_factory.point(5.72662, 45.18203)
ruby_point    = ruby_factory.point(5.72662, 45.18203)

Benchmark.ips do |x|
  x.report("with CAPI GEOS") { capi_geometry.contains?(capi_point) }
  x.report("with FFI GEOS") { ffi_geometry.contains?(ffi_point) }
  x.report("simple ruby") { ruby_geometry.contains?(ruby_point) }

  x.compare!
end