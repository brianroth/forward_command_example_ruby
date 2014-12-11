source "https://rubygems.org"

gem "rack-contrib"
gem "rack-attack"
gem "rack-ssl"
gem "sinatra", require: "sinatra/base"
gem "sinatra-contrib"
gem "faraday"
gem "faraday_middleware"
gem "activesupport"

platforms :ruby do
  gem "unicorn"
  gem "simplecov", require: false, group: [:development, :test]
end

platforms :jruby do
  gem "puma"
end

group :development, :test do
  gem "pry"
  gem "webmock"
  gem "rspec"
  gem "rack-test", require: "rack/test"
  gem "vcr"
end
