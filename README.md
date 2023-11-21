# FOSS4G Asia 2023 RGeo

- title: RGeo: Handling Geospatial Data for Ruby and Ruby on Rails
- author: Taro Matsuzawa(@smellman)
- date: 2023-11-30

## build presentation

You need node.js.

```sh
make
```

## run samples

```sh
cd samples
bundle install
bundle exec ruby benchmark.rb
bundle exec ruby contains.rb
bundle exec ruby intersects.rb
bundle exec ruby distance.rb
```

## run myapp

```sh
cd myapp
bundle install
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:seed
bundle exec rails s
```