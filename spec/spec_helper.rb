$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

# Must be set before Sinatra is loaded. Sinatra 4 defaults to the development
# environment, whose Rack::Protection::HostAuthorization allow-list covers only
# localhost -- so rack-test's default "example.org" host is rejected outright.
# The test environment applies no host allow-list, which is also what a real
# deployment behind an arbitrary domain gets.
ENV["APP_ENV"] ||= "test"

require 'that_language/service'
