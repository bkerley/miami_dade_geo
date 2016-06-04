$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'vcr'

VCR.configure do |vcr|
  vcr.cassette_library_dir = 'spec/cassettes'
  vcr.hook_into :webmock
  vcr.configure_rspec_metadata!
  vcr.default_cassette_options = {
    allow_playback_repeats: true,
    record: :new_episodes
  }
end

RSpec.configure do |rspec|
  rspec.order = 'rand'
end
