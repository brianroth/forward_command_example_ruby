ENV["RACK_ENV"] = "test"

if RUBY_PLATFORM != "java"
  require "simplecov"
  SimpleCov.start
end

require 'rubygems'
require 'bundler'

Bundler.require

require "./weather"

require "webmock/rspec"
require "rack/test"
require "vcr"

module RSpecMixin
  include Rack::Test::Methods
  def app
    Weather
  end
end

RSpec.configure do |config|
  config.include RSpecMixin
  config.include Rack::Test::Methods
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end
