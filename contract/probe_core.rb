# frozen_string_literal: true

# The core-gem side of the contract.
#
# Builds what each endpoint's payload *should* be, straight from the core gem,
# and emits it in the canonical format. This side is the reference: whatever the
# core gem returns is the contract, which is why contract/gemfiles/core.gemfile
# resolves it from rubygems rather than from a checkout.
#
# Every payload goes through JSON.parse(...to_json). That round trip is not
# incidental tidying -- it *is* the contract being asserted. It is what turns
# core's symbols into the strings the wire carries, and doing it explicitly
# here means the comparison is against a stated projection rather than against
# whatever the service happens to send.
#
# See contract/canonical.rb for what equality means when JSON has no symbols.

require 'that_language'

require_relative 'canonical'

TEXT = Canonical::TEXT

detected = ThatLanguage.detect(TEXT)

# Read the projected attributes off the Result individually rather than calling
# to_h and slicing. Result#to_json takes no arguments, so a Result nested inside
# another structure raises ArgumentError on serialization -- building a plain
# hash of scalars sidesteps that entirely.
detect = Canonical::DETECT_PROJECTION.to_h do |attribute|
  [attribute, detected.public_send(attribute)]
end

payloads = {
  'language' => { language: ThatLanguage.language(TEXT) },
  'language_code' => { language_code: ThatLanguage.language_code(TEXT) },
  'detect' => detect,
  'details' => ThatLanguage.details(TEXT),
  'available' => { available: ThatLanguage.available },
  'available_languages' => { available_languages: ThatLanguage.available_languages },
  'available_language_codes' => { available_language_codes: ThatLanguage.available_language_codes },

  # ThatLanguage::VERSION, not ThatLanguage::Service::VERSION. The endpoint
  # reports the *core* gem's version, which is what this line pins.
  #
  # That is a real question spanning three repositories -- the client documents
  # its `api_version` as "the remote service's version", which this makes wrong
  # -- and it is invisible today only because both gems are 0.2.0. It is
  # recorded rather than silently corrected: see the project's decision note on
  # the wire-format contract. This probe therefore pins *current* behaviour on
  # purpose. If the endpoint is later changed to report the service's own
  # version, this line is the one that must change with it.
  'version' => { version: ThatLanguage::VERSION }
}

projected = payloads.transform_values { |body| JSON.parse(body.to_json) }

puts Canonical.emit(projected)
