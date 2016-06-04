require 'miami_dade_geo/geo_attribute_client'

module MiamiDadeGeo
  class Municipality
    attr_reader :name

    def self.new_with_code(munic_code)
      canonicalized_munic_code = "%02d" % [munic_code.to_i]

      body = GeoAttributeClient.instance.savon.
             call(:get_all_fields_records_given_a_field_name_and_value,
                  message: {
                    'strFeatureClassOrTableName' => 'municipality_poly',
                    'strFieldNameToSearchOn' => 'municid',
                    'strValueOfFieldToSearchOn' => canonicalized_munic_code
                  })
             .body

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

      new poly[:name]
    end

    private

    def initialize(name)
      @name = name
    end
  end
end
