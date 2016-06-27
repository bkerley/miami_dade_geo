require 'miami_dade_geo/addr_xy_client'
require 'miami_dade_geo/coordinate'
require 'miami_dade_geo/municipality'
require 'miami_dade_geo/errors/invalid_address_error'

module MiamiDadeGeo
  class Address
    attr_reader :address

    def initialize(address)
      @address = address
    end

    def coordinate
      @coordinate ||= Coordinate.new xy_addr
    end

    def x
      coordinate.x
    end

    def y
      coordinate.y
    end

    def zip
      @zip ||= xy_addr[:zip_code].to_i
    end

    def munic_code
      @munic_code ||= xy_addr[:munic_code].to_i
    end

    def lat
      coordinate.lat
    end

    def long
      coordinate.long
    end

    def municipality
      @municipality ||= Municipality.new_with_code(munic_code)
    end

    private

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
  end
end
