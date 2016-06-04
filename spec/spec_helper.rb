$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'miami_dade_geo'

require 'vcr'

VCR.configure do |vcr|
  vcr.cassette_library_dir = 'spec/cassettes'
  vcr.hook_into :webmock
  vcr.configure_rspec_metadata!
end
