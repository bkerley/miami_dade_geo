require 'singleton'
require 'savon'

module MiamiDadeGeo
  # Singleton SOAP client for searching geographic attributes. Used to search
  # for municipalities by name or `munic_code`. Makes one SOAP request for WSDL
  # on first instantiation.
  #
  # @api private
  class GeoAttributeClient
    include Singleton

    # URL to GeoAttribute service WSDL
    WSDL_URL = "http://gisws.miamidade.gov/gisdata/GeoAttribute.asmx?wsdl"

    # Performs a search for geo-attributes.
    #
    # @param [String] table the table to search
    # @param [String] field_name the field/column to search in the given table
    # @param [String] value string value to search in the given field and table
    # @return [Hash] search results
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

    # Returns a Savon SOAP client instance
    #
    # @return [Savon::Client]
    def savon
      @savon ||= Savon.client(wsdl: WSDL_URL)
    end
  end
end
