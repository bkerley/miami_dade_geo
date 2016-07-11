require 'miami_dade_geo/geo_attribute_client'
require 'miami_dade_geo/get_closest_feature_client'
require 'miami_dade_geo/latlong_client'

module MiamiDadeGeo
  # Represents one of the municipalities in Miami-Dade County, and
  # unincorporated Miami-Dade County as well.
  #
  # Makes one or two SOAP requests on construction.
  #
  # Doesn't have a `new` method for construction, since there are a few
  # different ways to construct it.
  class Municipality
    # @!attribute [r] name
    # @return [String] the name of the municipality, or
    #     unincorporated MDC.
    attr_reader :name

    # @!attribute [r] munic_code
    # @return [Integer] the numeric code of the municipality
    attr_reader :munic_code

    # Constructs a {Municipality} object for a given municipality name. The
    # SOAP method called is case-sensitive, and we believe all municipalities
    # to be ALL-CAPS, so this constructor capitalizes the name before searching.
    #
    # Useful to get the `munic_code` for a given municipality name.
    #
    # @param [String] name case-insensitive name of the municipality
    def self.new_with_name(name)
      canonicalized_name = name.upcase

      poly = GeoAttributeClient.instance.
             all_fields('municipality_poly',
                        'name',
                        canonicalized_name)

      new poly
    end

    # Constructs a {Municipality} object for a given `munic_code`. The SOAP
    # method called zero-pads single-digit municipality codes, so this
    # constructor converts the code to an `Integer` and formats it.
    #
    # Used by the {Address#municipality} method.
    #
    # @param [Integer] munic_code numeric code for the municipality
    def self.new_with_code(munic_code)
      canonicalized_munic_code = "%02d" % [munic_code.to_i]

      poly = GeoAttributeClient.instance.
             all_fields('municipality_poly',
                        'municid',
                        canonicalized_munic_code)

      new poly
    end

    # Constructs a {Municipality} object for a given x-y coordinate in
    # the NAD 83 Florida state coordinate system. Calls one SOAP method.
    #
    # @param [Hash] xy_hash NAD 83 coordinates of a location inside a
    #   municipality
    # @option xy_hash [Float] :x x-coordinate
    # @option xy_hash [Float] :y y-coordinate
    def self.new_with_xy(xy_hash)
      new GetClosestFeatureClient.instance.
           get_closest_feature('municipality_poly',
                               xy_hash[:x],
                               xy_hash[:y],
                               0)
    end

    # Constructs a {Municipality} object for a given latitude and longitude.
    # Makes two SOAP requests: one to convert from lat-long to x-y in NAD 83,
    # and one to load the municipality for the NAD 83 coordinate.
    #
    # @param [Hash] latlong_hash latitude and longitude hash of a locatio inside
    #   a municipality
    # @option latlong_hash [Float] :lat latitude coordinate
    # @option latlong_hash [Float] :long longitude coordinate
    def self.new_with_latlong(latlong_hash)
      body = LatlongClient.instance.savon.
             call(:get_x_yfrom_lat_long_dec,
                  message: { 'LNG' => latlong_hash[:long].to_f,
                             'LAT' => latlong_hash[:lat].to_f} ).
             body

      resp = body[:get_x_yfrom_lat_long_dec_response]
      result = resp[:get_x_yfrom_lat_long_dec_result]
      double = result[:double]

      new_with_xy(x: double[0], y: double[1])
    end

    private

    def initialize(poly)
      @name = poly[:name]
      @munic_code = poly[:municid]
    end
  end
end
