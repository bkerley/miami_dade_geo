require 'spec_helper'
require 'miami_dade_geo/coordinate'

describe MiamiDadeGeo::Coordinate, :vcr do

  let(:panther_xy){ { x: 919623.87509118, y: 533780.31245147 } }
  let(:panther_latlong){ { long: -80.199245566240819, lat: 25.7999410593211 } }

  it 'turns xy coordinates into latlong' do
    coord = described_class.new panther_xy
    expect(coord.lat).to be_within(0.001).of(panther_latlong[:lat])
    expect(coord.long).to be_within(0.001).of(panther_latlong[:long])
  end

  it 'turns latlong coordinates into xy' do
    coord = described_class.new panther_latlong
    expect(coord.x).to be_within(0.001).of(panther_xy[:x])
    expect(coord.y).to be_within(0.001).of(panther_xy[:y])
  end

  it 'turns coordinates into an address' do
    coord = described_class.new panther_latlong
    expect(coord.address).to be
  end
end
