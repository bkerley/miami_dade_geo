require 'spec_helper'
require 'miami_dade_geo/address'

describe MiamiDadeGeo::Address, :vcr do
  let(:panther_address){ "2390 NW 2nd Ave" }

  let(:panther_xy){ { x: 919623.87509118, y: 533780.31245147 } }
  let(:panther_zip){ 33127 }
  let(:panther_munic_code){ 1 }

  let(:panther_latlong){ { lat: -80.199245566240819, long: 25.7999410593211 } }

  subject{ described_class.new panther_address }

  it 'is creatable with a Miami-Dade County street address' do
    expect{ address = described_class.new panther_address }.to_not raise_error
  end

  it 'has x-y coordinates' do
    expect(subject.x).to eq panther_xy[:x]
    expect(subject.y).to eq panther_xy[:y]
  end

  it 'has a zip code' do
    expect(subject.zip).to eq panther_zip
  end

  it 'has a municipality' do
    expect(subject.munic_code).to eq panther_munic_code
    expect(subject.municipality.name).to match /^Miami$/i
  end

  it 'has a latitude and longitude' do
    expect(subject.lat).to eq panther_latlong[:lat]
    expect(subject.long).to eq panther_latlong[:long]
  end
end
