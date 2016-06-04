require 'singleton'
require 'savon'

module MiamiDadeGeo
  class AddrXyClient
    include Singleton

    WSDL_URL = "http://gisws.miamidade.gov/gisaddress/addrxy.asmx?wsdl"
    
    def savon
      @savon ||= Savon.client(wsdl: WSDL_URL)
    end
  end
end
