---
marp: true
theme: default
footer: 'FOSS4G Asia 2023 Seoul'
paginate: true
---

# RGeo: Handling Geospatial Data for Ruby and Ruby on Rails

Taro Matsuzawa (@smellman)
Georepublic Japan

---

# This presentation available at online.

![](https://i.imgur.com/vT3LldN.png)

https://smellman.github.io/foss4g-asia-2023-rgeo/

---

# My works

- Georepublic Japan GIS Engineer
- Sub-President, Japan UNIX Society
- Director, OSGeo.JP
- Director, OpenStreetMap Foundation Japan
- Lead of United Nation OpenGIS/7 core

---

# My hobbies

- Breakcore music
- Playing video games
  - JRPGs, 2D shooting games, etc.
- Reading novels
  - Fantasy

---

# My skills

- Ruby / Ruby on Rails
- Python
- PostgreSQL / PostGIS
- JavaScript / TypeScript
  - React Native
  - MapLibre GL JS
  - AWS CDK with TypeScript
- UNIX / Linux

---

# My community works

- Maintainer of [tile.openstreetmap.jp](https://tile.openstreetmap.jp/)
    - A worldwide tile server for OpenStreetMap Japan community.
- Maintainer of [charites](https://github.com/unvt/charites)
    - A set of tools for building Mapbox/MapLibre style.
- Maintainer of [redmine-gtt](https://github.com/gtt-project/redmine_gtt)
    - A plugin for Redmine to add spatial features.
- Contributor of [types-ol-ext](https://github.com/Siedlerchr/types-ol-ext), [redux-persist](https://github.com/rt2zz/redux-persist) and more.

---

# Main topics

## 1. Ruby language is very powerful and simple, and friendly with Geo Data using RGeo.
## 2. RGeo is firendly with Ruby on Rails and PostGIS.

---

# Today's talk

1. Core concepts and data models of RGeo
2. Basics of manipulating and querying geospatial data
3. Integration with Ruby on Rails and real-world application examples using RGeo

---

# 1. Core concepts and data models of RGeo

---

# What is RGeo?

- RGeo is a geospatial data library for Ruby.
- RGeo provides a set of data classes for representing geospatial data.
- RGeo provides a set of spatial analysis operations and predicates.

---

# RGeo's implementation

- RGeo is a pure Ruby library if GEOS is not available.
- RGeo is a Ruby wrapper of GEOS if GEOS is available.
    - GEOS is a C++ library for manipulating and querying geospatial data.
    - GEOS is a part of OSGeo Foundation.
    - GEOS is used by many geospatial software, such as PostGIS, QGIS, etc.

---

# RGeo's features

- RGeo suppports many geospatial data formats.
    - WKT, WKB, GeoJSON, Shapefile, etc.
- RGeo supports Proj4.
- RGeo supports many spatial analysis operations and predicates.
    - Buffer, Convex Hull, Intersection, Union, etc.

---

# RGeo requirements

- MRI Ruby 2.6.0 or later.
- Partial support for JRuby 9.0 or later. The FFI implementation of GEOS is available (ffi-geos gem required) but CAPI is not.
  - Highly recommended to use MRI Ruby and GEOS CAPI.

---

# CAPI benchmark

- CAPI is faster than FFI and pure ruby.

```sh
❯ bundle exec ruby benchmark.rb
Warming up --------------------------------------
      with CAPI GEOS   188.859k i/100ms
       with FFI GEOS    84.720k i/100ms
         simple ruby   155.000  i/100ms
Calculating -------------------------------------
      with CAPI GEOS      1.967M (± 1.3%) i/s -     10.010M in   5.089275s
       with FFI GEOS    860.127k (± 1.1%) i/s -      4.321M in   5.023924s
         simple ruby      1.579k (± 0.9%) i/s -      7.905k in   5.008210s

Comparison:
      with CAPI GEOS:  1967118.2 i/s
       with FFI GEOS:   860127.1 i/s - 2.29x  slower
         simple ruby:     1578.5 i/s - 1246.17x  slower
```

---

# How to install (Debian/Ubuntu)

```sh
$ apt install libgeos-dev libproj-dev proj-data
```

Then

```sh
$ gem install rgeo
```

or insert the following line into your Gemfile.

```ruby
gem 'rgeo'
```

---

# RGeo extensions

- rgeo-geojson
  - GeoJSON format support
- rgeo-shapefile
  - Shapefile format support
- rgeo-proj4
  - Proj4 support

---


# Ruby on Rails support

- RGeo provides ActiveRecord extensions for Ruby on Rails with PostGIS.
  - https://github.com/rgeo/activerecord-postgis-adapter
  - Mysql / Spatialite ActiveRecord adapter is archived or not maintained.

---

# RGeo's data models

- RGeo supports OGC Simple Features Specification.
- RGeo provides a set of data classes for representing geospatial data.
  - Coordinates, Point, LineString, Polygon, MultiPoint, MultiLineString, MultiPolygon, GeometryCollection, etc.

---

# Coordinates basis

- Coordinates is a set of X, Y(, Z and M) values.

```ruby
require 'rgeo'
factory = RGeo::Cartesian.factory
point = factory.point(1, 2)
point.x # => 1.0
point.y # => 2.0
```

---

# factories

- RGeo implements a lot of factories.
    - Cartesian, Geographic, Geographic Projected, Spherical, etc.
- Cartesian factory is the default factory.

---

# Cartesian factory

```ruby
require 'rgeo'
factory = RGeo::Cartesian.factory
point = factory.point(1, 2)
point.x # => 1.0
point.y # => 2.0
```

implementation will be GEOS::CAPIFactory if GEOS is available.

---

# Ruby Cartesian factory

```ruby
require 'rgeo'
factory = RGeo::Cartesian.simple_factory
point = factory.point(1, 2)
point.x # => 1.0
point.y # => 2.0
```

Create a 2D Cartesian factory using a Ruby implementation.

---

# Spherical Factory

```ruby
require 'rgeo'
factory = RGeo::Geographic.spherical_factory
point = factory.point(1, 2)
point.x # => 1.0
point.y # => 2.0
```

Create a factory that uses a spherical model of Earth when creating and analyzing geometries.

---

# 3D factory

```ruby
require 'rgeo'
factory = RGeo::Geos.factory(has_z_coordinate: true)
point = factory.point(1, 2, 3)
point.x # => 1.0
point.y # => 2.0
point.z # => 3.0
```

Create a 3D factory using GEOS.

---

# 3D Factory (With M-Coordinate)

```ruby
require 'rgeo'
factory = RGeo::Geos.factory(has_z_coordinate: true, has_m_coordinate: true)
```

Create a 3D factory with M-Coordinate using GEOS.

---

# Specify an SRID

```ruby
require 'rgeo'
factory = RGeo::Geos.factory(srid: 4326)
point = factory.point(139.766865, 35.680760) # Tokyo station
```

Create a factory with SRID 4326 using GEOS.

---

# Point

```ruby
require 'rgeo'
factory = RGeo::Geos.factory(srid: 4326)
point = factory.point(139.766865, 35.680760) # Tokyo station
point.x # => 139.766865
point.y # => 35.68076
```

Create a point from coordinates.

---

# working with WKT

```ruby
require 'rgeo'
factory = RGeo::Geos.factory(srid: 4326)
wkt = 'POINT(139.766865 35.680760)'
point = factory.parse_wkt(wkt)
```

Create a point from WKT.

---

# LineString

```ruby
require 'rgeo'
factory = RGeo::Geos.factory
line_string = factory.line_string([
  factory.point(1, 2),
  factory.point(3, 4),
  factory.point(5, 6),
])
```

Create a LineString from points.

---

# Others

- LinerRing
- Polygon
- GeometryCollection
- MultiPoint
- MultiLineString
- MultiPolygon
  - All features supports WKT.
- see: https://github.com/rgeo/rgeo/blob/main/doc/Examples.md

---

# Basics of manipulating and querying geospatial data

---

# Spatial analysis operations

- unary predicates.
  - `ccw?`
  - `empty?`
  - `simple?`
- binary predicates.
  - `contains?`
  - `crosses?`
  - `disjoint?`
  - `crosses?`
  - `intersects?`
  - `overlaps?`

---

# `contains?`

```ruby
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
```

---

# `intersects?`

```ruby
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
```

---

# Analysis operations

- `distance`
- `buffer`
- `envelope`
- `convex_hull`
- `intersection`
- `union`
- `unary_union`
- `difference`
- `sym_difference`

---

# `distance`

```ruby
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
```

---

# Integration with Ruby on Rails and real-world application examples using RGeo

---

# Ruby on Rails support

- RGeo provides ActiveRecord extensions for Ruby on Rails with PostGIS.
  - activerecord-postgis-adapter
- ActiveRecord is powerful and simple to use.
  - And RGeo is friendly with ActiveRecord.

---

# Overview

![](https://i.imgur.com/l8cfMeC.png)

---

# 1. Create a new Rails application

```sh
rails new myapp --api -d postgresql
```

---

# 2. Add activerecord-postgis-adapter to Gemfile

```ruby
gem 'rgeo'
gem 'rgeo-geojson'
gem 'activerecord-postgis-adapter'
```

---

# 3. Setup database

```diff
--- a/myapp/config/database.yml
+++ b/myapp/config/database.yml
@@ -15,7 +15,7 @@
 # gem "pg"
 #
 default: &default
-  adapter: postgresql
+  adapter: postgis
   encoding: unicode
   # For details on connection pooling, see Rails configuration guide
   # https://guides.rubyonrails.org/configuring.html#database-pooling
```

---

# 4. Create database

```sh
rails db:create
```

---

# 5. Create a migration file to enable PostGIS extension

```sh
rails g migration AddPostgisExtensionToDatabase
```

```ruby
class AddPostgisExtensionToDatabase < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'postgis'
  end
end
```

---

# 6. Create a model/migration/controller via scaffold

```sh
rails g scaffold toilet
```

---

# 7. Edit migration file

```diff
--- a/myapp/db/migrate/20231120235529_create_toilets.rb
+++ b/myapp/db/migrate/20231120235529_create_toilets.rb
@@ -1,6 +1,8 @@
 class CreateToilets < ActiveRecord::Migration[7.0]
   def change
     create_table :toilets do |t|
+      t.string :name
+      t.st_point :location, geographic: true
 
       t.timestamps
     end
```

---

# 8. Run migration

```sh
rails db:migrate
```

---

# 9. Prepare seeds

- Download data from Overpass Turbo.

```
node
  [amenity=toilets]
  ({{bbox}});
out;
```

- Export as GeoJSON.

---

# 10. Put the GeoJSON file into `db/seed_data` directory.

```sh

- Put the GeoJSON file into `db/seed_data` directory.

```sh
mkdir db/seed_data
mv ~/Downloads/export.geojson db/seed_data/toilets.geojson
```

---

# 11. Edit db/seeds.rb

```ruby
def seed_toilets
    Rails.logger.info 'Seed toilets'
    toilets_geojson = File.read('db/seed_data/toilets.geojson')
    toilets = RGeo::GeoJSON.decode(toilets_geojson)
    toilets.each do |toilet|
        name = toilet.properties['name'] ? toilet.properties['name'] : 'no name'
        Toilet.create(
            name: name,
            location: toilet.geometry
        )
    end
end
seed_toilets
```

---

# 12. Run db:seed

```sh
rails db:seed
```

Check the database.

```sh
❯ rails r "p Toilet.count"
662
```

---

# 13. Edit app/models/toilet.rb

```ruby
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
```

---

# 14. Edit app/controllers/toilets_controller.rb

```ruby
def index
  @toilets = Toilet.all
  geojson = {
    type: "FeatureCollection",
    features: @toilets.map(&:as_json)
  }
  render json: geojson
end
```

---

Check output

```sh
curl "http://127.0.0.1:3000/toilets.json" | jq .|head -n 20
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "geometry": {
        "type": "Point",
        "coordinates": [
          139.7978412,
          35.6785662
        ]
      },
      "properties": {
        "id": 1,
        "name": "no name",
        "created_at": "2023-11-21T00:18:37.776Z",
        "updated_at": "2023-11-21T00:18:37.776Z"
      }
    },
    {
```

---

`as_json` called in `json:` render by default.

```sh
❯ curl "http://127.0.0.1:3000/toilets/1.json" | jq .
{
  "type": "Feature",
  "geometry": {
    "type": "Point",
    "coordinates": [
      139.7978412,
      35.6785662
    ]
  },
  "properties": {
    "id": 1,
    "name": "no name",
    "created_at": "2023-11-21T00:18:37.776Z",
    "updated_at": "2023-11-21T00:18:37.776Z"
  }
}
```

---

# 15. Supports GeoJSON output

Create `config/initalizers/mime_types.rb`

```ruby
Mime::Type.register 'application/vnd.geo+json', :geojson
```

---

# 16. Fix `config/routes.rb`

Default format to `geojson`.

```ruby
Rails.application.routes.draw do
  resources :toilets, defaults: { format: 'geojson' }
end
```

---

Check output

```sh
curl "http://127.0.0.1:3000/toilets/1.geojson" | jq .
{
  "type": "Feature",
  "geometry": {
    "type": "Point",
    "coordinates": [
      139.7978412,
      35.6785662
    ]
  },
  "properties": {
    "id": 1,
    "name": "no name",
    "created_at": "2023-11-21T00:18:37.776Z",
    "updated_at": "2023-11-21T00:18:37.776Z"
  }
}
```

---

![](https://i.imgur.com/pzQPoyQ.jpg)

---

# 17. Define `scope` for spatial query in `app/models/toilet.rb`

```ruby
scope :distance_sphere, lambda { |longitude, latitude, meter|
  where("ST_DWithin(toilets.location, ST_GeomFromText('POINT(:longitude :latitude)', 4326), :meter)",
    { longitude: longitude, latitude: latitude, meter: meter })
}
```

---

# 18. Use `scope` in `app/controllers/toilets_controller.rb`

```ruby
  def index
    if params[:longitude] && params[:latitude] && params[:radius]
      @toilets = Toilet.distance_sphere(
        params[:longitude].to_f, params[:latitude].to_f, params[:radius].to_i
      )
    else
      @toilets = Toilet.all
    end
    geojson = {
      type: "FeatureCollection",
      features: @toilets.map(&:as_json)
    }
    render json: geojson
  end
```

---

Check output

```sh
# without params
❯ curl "http://localhost:3000/toilets.json" | jq '.features | length'
662
# with params
❯ curl "http://localhost:3000/toilets.json?latitude=35.677724&longitude=139.76478f6&radius=1000" | jq '.features | length'
31
```

---

# TODO for this application:

- Add cors support.
- Add a map to the frontend.
- Add routing function using pgRouting.

---

# Thank you!