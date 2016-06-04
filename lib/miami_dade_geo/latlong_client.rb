require 'singleton'
require 'savon'

module MiamiDadeGeo
  class LatlongClient
    include Singleton

    WSDL_URL =
      "http://gisws.miamidade.gov/gisxyservices/XYLatLongConversions.asmx?wsdl"
    
    def savon
      @savon ||= Savon.client(wsdl: WSDL_URL)
    end
  end
end
