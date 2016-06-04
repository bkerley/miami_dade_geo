require 'spec_helper'
require 'miami_dade_geo/municipality'

describe MiamiDadeGeo::Municipality, :vcr do
  let(:miami_name){ 'Miami' }
  let(:miami_name_regexp){ /^Miami$/i }
  let(:miami_code){ 1 }
  let(:panther_xy){ { x: 919623.87509118, y: 533780.31245147 } }
  let(:uninc_mdc_code){ 30 }
  let(:uninc_name_regexp){ /^UNINCORPORATED MIAMI-DADE$/i }

  it 'is creatable with a municipality name' do
    expect(described_class.new_with_name(miami_name).name).
      to match(miami_name_regexp)
  end

  it 'is creatable with x and y coordinates' do
    expect(described_class.new_with_xy(panther_xy).name).
      to match(miami_name_regexp)
  end

  it 'is creatable with a municipality code' do
    expect(described_class.new_with_code(miami_code).name).
      to match(miami_name_regexp)
  end

  it 'supports municipalities with multiple polygons' do
    expect(described_class.new_with_code(uninc_mdc_code).name).
      to match(uninc_name_regexp)
  end
end
