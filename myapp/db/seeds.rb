# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
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