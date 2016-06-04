require 'singleton'
require 'savon'

module MiamiDadeGeo
  class GetClosestFeatureClient
    include Singleton

    WSDL_URL = "http://gisws.miamidade.gov/gisxyservices/GetClosestFeature.asmx?wsdl"

    def savon
      @savon ||= Savon.client(wsdl: WSDL_URL)
    end
  end
end
