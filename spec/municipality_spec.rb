require 'spec_helper'
require 'miami_dade_geo/municipality'

describe MiamiDadeGeo::Municipality, :vcr do
  let(:miami_name_regexp){ /^Miami$/i }
  let(:miami_code){ 1 }
  it 'is creatable with a municipality name'
  it 'is creatable with x and y coordinates'
  it 'is creatable with a municipality code' do
    expect(described_class.new_with_code(miami_code).name).
      to match(miami_name_regexp)
  end
end
