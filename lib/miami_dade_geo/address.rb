require 'miami_dade_geo/addr_xy_client'
require 'miami_dade_geo/coordinate'
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

    private_class_method :new

    attr_reader :feature

    # @!attribute [r] address
    # @return [String] the street address
    attr_reader :address

    # @!attribute [rw] zip
    # @return [String] the ZIP code
    attr_accessor :zip

    # Construct the address object
    # @param address [String] the street address
    def self.new_from_address(address)
      xy = AddrXyClient.instance.xy_for_address(address)

      Coordinate.new(xy).address
    end

    def self.new_from_feature(feature)
      new feature
    end

    # @return [Coordinate] a coordinate object representing where this address
    # even is
    def coordinate
      @coordinate ||= Coordinate.new xy_addr
    end

    # @return [Float] the x-coordinate of the address
    def x
      coordinate.x
    end

    # @return [Float] the y-coordinate of the address
    def y
      coordinate.y
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
      coordinate.lat
    end

    # @return [Float] the longitude of the address
    def long
      coordinate.long
    end

    # Constructs and returns a {Municipality} object. Makes one SOAP request.
    # @return [Municipality]
    def municipality
      @municipality ||= Municipality.new_with_code(munic_code)
    end

    def address
      @address ||= [feature[:hse_num], feature[:sname]].join ' '
    end

    private

    def initialize(feature)
      @feature = feature
    end

    def xy_addr
      return @xy_addr if defined? @xy_addr

      @xy_addr = addr_xy_client.xy_for_address(address)
    end

    def addr_xy_client
      AddrXyClient.instance
    end
  end
end
