require 'miami_dade_geo/addr_xy_client'
require 'miami_dade_geo/latlong_client'
require 'miami_dade_geo/municipality'
require 'miami_dade_geo/errors/invalid_address_error'

module MiamiDadeGeo
  # A street address in Miami-Dade County.
  # Lazily makes up to two SOAP requests:
  # one to get the X and Y coordinates, and one to convert them to standard
  # latitude and longitude.
  #
  # Can raise an [InvalidAddressError] when lazily making the initial SOAP
  # request if the given address does not exist.
  #
  # @raise [InvalidAddressError]
  class Address
    # @!attribute [r] address
    # @return [String] the street address
    attr_reader :address

    # Construct the address object
    # @param address [String] the street address
    def initialize(address)
      @address = address
    end

    # @return [Float] the x-coordinate of the address
    def x
      @x ||= xy_addr[:x].to_f
    end

    # @return [Float] the y-coordinate of the address
    def y
      @y ||= xy_addr[:y].to_f
    end

    # @return [Integer] the ZIP code of the address
    def zip
      @zip ||= xy_addr[:zip_code].to_i
    end

    # @return [Integer] the municipality code of the address
    def munic_code
      @munic_code ||= xy_addr[:munic_code].to_i
    end

    # @return [Float] the latitude of the address
    def lat
      @lat ||= latlong[:lat]
    end

    # @return [Float] the longitude of the address
    def long
      @long ||= latlong[:long]
    end

    # Constructs and returns a {Municipality} object. Makes one SOAP request.
    # @return [Municipality]
    def municipality
      @municipality ||= Municipality.new_with_code(munic_code)
    end

    private

    def latlong
      return @latlong if defined? @latlong
      body = latlong_client.
             call(:get_lat_long_dec_from_xy,
                  message: { 'X' => x.to_s, 'Y' => y.to_s} ).
             body

      resp = body[:get_lat_long_dec_from_xy_response]
      result = resp[:get_lat_long_dec_from_xy_result]
      double = result[:double]

      @latlong = {
        long: double[0].to_f,
        lat: double[1].to_f
      }
    end

    def xy_addr
      return @xy_addr if defined? @xy_addr

      body = addr_xy_client.
             call(:xy_address, message: { myAddress: address}).
             body

      if body[:xy_address_response][:xy_address_result][:count] == '0'
        raise MiamiDadeGeo::InvalidAddressError
      end

      @xy_addr = body[:xy_address_response][:xy_address_result][:xy][:arr_xy]
    end

    def addr_xy_client
      AddrXyClient.instance.savon
    end

    def latlong_client
      LatlongClient.instance.savon
    end
  end
end
