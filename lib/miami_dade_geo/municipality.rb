require 'miami_dade_geo/geo_attribute_client'
require 'miami_dade_geo/get_closest_feature_client'
require 'miami_dade_geo/latlong_client'

module MiamiDadeGeo
  class Municipality
    attr_reader :name, :munic_code

    def self.new_with_name(name)
      canonicalized_name = name.upcase

      poly = GeoAttributeClient.instance.
             all_fields('municipality_poly',
                        'name',
                        canonicalized_name)

      new poly
    end

    def self.new_with_code(munic_code)
      canonicalized_munic_code = "%02d" % [munic_code.to_i]

      poly = GeoAttributeClient.instance.
             all_fields('municipality_poly',
                        'municid',
                        canonicalized_munic_code)

      new poly
    end

    def self.new_with_xy(xy_hash)
      new GetClosestFeatureClient.instance.
           get_closest_feature('municipality_poly',
                               xy_hash[:x],
                               xy_hash[:y],
                               0)
    end

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
