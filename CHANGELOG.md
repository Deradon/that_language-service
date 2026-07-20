## Unreleased

### Breaking changes

* **`/version` now reports this gem's version under `version`**, and the core
  library's under a new `core_version` key. It previously returned
  `ThatLanguage::VERSION` — the *core* gem's version — under `version` alone,
  from an endpoint whose obvious reading is "the version of this service".

  Nothing observed the difference, because the two gems have been released in
  lockstep and are both 0.2.0. That is exactly why it is being corrected now:
  the change is invisible today and becomes a silent wrong answer the first time
  the gems release independently.

  `that_language-client`'s `ThatLanguage.api_version` reads this key and has
  always been documented as "the remote service's version" — so this makes that
  documentation true rather than requiring a change there.

### Added

* A contract test, `bin/contract`, run as a third CI job. It starts a real
  service from the working tree and asserts that every endpoint serializes
  exactly the JSON projection of the core gem's return value. The spec suite is
  `rack-test` in-process and so can only assert what this app already does;
  this is the check that would notice this app drifting from the gem it exposes.

## 0.2.0 [☰](https://github.com/Deradon/that_language-service/compare/v0.1.3...v0.2.0) (2026-07-20)

Revival release, and the first one that is actually installable: `gem install
that_language-service` previously resolved a core gem that could not run on
Ruby 3+, so it failed at the first request rather than at install.

Note the jump from 0.1.3 to 0.2.0 — it skips 0.1.4 to keep the version aligned
with `that_language` and `that_language-client`, which mirror this gem's API and
move with it.

### Breaking changes

* `required_ruby_version` is now `>= 3.1`.
* The `that_language` dependency is `~> 0.2`, which requires the revived core
  gem. `~> 0.1` was too loose: it resolves to the published 0.1.2, which
  installs cleanly and then raises on the first wordlist load.
* `thin` is no longer a runtime dependency. This gem is a library and the
  deployment picks its own web server; the old `thin ~> 1.6.4` pin is what made
  the gem uninstallable in the first place.

### Enhancements

* Sinatra 1.4.8 → 4.2.1 and Rack 1.6.13 → 3.2.6, on `Sinatra::Base` rather than
  the classic `Sinatra::Application`.
* Gemspec: dropped the `bundler ~> 1.10` development dependency that made
  `bundle install` unsolvable, and modernised the remaining pins.
* CI moved from Travis to GitHub Actions, covering Ruby 3.1 through 4.0.
* The `/version` spec asserts against `ThatLanguage::VERSION` instead of a
  hardcoded string, so it tracks the core gem instead of rotting against it.

All eight endpoints are verified over both GET and POST. The API surface is
unchanged.

## 0.1.3 [☰](https://github.com/Deradon/that_language-service/compare/v0.1.2...v0.1.3) (2016-05-23)

### Bug fixes

* Allow get requests with a referrer from a different domain ([Disable `Rack::Protection::JsonCsrf`](https://github.com/Deradon/that_language-service/pull/2))

### Enhancements

* All routes listen to post and get requests

## 0.1.2 [☰](https://github.com/Deradon/that_language-service/compare/v0.1.0...v0.1.2) (2016-03-13)

### Enhancements

* Fail fast when running specs
* Update gemspec

## 0.1.0 (2015-12-07)

* Initial release
