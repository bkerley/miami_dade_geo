# MiamiDadeGeo

This library wraps some of the Miami-Dade County geospatial services, including:

* Address to NAD 83 State Plane X and Y coordinate
* NAD 83 State Plane X and Y coordinate to latitude and longitude

# Installation #

Add this line to your application's Gemfile:

~~~ruby
gem 'miami_dade_geo'
~~~

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install miami_dade_geo

## Usage

### Coordinate to Address

~~~ruby
coordinate = MiamiDadeGeo::Coordinate.new(long: -80.199245566240819,
                                          lat: 25.7999410593211)
addr = coordinate.address
addr.address #=> "2390 NW 2ND AVE"
addr.zip #=> 33127
~~~

### Address to Coordinate

~~~ruby
addr = MiamiDadeGeo::Address.new '2390 NW 2nd Ave'
addr.zip #=> 33127
addr.lat #=> 25.7999410593211
addr.long #=> -80.199245566240819
addr.municipality.name #=> "MIAMI"
~~~

### Coordinate to Municipality

~~~ruby
muni = MiamiDadeGeo::Municipality.new_with_latlong(
  long: -80.199245566240819,
  lat: 25.7999410593211)

muni.name #=> "MIAMI"
~~~

## Links

* <https://rubygems.org/gems/miami_dade_geo>

* <https://github.com/jdiago/miami_dade_geo_api>

* <https://github.com/bkerley/what_municipality>

* <https://radiant-taiga-73968.herokuapp.com/address-meta?address=2390%20NW%202nd%20Ave>

* <https://what-mdc-muni.herokuapp.com>

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/miami_dade_geo. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
