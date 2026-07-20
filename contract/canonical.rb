# frozen_string_literal: true

require 'json'

# The canonical probe format, shared by both sides of the contract test.
#
# This file is required by probe_core.rb and probe_service.rb alike, and the
# sharing is the point: the flattening and the invariants are the one piece of
# logic that MUST be identical on both sides. Two copies that drifted would
# produce a green diff for the wrong reason -- the failure mode this whole test
# exists to prevent, reintroduced inside the test itself.
#
# The only thing the two probes do differently is obtain their payloads. One
# calls the core gem, the other speaks HTTP. Everything after that is here.
#
# == What equality means when JSON has no symbols
#
# The client's contract test can assert types directly: both sides return Ruby
# values, so `inspect` renders `:German` and `"German"` differently and a plain
# diff catches symbol/string drift with no type-checking code.
#
# That does not transfer. The service answers in JSON, and JSON has no symbols
# -- every symbol arrives as a string. The type distinction is erased by the
# wire, so it cannot be asserted across it.
#
# The contract that *is* checkable, and the one that actually matters:
#
#   The service's payload equals the JSON projection of the core gem's return
#   value -- JSON.parse(response.body) == JSON.parse(<core value>.to_json)
#
# That is exactly what lets a client reconstruct core's types on the far side,
# so it is the real contract rather than a weakened stand-in for one.
#
# It has a consequence worth stating, because it is easy to over-trust the
# diff: payload equality proves the two sides *agree*, not that either is
# *correct*. They could agree while both being unsorted. Sortedness, ranking
# and the /detect key set are therefore asserted separately, as INVARIANT lines
# computed from the payloads by identical code on both sides.
module Canonical
  # /detect is deliberately narrower than Result#to_h: three keys, not seven.
  #
  # Stated here as data so the subset is a decision recorded in the file rather
  # than a surprise discovered at runtime. A naive "compare /detect against
  # Result#to_h" test fails on its first run and invites someone to paper over
  # it; this pins the projection instead.
  #
  # It is pinned in both directions. A service that started returning all seven
  # keys is drift too, and reddens the `detect.keys` invariant.
  DETECT_PROJECTION = [:language, :language_code, :confidence].freeze

  # Keys the service owns outright, which the core gem has no counterpart for
  # and therefore cannot be compared against it.
  #
  # /version reports two things: `version` is this gem's own version, and
  # `core_version` is the detection library behind it. Only the second is a
  # projection of a core gem value, so only the second belongs in a contract
  # test. `version` is stripped from both sides here.
  #
  # This is the mirror image of DETECT_PROJECTION above: there the service says
  # *less* than the core gem, here it says *more*. Both are declared as data for
  # the same reason -- so the shape is a decision recorded in this file rather
  # than something discovered when the diff goes red.
  #
  # Stripping it here does not leave it unchecked. `version` is asserted in the
  # service's own spec suite, which is the right home for it: service-owned
  # surface is the one thing those specs *can* meaningfully assert, since the
  # objection to them is that they only ever test this app against itself.
  SERVICE_OWNED = { 'version' => ['version'].freeze }.freeze

  # The eight endpoints, in the order they appear in application.rb.
  ENDPOINTS = %w[
    language
    language_code
    detect
    details
    available
    available_languages
    available_language_codes
    version
  ].freeze

  # Long enough to detect unambiguously, short enough that a human reading a
  # failing diff can see at a glance what the answer should have been.
  TEXT = 'Guten Tag mein Freund, wie geht es dir heute'

  class << self
    # Render payloads as sorted `path<TAB>json` lines, one JSON leaf per line.
    #
    # One leaf per line rather than one endpoint per line: /available alone is
    # ~70 entries, and on a single line any one-language drift produces a diff
    # nobody can read. Flattened, the diff points straight at the key.
    def emit(payloads)
      shared = strip_service_owned(payloads)
      lines = shared.flat_map { |endpoint, body| leaves(endpoint, body) }.sort

      lines + invariants(shared)
    end

  private

    # Applied to both sides, so the core probe need not know these keys exist
    # and the service probe need not pretend they do not.
    def strip_service_owned(payloads)
      payloads.to_h do |endpoint, body|
        owned = SERVICE_OWNED.fetch(endpoint, [])

        [endpoint, body.is_a?(Hash) ? body.except(*owned) : body]
      end
    end

    def leaves(prefix, value, out = [])
      case value
      when Hash
        value.each { |key, nested| leaves("#{prefix}.#{key}", nested, out) }
      when Array
        # Zero-padded so the lines sort numerically rather than lexically --
        # otherwise index 10 sorts between 1 and 2 and the diff is unreadable.
        value.each_with_index do |nested, index|
          leaves(format('%<prefix>s.%<index>03d', prefix: prefix, index: index), nested, out)
        end
      else
        out << "#{prefix}\t#{value.to_json}"
      end

      out
    end

    # Properties a diff cannot establish on its own. See the note above: two
    # implementations can agree with each other and both be wrong.
    def invariants(payloads)
      languages = payloads.fetch('available_languages').fetch('available_languages')
      codes = payloads.fetch('available_language_codes').fetch('available_language_codes')
      values = payloads.fetch('details').fetch('results').map { |result| result.fetch('value') }

      [
        invariant('available_languages.sorted?', languages == languages.sort),
        invariant('available_language_codes.sorted?', codes == codes.sort),
        invariant('details.results.descending_by_value?', values == values.sort.reverse),
        invariant('detect.keys', payloads.fetch('detect').keys.sort)
      ]
    end

    def invariant(name, value)
      "INVARIANT #{name}\t#{value.to_json}"
    end
  end
end
