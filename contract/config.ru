# frozen_string_literal: true

# Rackup for the contract test's throwaway service instance.
#
# This gem ships its own config.ru; this one adds the boot-time cache warm that
# the deployed image performs. Wordlists load lazily and memoise at module level
# (~0.9 s cold), so warming here -- before `run`, and therefore before puma
# binds the socket -- means a service that answers at all is already warm.
#
# That is what makes polling /version a valid readiness check rather than a
# sleep dressed up as one, and it keeps the ~0.9 s out of the middle of a probe.
require 'that_language/service'

warn '[INFO] Warming the wordlist cache'
ThatLanguage.language_code('Hello world!')
warn "[INFO] Cache warm, #{ThatLanguage.available.size} languages available."

run ThatLanguage::Service::Application
