require 'miami_dade_geo/latlong_client'
require 'miami_dade_geo/get_closest_feature_client'

module MiamiDadeGeo
  class Coordinate
    def initialize(opts)
      if opts[:x] && opts[:y]
        initialize_from_xy opts
      elsif
        opts[:lat] && opts[:long]
        initialize_from_latlong opts
      else
        fail ArgumentError "Can't initialize without x & y or lat & long"
      end
    end

    def initialize_from_xy(opts)
      @x = opts[:x].to_f
      @y = opts[:y].to_f
    end

    def initialize_from_latlong(opts)
      @lat = opts[:lat].to_f
      @long = opts[:long].to_f
    end

    def x
      return @x if @x
      load_xy_from_latlong
      @x
    end

    def y
      return @y if @y
      load_xy_from_latlong
      @y
    end

    def lat
      return @lat if @lat
      load_latlong_from_xy
      @lat
    end

    def long
      return @long if @long
      load_latlong_from_xy
      @long
    end

    def xy
      { x: x, y: y }
    end

    def latlong
      {  lat: lat, long: long }
    end

    def address
      get_closest_feature_client.find_feature(xy, 'GeoAddress')
    end

    private
    def load_xy_from_latlong
      body = latlong_client.
             call(:get_x_yfrom_lat_long_dec,
                  message: { 'LNG' => long.to_s, 'LAT' => lat.to_s}).
             body

      resp = body[:get_x_yfrom_lat_long_dec_response]
      result = resp[:get_x_yfrom_lat_long_dec_result]

      @x = result[:double][0].to_f
      @y = result[:double][1].to_f
    end

    def load_latlong_from_xy
      body = latlong_client.
             call(:get_lat_long_dec_from_xy,
                  message: { 'X' => x.to_s, 'Y' => y.to_s} ).
             body

      resp = body[:get_lat_long_dec_from_xy_response]
      result = resp[:get_lat_long_dec_from_xy_result]

      @lat = result[:double][1].to_f
      @long = result[:double][0].to_f
    end

    def get_closest_feature_client
      GetClosestFeatureClient.instance
    end

    def latlong_client
      LatlongClient.instance.savon
    end
  end
end
