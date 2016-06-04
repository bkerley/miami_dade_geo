require 'singleton'
require 'savon'

module MiamiDadeGeo
  class GeoAttributeClient
    include Singleton

    WSDL_URL = "http://gisws.miamidade.gov/gisdata/GeoAttribute.asmx?wsdl"

    def all_fields(table, field_name, value)
      body = savon.
             call(:get_all_fields_records_given_a_field_name_and_value,
                  message: {
                    'strFeatureClassOrTableName' => table,
                    'strFieldNameToSearchOn' => field_name,
                    'strValueOfFieldToSearchOn' => value
                  }).
             body

      resp = body[:get_all_fields_records_given_a_field_name_and_value_response]
      rslt = resp[:get_all_fields_records_given_a_field_name_and_value_result]
      polys = rslt[:diffgram][:document_element][:municipality_poly]

      poly = if polys.is_a? Array
               polys.first
             elsif polys.is_a? Hash
               polys
             else
               fail "Unexpected polys #{polys.class.name}, wanted Array or Hash"
             end
    end
    
    def savon
      @savon ||= Savon.client(wsdl: WSDL_URL)
    end
  end
end
