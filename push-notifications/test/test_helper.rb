require 'bundler'
Bundler.require(:test)
require 'minitest/autorun'
#require "mocha/setup"

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :webmock
end
