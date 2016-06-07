require 'singleton'
require 'savon'

module MiamiDadeGeo
  # Singleton SOAP client for finding features close to a given point.
  # Makes one SOAP request for WSDL on first instantiation.
  #
  # @api private
  class GetClosestFeatureClient
    include Singleton

    # URL to GetClosestFeature service WSDL
    WSDL_URL =
      "http://gisws.miamidade.gov/gisxyservices/GetClosestFeature.asmx?wsdl"

    # Returns a Savon SOAP client instance
    #
    # @return [Savon::Client]
    def savon
      @savon ||= Savon.client(wsdl: WSDL_URL)
    end
  end
end
