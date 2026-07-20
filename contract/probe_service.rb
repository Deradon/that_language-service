# frozen_string_literal: true

# The service side of the contract.
#
# Speaks HTTP to a running service and emits the same canonical format as
# probe_core.rb. Deliberately stdlib-only: it must not load that_language, or
# it would be able to answer from the core gem it is supposed to be checking.
#
# Only GET is exercised. Every route is registered for both verbs by one
# `route :get, :post` call, so POST cannot diverge without GET diverging too --
# and bin/smoke in the image repository already asserts both verbs answer 200.
# Restating that here would be duplicated coverage.

require 'json'
require 'net/http'
require 'uri'

require_relative 'canonical'

base = ARGV.fetch(0) { abort('usage: probe_service.rb BASE_URL') }

payloads = Canonical::ENDPOINTS.to_h do |endpoint|
  uri = URI.join(base, "/#{endpoint}")
  uri.query = URI.encode_www_form(text: Canonical::TEXT)

  response = Net::HTTP.get_response(uri)
  abort("#{uri} answered #{response.code}, expected 200:\n#{response.body}") unless response.is_a?(Net::HTTPSuccess)

  [endpoint, JSON.parse(response.body)]
end

puts Canonical.emit(payloads)
