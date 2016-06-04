require 'singleton'
require 'savon'

module MiamiDadeGeo
  class GeoAttributeClient
    include Singleton

    WSDL_URL = "http://gisws.miamidade.gov/gisdata/GeoAttribute.asmx?wsdl"
    
    def savon
      @savon ||= Savon.client(wsdl: WSDL_URL)
    end
  end
end
