require 'singleton'
require 'savon'

module MiamiDadeGeo
  # Singleton SOAP client for converting an address to NAD 83 x-y coordinates.
  # Makes one SOAP request for WSDL on first instantiation.
  #
  # @api private
  class AddrXyClient
    include Singleton

    # URL to AddrXy service WSDL
    WSDL_URL = "http://gisws.miamidade.gov/gisaddress/addrxy.asmx?wsdl"

    # Returns a Savon SOAP client instance
    #
    # @return [Savon::Client]
    def savon
      @savon ||= Savon.client(wsdl: WSDL_URL)
    end
  end
end
