require 'singleton'
require 'savon'

module MiamiDadeGeo
  # Singleton SOAP client for converting NAD 83 x-y coordinates to latitude and
  # longitude, and back again. Makes one SOAP request for WSDL on first
  # instantiation.
  #
  # @api private
  class LatlongClient
    include Singleton

    # URL to XyLatLongConversions SOAP service WSDL
    WSDL_URL =
      "http://gisws.miamidade.gov/gisxyservices/XYLatLongConversions.asmx?wsdl"

    # Returns a Savon SOAP client instance
    #
    # @return [Savon::Client]
    def savon
      @savon ||= Savon.client(wsdl: WSDL_URL)
    end
  end
end
