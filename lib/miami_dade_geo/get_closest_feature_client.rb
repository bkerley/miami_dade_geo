require 'singleton'
require 'savon'

module MiamiDadeGeo
  class GetClosestFeatureClient
    include Singleton

    WSDL_URL = "http://gisws.miamidade.gov/gisxyservices/GetClosestFeature.asmx?wsdl"

    FIND_RADIUSES = [0, 100, 1000, 5280, (20 * 5280)]

    def find_feature(xy_hash, feature_class)
      feature = nil
      FIND_RADIUSES.each do |radius|
        p xy_hash
        found = get_closest_feature(feature_class,
                                    xy_hash[:x].to_s,
                                    xy_hash[:y].to_s,
                                    radius.to_s)
        p found
      end
    end

    def get_closest_feature(feature_class, x, y, buffer)
      body = savon.
             call(:get_closest_feature_from_xy_all_atrbts,
                  message: {
                    'X' => x,
                    'Y' => y,
                    'Buffer' => buffer,
                    'NameOfFeatureClass' => feature_class
                  }).
             body

      p body

      resp = body[:get_closest_feature_from_xy_all_atrbts_response]
      rslt = resp[:get_closest_feature_from_xy_all_atrbts_result]
      poly = rslt[:diffgram][:document_element]
    end

    def savon
      @savon ||= Savon.client(wsdl: WSDL_URL)
    end
  end
end
